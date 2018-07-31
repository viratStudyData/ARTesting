//
//  Utility.swift
//  ARKit+CoreLocation
//
//  Created by EMILENCE on 23/07/18.
//  Copyright © 2018 Project Dent. All rights reserved.
//

import UIKit

class Utility: NSObject {
    //Add And Remove ViewController
    class func add(asChildViewController obj: UIViewController, containerView: UIView, viewController: UIViewController) {
        // Add Child View Controller
        viewController.addChildViewController(obj)
        
        // Add Child View as Subview
        containerView.addSubview(obj.view)
        
        // Configure Child View
        obj.view.frame = containerView.bounds
        
        obj.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        obj.didMove(toParentViewController: obj)
        
    }
    
    class func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
}
