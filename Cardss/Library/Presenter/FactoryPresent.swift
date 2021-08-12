//
//  FactoryPresent.swift
//  Cardss
//
//  Created by VITALIY SVIRIDOV on 12.08.2021.
//

import Foundation
import UIKit

protocol FactoryPresentProtocol {
    func switchToSecond(toModule module: Modules)
}

enum Modules {
    case cards
    case statistics
    case settings
    case education
}

class FactoryPresent: FactoryPresentProtocol {
    
    private func getModule(by type: Modules) -> UIViewController {
        switch type {
        case .cards: return CardsViewController()
        case .statistics: return StatisticsViewController()
        case .settings: return SettingViewController()
        case .education: return EducationViewController()
        }
    }
    
    func switchToSecond(toModule module: Modules) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        let screen = getModule(by: module)
        sceneDelegate.window?.rootViewController = screen
        sceneDelegate.window?.makeKeyAndVisible()
    }
}
