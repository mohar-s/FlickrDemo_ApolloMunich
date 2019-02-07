//
//  FlickrUtils.swift
//  FlickerDemo
//
//  Created by RailYatri on 06/02/19.
//  Copyright © 2019 MoharSingh. All rights reserved.
//

import UIKit

class FlickrUtils: NSObject {

    
    class func showAlertIn(controller : UIViewController, title : String, message : String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            print("Ok Clicked")
        }))
        controller.present(alert, animated: true, completion: nil)
        
    }
    
}
