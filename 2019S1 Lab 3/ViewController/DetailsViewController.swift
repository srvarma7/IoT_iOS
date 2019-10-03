//
//  DetailsViewController.swift
//  2019S1 Lab 3
//
//  Created by Ganesh Kanchibhotla on 2/10/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit


class DetailsViewController: UIViewController {

    var currentData = SensorData()
    
    @IBOutlet weak var isoDateLabel: UILabel!
    @IBOutlet weak var unixtimeLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isoDateLabel.text = currentData.date
        unixtimeLabel.text = currentData.unixTime
        redLabel.text = currentData.red
        blueLabel.text = currentData.blue
        greenLabel.text = currentData.green
        tempLabel.text = currentData.temperature
        pressureLabel.text = currentData.pressure
        altitudeLabel.text = currentData.altitude
    }
}
