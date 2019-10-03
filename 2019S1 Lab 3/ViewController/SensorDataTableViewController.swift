//
//  SensorDataTableViewController.swift
//  2019S1 Lab 3
//
//  Created by Ganesh Kanchibhotla on 1/10/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit

class SensorDataTableViewController: UITableViewController, DatabaseListener {
    
    var sensorDataList = [SensorData]()
    weak var databaseController: DatabaseProtocol?
    var selectedRow = SensorData()
    //var delegate: respondT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate!.databaseController
        tableView.delegate = self
        
    }
    
    var listenerType = ListenerType.data
    
    func onDataListChange(change: DatabaseChange, dataList: [SensorData]) {
        sensorDataList = dataList
        sensorDataList.sort(by: {$0.unixTime > $1.unixTime})
        print("refreshed", sensorDataList.count)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        databaseController?.removeListener(listener: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sensorDataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        let data = sensorDataList[indexPath.row]
//        let rd = Float(data.red)!/255
//        let gr = Float(data.green)!/255
//        let bl = Float(data.blue)!/255
        //cell.imageView?.image = UIColor(red: CGFloat(rd), green: CGFloat(gr), blue: CGFloat(bl), alpha: 0.85)
        //cell.imageView!.backgroundColor = UIColor(red: CGFloat(rd), green: CGFloat(gr), blue: CGFloat(bl), alpha: 0.85)
        cell.textLabel?.text = "Time " + data.date
        cell.detailTextLabel?.text = "Temperature " + data.temperature

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = sensorDataList[indexPath.row]
        performSegue(withIdentifier: "toDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let controller = segue.destination as! DetailsViewController
            controller.currentData = selectedRow
        }
    }
    
}
