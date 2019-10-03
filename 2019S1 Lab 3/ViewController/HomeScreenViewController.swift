//
//  HomeScreenViewController.swift
//  2019S1 Lab 3
//
//  Created by Ganesh Kanchibhotla on 2/10/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, DatabaseListener {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var temp: Float = 0.0
    var latestData = SensorData()
    weak var databaseController: DatabaseProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TESTING GIF
        //imageView.loadGif(name: "tCN")
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate!.databaseController
        // Do any additional setup after loading the view.
        
    }
    
    var listenerType = ListenerType.data
    
    func onDataListChange(change: DatabaseChange, dataList: [SensorData]) {
        var datalist = dataList
        datalist.sort(by: {$0.unixTime > $1.unixTime})
        print("in home screen", dataList.count)
        if !dataList.isEmpty{
            latestData = datalist[datalist.startIndex]
            temp = Float(latestData.temperature)! as! Float
            print(temp, " In home controller")
            loadImageAndMood(temp: temp)
            tempLabel.text = latestData.temperature + " °C"
            //var time: String = latestData.iSODate.substring(to: <#T##String.Index#>)
            //print(latestData.iSODate.substring())
            timeLabel.text = "Last refreshed at " + latestData.time
            //loadMoodAndTemp()
            
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        databaseController?.removeListener(listener: self)
        
    }
    
    func loadImageAndMood(temp: Float) {
        if (temp <= 8) {
            imageView.loadGif(name: "tC")
            moodLabel.text = "Feeling Cold"
        }
        else if (temp > 8 && temp <= 15) {
            imageView.loadGif(name: "tCN")
            moodLabel.text = "Shivering"
        }
        else if (temp > 15 && temp <= 25) {
            imageView.loadGif(name: "tN")
            moodLabel.text = "Feeling Happy"
        }
        else if (temp > 25 && temp <= 31) {
            imageView.loadGif(name: "tNH")
            moodLabel.text = "Sweaty"
        }
        else {
            imageView.loadGif(name: "tH")
            moodLabel.text = "Feeling Hot"
        }
    }
}

