//
//  AppDelegate.swift
//  Cardss
//
//  Created by Macbook on 22.12.2020.
//

import UIKit
import Realm
import RealmSwift
import GoogleMobileAds
import SwiftyStoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupPurchase()
        setupMigrateRealm()
        setupInterfaceStyle()
        setupGoogleAds()
        return true
    }
    
    // MARK: -UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}
// MARK: -Realm
extension AppDelegate {
    
    func setupInterfaceStyle() {
        UserDefaults.standard.synchronize()
    }
    
    func setupMigrateRealm() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                }
            })
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
}
// MARK:- Google ads
extension AppDelegate {
    func setupGoogleAds() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}

extension AppDelegate {
    func setupPurchase() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                for purchase in purchases {
                    switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        // Unlock content
                    self.setPremium(true)
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                    @unknown default:
                        break // do nothing
                    }
                }
            }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    func setPremium(_ premium: Bool) {
            UserDefaults.standard.synchronize()
            UserDefaults.standard.set(true, forKey: UserDefaults.premium)
        }
}

