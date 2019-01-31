//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Frederik Skytte on 31/01/2019.
//  Copyright © 2019 Frederik Skytte. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    let dataController = DataController(modelName: "Virtual_Tourist")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data Saving support

    func saveContext () {
         try? dataController.viewContext.save()
    }
}

// Give singleton access to dataController
extension UIViewController {

    var dataController:DataController {
        return (UIApplication.shared.delegate as! AppDelegate).dataController
    }
}

