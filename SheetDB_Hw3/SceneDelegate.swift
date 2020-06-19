//
//  SceneDelegate.swift
//  SheetDB_Hw3
//
//  Created by Joker on 2020/5/7.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let context = persistentContainer.viewContext
        let contentView = MyTabView().environment(\.managedObjectContext, context)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
//    func sceneDidEnterBackground(_ scene: UIScene) {
//        // Called as the scene transitions from the foreground to the background.
//        // Use this method to save data, release shared resources, and store enough scene-specific state information
//        // to restore the scene back to its current state.
//    }
    // 1
    lazy var persistentContainer: NSPersistentContainer = {
        // 2
        let container = NSPersistentContainer(name: "SheetDB_Hw3")
        // 3
        container.loadPersistentStores { _, error in
            // 4
            if let error = error as NSError? {
                // You should add your own error handling code here.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    func saveContext() {
        // 1
        let context = persistentContainer.viewContext
        // 2
        if context.hasChanges {
            do {
                // 3
                try context.save()
            } catch {
                // 4
                // The context couldn't be saved.
                // You should add your own error handling here.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        saveContext()
    }
}


