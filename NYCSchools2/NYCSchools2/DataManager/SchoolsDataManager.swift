//
//  SchoolsDataManager.swift
//  NYCSchools
//
//  Created by Aimeric Tshibuaya on 6/9/22.
//

import Foundation
/*
 API KEY: 980qm08vatbpyidd7felxnrm4
 API KEY Secret: 3ffdzjx9szr9wzmu0aocghmtpy76fas11odritrdih3y8f7emz
 APP Token: ke4ouJojh6vYDs9HeqQHur8oq
 App Secret token: u8kXhwZ2OjOFSqUTRDcQMnkNUGyY22FJxtAY
*/
struct APIURLS {
    static let fetchSchoolsLink = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
    static let fetchSATScoresLink = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
}

class SchoolsDataManager{
    //static let appToken = "ke4ouJojh6vYDs9HeqQHur8oq"
    //static let apiKey = "980qm08vatbpyidd7felxnrm4"

    func fetchData(urlString: String, completionHandler: @escaping (Any?, Error?) -> ()) {
        guard let urlLink = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        else {
            return
        }
        guard let url = URL(string: urlLink) else {
            print("Error: cannot create URL")
            completionHandler([], nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (responseData, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 403 {
                    print("Error: Access Denied.")
                    completionHandler([], error)
                }
            }
            if error != nil {
                print("Error: Received Error.")
                completionHandler([], error)
                return
            }
            guard responseData != nil else {
                print("Error: did not receive data")
                completionHandler([], error)
                return
            }
            completionHandler(responseData, error)
        }
        task.resume()
    }
}
