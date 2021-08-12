//
//  SceneDelegate.swift
//  Cardss
//
//  Created by Macbook on 22.12.2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private lazy var buttonsView = BottomButtonView()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = ChooseLanguage()
        window?.makeKeyAndVisible()
    }


}

