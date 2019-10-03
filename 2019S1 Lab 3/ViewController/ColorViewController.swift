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
        var datalist = dataList
        datalist.sort(by: {$0.unixTime > $1.unixTime})
        print("in home screen", dataList.count)
        if !dataList.isEmpty {
            print(dataList.count, "count in color")
            latestData = datalist[datalist.startIndex]
            let rd = Float(latestData.red)!/255
            let gr = Float(latestData.green)!/255
            let bl = Float(latestData.blue)!/255
            print(temp, " in color controller")
            UIView.animate(withDuration: 1, animations: {
                self.colorImageView.layer.cornerRadius = (self.colorImageView.frame.size.width)/2
                self.colorImageView.layer.borderWidth = 2
                self.colorImageView.layer.borderColor = #colorLiteral(red: 0.8665331536, green: 0.1220010404, blue: 0, alpha: 1)
                self.colorImageView.clipsToBounds = true
            })
            UIView.animate(withDuration: 0.3) {
                
                self.colorImageView.backgroundColor = UIColor(red: CGFloat(rd), green: CGFloat(gr), blue: CGFloat(bl), alpha: 0.85)
//                self.colorImageView.tintColor = UIColor(red: CGFloat(rd), green: CGFloat(gr), blue: CGFloat(bl), alpha: 0.85)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 1) {
                    self.gaugeView1.value = Int((Double(self.latestData.pressure)! - 90.0))
                    self.gaugeView2.value = Int(Double(self.latestData.altitude)! / 1000)
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

}
