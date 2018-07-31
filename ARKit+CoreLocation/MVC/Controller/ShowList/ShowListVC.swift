//
//  ShowListVC.swift
//  ARKit+CoreLocation
//
//  Created by EMILENCE on 23/07/18.
//  Copyright © 2018 Project Dent. All rights reserved.
//

import UIKit
import CoreLocation
class ShowListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var arrNearByLocations: [[String: AnyObject]]!
    @IBOutlet weak var clcVW: UICollectionView!
    var currentLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: UICollectionVeiw DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNearByLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KShowListCell, for: indexPath) as! ShowListCell
        cell.imgVw.imageURL = URL(string: arrNearByLocations[indexPath.row]["icon"] as! String)
        cell.lblHeading.text = arrNearByLocations[indexPath.row]["name"] as? String ?? ""
        let dict = arrNearByLocations[indexPath.row]
        cell.btnShopNow.tag = indexPath.row
        cell.btnShopNow.addTarget(self, action: #selector(self.btnShowDetailAction(sender:)), for: .touchUpInside)
        cell.lblDistance.text = "Dist:\(String(describing: dict["distance"]!))m"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        self.performSegue(withIdentifier: kChatVCSegue, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width/2.0)-5, height: 208)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnShowDetailAction(sender: UIButton) {
        let index = sender.tag
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let obj = storyBoard.instantiateViewController(withIdentifier: kDetailVC) as! DetailVC
        obj.dict = arrNearByLocations[index]
        Utility.add(asChildViewController: obj, containerView: self.view, viewController: self)
//        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
