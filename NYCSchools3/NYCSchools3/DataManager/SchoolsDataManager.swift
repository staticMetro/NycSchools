//
//  SchoolsDataManager.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/19/22.
//

import Foundation

enum SchoolsDataManagingResponseStatus<T> {
    case initial
    case loading
    case failed(NSError)
    case success(T)
}

protocol SchoolsDataManaging {
    func fetchSchools(completion: @escaping (SchoolsDataManagingResponseStatus<[SchoolModel]>) -> Void)
    func fetchSAT(completion: @escaping (SchoolsDataManagingResponseStatus<[SATScoreModel]>) -> Void)
}

struct SchoolsDataManager: SchoolsDataManaging {

    private struct Constant {
        // swiftlint:disable nesting
        struct URL {
            static let schoolsURLString = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
            static let satScoreURLString = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
        }
        // swiftlint:enable nesting
    }

    func fetchSchools(completion: @escaping (SchoolsDataManagingResponseStatus<[SchoolModel]>) -> Void) {
        fetchData(urlString: Constant.URL.schoolsURLString, modelType: SchoolModel.self, completion: { completion($0) })
    }

    func fetchSAT(completion: @escaping (SchoolsDataManagingResponseStatus<[SATScoreModel]>) -> Void) {
        fetchData(urlString: Constant.URL.satScoreURLString, modelType: SATScoreModel.self,
                  completion: { completion($0) })
    }

    private func fetchData<T: Decodable>(urlString: String, modelType: T.Type,
                                         completion: @escaping (SchoolsDataManagingResponseStatus<[T]>) -> Void) {

        guard let urlLink = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        else {
            completion(.failed(NSError(domain: "Error: cannot create URL", code: 10001)))
            return
        }

        guard let url = URL(string: urlLink) else {
            completion(.failed(NSError(domain: "Error: cannot create URL", code: 10001)))
            return
        }
        completion(.loading)
        URLSession.shared.dataTask(with: url, completionHandler: {(responseData, _, error) in
            guard let rawData = responseData else {
                completion(.failed(NSError(domain:
                                            "Error: Something went wrong, please try it again later", code: 10002)))
                return
            }

            do {
                let data = try JSONDecoder().decode([T].self, from: rawData)
                completion(.success(data))
            } catch let error {
                completion(.failed(NSError(domain:
                "Error: Something went wrong, please try it again later. Message: \(error.localizedDescription)",
                                           code: 10002)))
            }
        }).resume()
    }
}
