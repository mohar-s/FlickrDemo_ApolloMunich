//
//  FlickrImageDetailsViewController.swift
//  FlickerDemo
//
//  Created by RailYatri on 07/02/19.
//  Copyright © 2019 MoharSingh. All rights reserved.
//

import UIKit
import FlickrKit
import SDWebImage

class FlickrImageDetailsViewController: UIViewController {

    @IBOutlet weak var flickerIV: UIImageView!
    @IBOutlet weak var discriptionLbl: UILabel!
    
    var photoData : [String: AnyObject]!

    var discStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let photoURL = FlickrKit.shared().photoURL(for: .small320, fromPhotoDictionary: photoData)
        flickerIV.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "loading_image.png"))
        
//        farm = 5;
//        id = 40043946423;
//        isfamily = 0;
//        isfriend = 0;
//        ispublic = 1;
//        owner = "134389822@N04";
//        secret = 039b1d4c23;
//        server = 4911;
//        title = "Make A Wish";
        
        discStr = "Title:\n"
        discStr = discStr + (photoData["title"]! as! String) + "\n\n"
        discStr = discStr + "Owner:\n"
        discStr = discStr + (photoData["owner"]! as! String) + "\n\n"
        discStr = discStr + "Secret:\n"
        discStr = discStr + (photoData["secret"]! as! String) + "\n\n"
        discStr = discStr + "Id:\n"
        discStr = discStr + (photoData["id"]! as! String) + "\n\n"
        discStr = discStr + "Server:\n"
        discStr = discStr + (photoData["server"]! as! String) + "\n\n"
        
        discStr = discStr + "Isfamily: "
        discStr = discStr + ((photoData["isfamily"]! as! Int) == 0 ? "no" : "yes") + " ,   "
        discStr = discStr + "Isfriend: "
        discStr = discStr + ((photoData["isfriend"]! as! Int) == 0 ? "no" : "yes") + "\n\n"
        discStr = discStr + "Ispublic:    "
        discStr = discStr + ((photoData["ispublic"]! as! Int) == 0 ? "no" : "yes") + ""
        
        discriptionLbl.text = discStr
        
        // Do any additional setup after loading the view.
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
