//
//  HomeScreenViewController.swift
//  2019S1 Lab 3
//
//  Created by Ganesh Kanchibhotla on 2/10/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit
import CoreLocation

//structures for parsing JSON data from API

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
    
    var apiTemperature = 0
    var lat = "-37.87"
    var long = "145.04"
    var currentLocation: CLLocationCoordinate2D?
    var locationMng = CLLocationManager()
    var apiData = JsonResponse.self
    var temp: Float = 0.0
    var latestData = SensorData()
    var listenerType = ListenerType.data
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationMng.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationMng.distanceFilter = 10
        locationMng.delegate = self
        locationMng.requestAlwaysAuthorization()
        locationMng.startUpdatingLocation()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate!.databaseController
        getDataFromUrl()
    }
    
    
    //listener for the database
    func onDataListChange(change: DatabaseChange, dataList: [SensorData]) {
        var datalist = dataList
        datalist.sort(by: {$0.unixTime > $1.unixTime})
        if !dataList.isEmpty{
            latestData = datalist[datalist.startIndex]
            temp = Float(latestData.temperature)!
            loadImageAndMood(temp: temp)
            btmTempLabel.text = latestData.temperature + " °C"
            timeLabel.text = "Last refreshed at " + latestData.time
            loadImageAndMood(temp: Float(latestData.temperature)!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        databaseController?.addListener(listener: self)
        
        top.image = UIImage(named: "40x40.png")
        UIView.animate(withDuration: 3, animations: {
            self.top.backgroundColor = UIColor(red: 197/255, green: 26/255, blue: 74/255, alpha: 1)
            self.top.layer.cornerRadius = (self.top.frame.size.width)/2
            self.top.clipsToBounds = true
            
            self.apiLocationName.transform = CGAffineTransform(translationX: 0, y: -20)
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
    }
    
    //a method that chnages the mood , description and other text changes when called
    func loadImageAndMood(temp: Float) {
        if (temp <= 8) {
            imageView.loadGif(name: "tC")
            moodLabel.text = "Feeling Cold"
            if(apiTemperature < Int(temp)) {
                descLabel.text = "Looks like you room is warmer than outside. Wear a jacket if you are going out... Stay at home unless you are Iceman ;P"
            }
            else {
                descLabel.text = "Looks like you room is colder than outside. May be turn up the heater... Else good luck with making ice"
            }
        }
        else if (temp > 8 && temp <= 15) {
            imageView.loadGif(name: "tCN")
            moodLabel.text = "Shivering"
            if(apiTemperature < Int(temp)) {
                descLabel.text = "Looks like you room is warmer than outside. Wear a jacket if you are going out..."
            }
            else {
                descLabel.text = "Looks like you room is colder than outside. May be turn up the heater..."
            }
        }
        else if (temp > 15 && temp <= 25) {
            imageView.loadGif(name: "tN")
            moodLabel.text = "Feeling Happy"
            if(apiTemperature < Int(temp)) {
                descLabel.text = "Looks like you room is warmer than outside. Nice weather for a casual walk..."
                
            }
            else {
                descLabel.text = "Looks like you room is colder than outside. Treat yourself with a cold drink..."
            }
        }
        else if (temp > 25 && temp <= 31) {
            imageView.loadGif(name: "tNH")
            moodLabel.text = "Sweaty"
            if(apiTemperature < Int(temp)) {
                descLabel.text = "Looks like you room is warmer than outside. Visiting a beach and getting tanned is a good idea..."
            }
            else {
                descLabel.text = "Looks like you room is colder than outside. Stay home and play video games..."
            }
        }
        else {
            imageView.loadGif(name: "tH")
            moodLabel.text = "Feeling Hot"
            if(apiTemperature < Int(temp)) {
                descLabel.text = "Looks like you room is warmer than outside. You are on Fire... Get some help!!!! "
            }
            else {
                descLabel.text = "Looks like you room is colder than outside. May be going for a swim is a good idea..."
            }
        }
    }
    
    //From Apple documentation
    //Gets data and parses the JSON data into usable data
    func getDataFromUrl() {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + long + "&appid=3af463d5d4d7916e155dd605e37db688")
        URLSession.shared.dataTask(with: url!) { data, _, _ in
            if let data = data {
                let resp = try? JSONDecoder().decode(JsonResponse.self, from: data)
                let d: Double = round((resp?.main.temp)!)
                let intTemp = Int(d)
                self.apiTemperature = intTemp
                DispatchQueue.main.async {
                    self.makeGetRequestImage(icon: (resp?.weather[0].icon)!)
                    self.apiLocationName.text = resp?.name
                    self.apiDescLabel.text = resp?.weather[0].description
                    self.apiTemp.text = String(format: "%i", intTemp - 273) + " °C"
                }
            }
            }.resume()
    }
    
    //From Apple docs
    //Gets image data from the API and sets the icon into image view for location's weather
    func makeGetRequestImage(icon: String){
        let url : String = "https://openweathermap.org/img/wn/" + icon + "@2x.png"
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url) as URL?
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse!, data: Data!, error: Error!) -> Void in
            DispatchQueue.main.async {
                self.apiIcon.backgroundColor = .clear
                self.apiIcon.image = UIImage(data: data)
                
            }
        })
    }
    
    //Loccation manager that is called when location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        currentLocation = location.coordinate
        lat = String(format: "%f", currentLocation!.latitude)
        long = String(format: "%f", currentLocation!.longitude)
        getDataFromUrl()
    }

}
