//
//  testViewController.swift
//  2019S1 Lab 3
//
//  Created by Sai Raghu Varma Kallepalli on 3/10/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topImage.loadGif(name: "4")
        bottomImage.loadGif(name: "6")
        //topImage.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
        let overlayView = topImage.image?.withRenderingMode(.alwaysTemplate)
        
        topImage.tintColor = UIColor.yellow
        topImage.image = overlayView
        
        
//        overlayView.frame = topImage.frame
//        overlayView.tintColor = .red
//        overlayView.alpha = 1
//        view.addSubview(overlayView)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
