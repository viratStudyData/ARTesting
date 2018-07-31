//
//  DetailVC.swift
//  ARKit+CoreLocation
//
//  Created by EMILENCE on 23/07/18.
//  Copyright © 2018 Project Dent. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    
    
    @IBOutlet weak var imgVwUser: AsyncImageView!
    
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnShopNow: UIButton!
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var vwContainer: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var dict:[String:AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeading.text = dict["name"] as? String ?? ""
        lblDistance.text = "Dist:\(dict["distance"] as? String ?? "")m"
        self.pageControl.numberOfPages = 6
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changePageContrller(notification:)), name: Notification.Name(rawValue: "ChangePage"), object: nil)
    }
    
    //MARK: Change PageController
    @objc func changePageContrller(notification: NSNotification) {
        let index = notification.userInfo!["index"] as! Int
        pageControl.currentPage = index
    }
    
    
    //MARK: TableView DataSource and Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDetailCell) as! DetailCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func btnCross_Action(_ sender: Any) {
        Utility.remove(asChildViewController: self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: kHideDetailView), object: nil)
    }
    
    @IBAction func btnShopNow_Action(_ sender: Any) {
    }
    
    @IBAction func btnSendAction(_ sender: Any) {
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
