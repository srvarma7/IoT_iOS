//
//  SensorData.swift
//  2019S1 Lab 3
//
//  Created by Ganesh Kanchibhotla on 1/10/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//


//The structure/class for parsing the received data into


import Foundation

class SensorData{
    
    var id: String
    var altitude: String
    var unixTime: String
    var blue: String
    var pressure: String
    var date: String
    var temperature: String
    var number: Int
    var red: String
    var green: String
    var time: String
    
    init()
    {
        id = " "
        altitude = " "
        unixTime = " "
        blue = " "
        pressure = " "
        date = " "
        temperature = " "
        number = 0
        red = " "
        green = " "
        time = " "
    }
}
