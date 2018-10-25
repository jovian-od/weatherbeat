//
//  Weather.swift
//  WeatherBeat
//
//  Created by Timo Virtanen on 10/10/2018.
//  Copyright © 2018 Timo Virtanen. All rights reserved.
//

import Foundation

class Weather : Decodable {
    var id : Int?
    var main : String?
    var description : String?
}
