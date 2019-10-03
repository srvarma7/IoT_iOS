//
//  DatabaseProtocol.swift
//  2019S1 Lab 3
//
//  Created by Michael Wybrow on 22/3/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case data
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onDataListChange(change: DatabaseChange, dataList: [SensorData])
}

protocol DatabaseProtocol: AnyObject {
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
