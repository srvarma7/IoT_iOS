//
//  testViewController.swift
//  2019S1 Lab 3
//
//  Created by Sai Raghu Varma Kallepalli on 3/10/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
    
    @IBOutlet weak var top: UIImageView!
    @IBOutlet weak var btm: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        top.image = UIImage(named: "40x40.png")
        UIView.animate(withDuration: 1, animations: {
            self.top.backgroundColor = UIColor(red: 197/255, green: 26/255, blue: 74/255, alpha: 1)
            self.top.layer.cornerRadius = (self.top.frame.size.width)/2
            self.top.clipsToBounds = true
        })
        
        btm.image = UIImage(named: "40x40.png")
        UIView.animate(withDuration: 1, animations: {
            
            self.btm.backgroundColor = UIColor(red: 197/255, green: 26/255, blue: 74/255, alpha: 1)
            self.btm.layer.cornerRadius = (self.btm.frame.size.width)/2
            self.btm.clipsToBounds = true
        })

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
