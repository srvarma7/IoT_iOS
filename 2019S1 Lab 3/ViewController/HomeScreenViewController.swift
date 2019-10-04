//
//  HomeScreenViewController.swift
//  2019S1 Lab 3
//
//  Created by Ganesh Kanchibhotla on 2/10/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit
import CoreLocation

struct JsonResponse: Codable {
    let name: String
    let id: Int
    let weather: [Weather]
    let main: TempPressure
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct TempPressure: Codable {
    let temp: Double
    let pressure: Double
}

class HomeScreenViewController: UIViewController, DatabaseListener, CLLocationManagerDelegate {
    
    @IBOutlet weak var top: UIImageView!
    @IBOutlet weak var btm: UIImageView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var btmTempLabel: UILabel!
    

    @IBOutlet weak var apiDescLabel: UILabel!
    @IBOutlet weak var apiTemp: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var apiIcon: UIImageView!
    @IBOutlet weak var apiLocationName: UILabel!
    
    
    
    var lat = "-37.87"
    var long = "145.04"
    var currentLocation: CLLocationCoordinate2D?
    var locationMng = CLLocationManager()
    var apiData = JsonResponse.self
    var temp: Float = 0.0
    var latestData = SensorData()
    weak var databaseController: DatabaseProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TESTING GIF
        //imageView.loadGif(name: "tCN")
        locationMng.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationMng.distanceFilter = 10
        locationMng.delegate = self
        locationMng.requestAlwaysAuthorization()
        locationMng.startUpdatingLocation()
        
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate!.databaseController
        // Do any additional setup after loading the view.
        getDataFromUrl()
        
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
            btmTempLabel.text = latestData.temperature + " °C"
            //var time: String = latestData.iSODate.substring(to: T##String.Index)
            //print(latestData.iSODate.substring())
            timeLabel.text = "Last refreshed at " + latestData.time
            //loadMoodAndTemp()
            
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        UIView.animate(withDuration: 1, animations: {
//        //self.imageView.transform = CGAffineTransform(translationX: 0, y: 200)
//        })
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        UIView.animate(withDuration: 1, animations: {
//            self.imageView.transform = CGAffineTransform(translationX: 0, y: -200)
//        })
//    
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        databaseController?.addListener(listener: self)
        
        
        
        top.image = UIImage(named: "40x40.png")
        
        UIView.animate(withDuration: 3, animations: {
            self.top.backgroundColor = UIColor(red: 197/255, green: 26/255, blue: 74/255, alpha: 1)
            self.top.layer.cornerRadius = (self.top.frame.size.width)/2
            self.top.clipsToBounds = true
            
            //self.apiTemp.text = self.latestData.temperature + " °C"
            self.apiLocationName.transform = CGAffineTransform(translationX: 0, y: -20)
            //self.apiIcon.backgroundColor = .white
            self.apiDescLabel.transform = CGAffineTransform(translationX: 0, y: 135)
            self.apiTemp.transform = CGAffineTransform(translationX: 0, y: 175)
            self.apiIcon.transform = CGAffineTransform(translationX: 0, y: 215)
        })
        
        btm.image = UIImage(named: "40x40.png")
        
        UIView.animate(withDuration: 3, animations: {
            self.btm.backgroundColor = UIColor(red: 197/255, green: 26/255, blue: 74/255, alpha: 1)
            self.btm.layer.cornerRadius = (self.btm.frame.size.width)/2
            self.btm.clipsToBounds = true
            
            UIView.animate(withDuration: 3, animations: {
                self.btmTempLabel.text = self.latestData.temperature + " °C"
                self.btmTempLabel.transform = CGAffineTransform(translationX: 0, y: -175)
            })
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        databaseController?.removeListener(listener: self)
//        UIView.animate(withDuration: 1, animations: {
//            self.imageView.transform = CGAffineTransform(translationX: 0, y: 200)
//        })
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
    
    func getDataFromUrl() {
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + long + "&appid=3af463d5d4d7916e155dd605e37db688")
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            if let data = data {
                print(data)
                let resp = try? JSONDecoder().decode(JsonResponse.self, from: data)
                print(self.lat + self.long)
                let d: Double = round((resp?.main.temp)!)
                let intTemp = Int(d)
                DispatchQueue.main.async {
                    self.makeGetRequestImage(icon: (resp?.weather[0].icon)!)
                    self.apiLocationName.text = resp?.name
                    self.apiDescLabel.text = resp?.weather[0].description
                    //self.apiDescLabel.textColor = .white
                    self.apiTemp.text = String(format: "%i", intTemp - 273) + " °C"
                }
            }
            }.resume()
    }
    
    func makeGetRequestImage(icon: String){
        let url : String = "https://openweathermap.org/img/wn/" + icon + "@2x.png"
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url) as URL?
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse!, data: Data!, error: Error!) -> Void in
            DispatchQueue.main.async { // Correct
                self.apiIcon.backgroundColor = .clear
                self.apiIcon.image = UIImage(data: data)
                
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        currentLocation = location.coordinate
        lat = String(format: "%f", currentLocation!.latitude)
        long = String(format: "%f", currentLocation!.longitude)
        print(lat + long)
        getDataFromUrl()
    }

}
