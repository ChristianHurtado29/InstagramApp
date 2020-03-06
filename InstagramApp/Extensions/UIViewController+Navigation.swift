//
//  UIViewController+Navigation.swift
//  InstagramApp
//
//  Created by Christian Hurtado on 3/5/20.
//  Copyright © 2020 Christian Hurtado. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // reset window once user logs in
    private static func resetWindow(rootVC: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first,
            let sceneDelegate = scene.delegate as? SceneDelegate,
            let window = sceneDelegate.window else {
                fatalError("could not reset window root view controller")
        }
        window.rootViewController = rootVC
    }
    
    public static func showViewController(storyboardName: String, viewControllerId: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: viewControllerId)
        
        resetWindow(rootVC: newVC)
    }
    
}
