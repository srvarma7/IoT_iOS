//
//  DetailsViewController.swift
//  2019S1 Lab 3
//
//  Created by Ganesh Kanchibhotla on 2/10/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//


//Displays the details from a selected table cell from the table view


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
        unixtimeLabel.text = currentData.time
        redLabel.text = currentData.red
        blueLabel.text = currentData.blue
        greenLabel.text = currentData.green
        tempLabel.text = currentData.temperature + " °C"
        pressureLabel.text = currentData.pressure + " kPa"
        altitudeLabel.text = currentData.altitude + " m"
    }
}
