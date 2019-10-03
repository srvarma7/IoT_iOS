//
//  ColorViewController.swift
//  2019S1 Lab 3
//
//  Created by Sai Raghu Varma Kallepalli on 2/10/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController, DatabaseListener {

    @IBOutlet weak var colorImageView: UIImageView!
    
    @IBOutlet weak var laastRefreshLabel: UILabel!
    @IBOutlet weak var i1: UIImageView!
    @IBOutlet weak var i2: UIImageView!
    @IBOutlet weak var i3: UIImageView!
    @IBOutlet weak var i4: UIImageView!
    @IBOutlet weak var i5: UIImageView!
    @IBOutlet weak var i6: UIImageView!
    @IBOutlet weak var i7: UIImageView!
    @IBOutlet weak var i8: UIImageView!
    @IBOutlet weak var i9: UIImageView!
    @IBOutlet weak var i10: UIImageView!
    var imageViewList = [UIImageView]()
    
    let center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    var gaugeView1 = GaugeView()
    var gaugeView2 = GaugeView()
    
    var temp: Int = 0
    var latestData = SensorData()
    weak var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.data

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate!.databaseController
        UIView.animate(withDuration: 6) {
            self.colorImageView.tintColor = UIColor(red: 90/255, green: 43/255, blue: 28/255, alpha: 1.0)
            
        }
        
        gaugeView1 = GaugeView(frame: CGRect(x: center.x - 170, y: center.y - 250, width: 150, height: 150))
        gaugeView2 = GaugeView(frame: CGRect(x: center.x + 20, y: center.y - 250, width: 150, height: 150))
        createGaugeSubView()
        
        imageViewList = [colorImageView,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        databaseController?.removeListener(listener: self)
    }
    
    func onDataListChange(change: DatabaseChange, dataList: [SensorData]) {
        var sortedDataList = dataList
        sortedDataList.sort(by: {$0.unixTime > $1.unixTime})
        print("in home screen", dataList.count)
        if !dataList.isEmpty {
            
            print(dataList.count, "count in color")
            latestData = sortedDataList[sortedDataList.startIndex]
            laastRefreshLabel.text = "Last refreshed at " + latestData.time
            var red = CGFloat(Float(latestData.red)!/255)
            var green = CGFloat(Float(latestData.green)!/255)
            var blue = CGFloat(Float(latestData.blue)!/255)
            print(temp, " in color controller")
            UIView.animate(withDuration: 1, animations: {
                self.colorImageView.layer.cornerRadius = (self.colorImageView.frame.size.width)/2
                self.colorImageView.layer.borderWidth = 5
                self.colorImageView.layer.borderColor = #colorLiteral(red: 0.8665331536, green: 0.1220010404, blue: 0, alpha: 1)
                self.colorImageView.layer.borderWidth = 2
                self.colorImageView.clipsToBounds = true
                //self.setRecentColorImages(data: dataList[1], imageView: self.i1)

            })
            UIView.animate(withDuration: 0.3) {
                
                self.colorImageView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)

                if sortedDataList.count >= 2{
                    red = CGFloat(Float(sortedDataList[1].red)!/255)
                    green = CGFloat(Float(sortedDataList[1].green)!/255)
                    blue = CGFloat(Float(sortedDataList[1].blue)!/255)
                    print("in sensor color in if for 2nd in datalist")
                    self.i1.image = UIImage(named: "40x40.png")
                    self.i1.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)
                    self.i1.layer.cornerRadius = (self.i1.frame.size.width)/2
                    self.i1.clipsToBounds = true

                }
                
                if sortedDataList.count >= 3{
                    red = CGFloat(Float(sortedDataList[2].red)!/255)
                    green = CGFloat(Float(sortedDataList[2].green)!/255)
                    blue = CGFloat(Float(sortedDataList[2].blue)!/255)
                    self.i2.image = UIImage(named: "40x40.png")
                    self.i2.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)
                    self.i2.layer.cornerRadius = (self.i2.frame.size.width)/2
                    self.i2.clipsToBounds = true
                    
                }
                
                if sortedDataList.count >= 4{
                    red = CGFloat(Float(sortedDataList[3].red)!/255)
                    green = CGFloat(Float(sortedDataList[3].green)!/255)
                    blue = CGFloat(Float(sortedDataList[3].blue)!/255)
                    self.i3.image = UIImage(named: "40x40.png")
                    self.i3.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)
                    self.i3.layer.cornerRadius = (self.i3.frame.size.width)/2
                    self.i3.clipsToBounds = true

                }

                if sortedDataList.count >= 5{
                    red = CGFloat(Float(sortedDataList[4].red)!/255)
                    green = CGFloat(Float(sortedDataList[4].green)!/255)
                    blue = CGFloat(Float(sortedDataList[4].blue)!/255)
                    self.i4.image = UIImage(named: "40x40.png")
                    self.i4.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)
                    self.i4.layer.cornerRadius = (self.i4.frame.size.width)/2
                    self.i4.clipsToBounds = true

                }

                if sortedDataList.count >= 6{
                    red = CGFloat(Float(sortedDataList[5].red)!/255)
                    green = CGFloat(Float(sortedDataList[5].green)!/255)
                    blue = CGFloat(Float(sortedDataList[5].blue)!/255)
                    self.i5.image = UIImage(named: "40x40.png")
                    self.i5.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)
                    self.i5.layer.cornerRadius = (self.i5.frame.size.width)/2
                    self.i5.clipsToBounds = true

                }

                if sortedDataList.count >= 7{
                    red = CGFloat(Float(sortedDataList[6].red)!/255)
                    green = CGFloat(Float(sortedDataList[6].green)!/255)
                    blue = CGFloat(Float(sortedDataList[6].blue)!/255)
                    self.i6.image = UIImage(named: "40x40.png")
                    self.i6.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)
                    self.i6.layer.cornerRadius = (self.i6.frame.size.width)/2
                    self.i6.clipsToBounds = true

                }

                if sortedDataList.count >= 8{
                    red = CGFloat(Float(sortedDataList[7].red)!/255)
                    green = CGFloat(Float(sortedDataList[7].green)!/255)
                    blue = CGFloat(Float(sortedDataList[7].blue)!/255)
                    self.i7.image = UIImage(named: "40x40.png")
                    self.i7.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)
                    self.i7.layer.cornerRadius = (self.i7.frame.size.width)/2
                    self.i7.clipsToBounds = true

                }

                if sortedDataList.count >= 9{
                    red = CGFloat(Float(sortedDataList[8].red)!/255)
                    green = CGFloat(Float(sortedDataList[8].green)!/255)
                    blue = CGFloat(Float(sortedDataList[8].blue)!/255)
                    self.i8.image = UIImage(named: "40x40.png")
                    self.i8.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)
                    self.i8.layer.cornerRadius = (self.i8.frame.size.width)/2
                    self.i8.clipsToBounds = true

                }

                if sortedDataList.count >= 10{
                    red = CGFloat(Float(sortedDataList[9].red)!/255)
                    green = CGFloat(Float(sortedDataList[9].green)!/255)
                    blue = CGFloat(Float(sortedDataList[9].blue)!/255)
                    self.i9.image = UIImage(named: "40x40.png")
                    self.i9.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)
                    self.i9.layer.cornerRadius = (self.i9.frame.size.width)/2
                    self.i9.clipsToBounds = true

                }

                if sortedDataList.count >= 11{
                    red = CGFloat(Float(sortedDataList[10].red)!/255)
                    green = CGFloat(Float(sortedDataList[10].green)!/255)
                    blue = CGFloat(Float(sortedDataList[10].blue)!/255)
                    self.i10.image = UIImage(named: "40x40.png")
                    self.i10.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.85)
                    self.i10.layer.cornerRadius = (self.i10.frame.size.width)/2
                    self.i10.clipsToBounds = true

                }
                
                
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 1) {
                    self.gaugeView1.value = Int((Double(self.latestData.pressure)! - 90.0))
                    self.gaugeView2.value = Int(Double(self.latestData.altitude)!)
                    self.gaugeView1.valueLabel.text = self.latestData.pressure + " kPa"
                    self.gaugeView2.valueLabel.text = self.latestData.altitude + " m"
                }
            }
        }
    }
    
    func createGaugeSubView(){
        let text1 = UILabel(frame: CGRect(x: center.x - 130, y: center.y - 150    , width: 150, height: 150))
        let text2 = UILabel(frame: CGRect(x: center.x + 60, y: center.y - 150    , width: 150, height: 150))
        text1.text = "Pressure " + latestData.pressure
        text2.text = "Altitude " + latestData.altitude
        view.addSubview(text1)
        view.addSubview(text2)
        
        gaugeView1.backgroundColor = .clear
        gaugeView2.backgroundColor = .clear
        print(UIScreen.main.bounds.width)
        view.addSubview(gaugeView1)
        view.addSubview(gaugeView2)
        
    }
    
    func setRecentColorImages(data: SensorData, imageView: UIImageView){
        
        imageView.layer.cornerRadius = (imageView.frame.size.width)/2
        imageView.layer.borderWidth = 5
        let red = Float(latestData.red)!/255
        let green = Float(latestData.green)!/255
        let blue = Float(latestData.blue)!/255
        imageView.layer.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 0.7) as! CGColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
    }

}
