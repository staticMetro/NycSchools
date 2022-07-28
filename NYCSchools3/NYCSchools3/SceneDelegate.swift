//
//  SceneDelegate.swift
//  NYCSchools3
//
//  Created by Aimeric Tshibuaya on 7/18/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var schoolsCoordinator: SchoolsCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let rootNavigationController = UINavigationController()
        let containerViewController = ContainerViewController()
        schoolsCoordinator = SchoolsCoordinator(navigationController: rootNavigationController,
                                                dataManager: SchoolsDataManager(),
                                                containerViewController: containerViewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        schoolsCoordinator?.start()

/*TEST code for error and loading view COntrollers**/
//        window = UIWindow(windowScene: windowScene)
//        let imageView = UIImageView()
//
//        // let viewController = LoadingViewController(loadingImageView: imageView)
//        let viewController = ErrorViewController(loadingImageView: imageView)
//        let navigationController = UINavigationController(rootViewController: viewController)
//
//        window?.rootViewController = navigationController
//        // navigationController = []
//        window?.makeKeyAndVisible()
    }
}
