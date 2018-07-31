//
//  PageVC.swift
//  ARKit+CoreLocation
//
//  Created by EMILENCE on 31/07/18.
//  Copyright © 2018 Project Dent. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate  {

    var pageViewController : UIPageViewController?
    var images = ["1", "2", "3", "4", "5", "6"]
    var pendingIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
    }
    
    //MARK: Create PageViewController
    func createPageViewController() {
        self.dataSource = self
        self.delegate = self
        if images.count > 0 {
            let contentController =  getContentViewController(withIndex: 0)!
            let contentControllers = [contentController]
            self.setViewControllers(contentControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }
    
    func getContentViewController(withIndex index: Int)-> ContentVC? {
        if index < images.count {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "ContentVC") as! ContentVC
            obj.itemIndex = index
            obj.strImgUrl = images[index]
            return obj
        }
        return nil
    }
    
    //MARK: PageViewController DataSource And Delegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let obj = viewController as! ContentVC
        if obj.itemIndex > 0 {
            return getContentViewController(withIndex: obj.itemIndex - 1)
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let obj = viewController as! ContentVC
        if obj.itemIndex + 1 < images.count {
            return getContentViewController(withIndex: obj.itemIndex + 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex =  (pendingViewControllers.first as! ContentVC).itemIndex
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentIndex = pendingIndex
            if let index = currentIndex {
                NotificationCenter.default.post(name: Notification.Name("ChangePage"), object: nil, userInfo: ["index":index])            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
