//
//  AppRouter.swift
//  ISDemo
//
//  Created by Utsav Patel on 3/7/19.
//  Copyright © 2019 erbittuu. All rights reserved.
//

import UIKit

class AppRouter {

    static let shared = AppRouter()

    private class Config {
        weak var appDelegate: AppDelegate?
    }
    private static let config = Config()

    class func setup(appDelegate: AppDelegate) {
        AppRouter.config.appDelegate = appDelegate
    }

    private init() {
        guard AppRouter.config.appDelegate != nil else {
            fatalError("Error - you must call setup before accessing AppRouter.shared")
        }
    }

    private var mainWindow: UIWindow? {
        return AppRouter.config.appDelegate?.window
    }

    func startApp() {
        // Print Environment
        Environment.printEnv()
        MyClass.init().test()
        openHome()
        mainWindow?.makeKeyAndVisible()
    }

    private func openHome() {
        let homeVC: HomeController = UIStoryboard(storyboard: .main).instantiate()
        mainWindow?.switchRootViewController(to: homeVC)
    }
}
