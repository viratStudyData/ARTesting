//
//  ContentVC.swift
//  ARKit+CoreLocation
//
//  Created by EMILENCE on 31/07/18.
//  Copyright © 2018 Project Dent. All rights reserved.
//

import UIKit

class ContentVC: UIViewController {

    @IBOutlet weak var img: AsyncImageView!
    var itemIndex = 0
    var strImgUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imgUrl = strImgUrl {
//            img.imageURL = URL(string: imgUrl)
            img.image = UIImage(named: imgUrl)
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
