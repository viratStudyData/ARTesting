//
//  DistanceVC.swift
//  ARKit+CoreLocation
//
//  Created by EMILENCE on 24/07/18.
//  Copyright © 2018 Project Dent. All rights reserved.
//

import UIKit

class DistanceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblMinimumDistance: UILabel!
    @IBOutlet weak var lblMaximumDistance: UILabel!
    @IBOutlet weak var slideBar: UISlider!
    @IBOutlet weak var tblVw: UITableView!
    
    var arrName:[[String:String]] = [["name":"Clothing", "isSelected": "No"], ["name":"Electronics", "isSelected": "No"], ["name":"Footwear", "isSelected": "No"], ["name":"Accessories", "isSelected":"No"], ["name":"Apparels", "isSelected":"No"], ["name":"Cafes and Restaurants", "isSelected":"No"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: Table view Datasource and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDistanceCell) as! DistanceCell
        cell.lblName.text = arrName[indexPath.row]["name"]
        return cell
    }
    
    @IBAction func btnClearAllAction(_ sender: Any) {
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func slideBackAction(_ sender: Any) {
    }
    
    @IBAction func btnApplyAction(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
}
