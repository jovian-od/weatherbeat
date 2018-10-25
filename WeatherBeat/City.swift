//
//  City.swift
//  WeatherBeat
//
//  Created by Timo Virtanen on 10/10/2018.
//  Copyright © 2018 Timo Virtanen. All rights reserved.
//

import Foundation

class City {
    var name : String = ""
    var lat : Double = 0.0
    var long : Double = 0.0
    
    init(name: String, lat : Double, long: Double ) {
        self.name = name
        self.long = long
        self.lat = lat
    }
}
