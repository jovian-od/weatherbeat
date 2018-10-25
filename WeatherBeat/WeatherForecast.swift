//
//  WeatherForecast.swift
//  WeatherBeat
//
//  Created by Timo Virtanen on 10/10/2018.
//  Copyright © 2018 Timo Virtanen. All rights reserved.
//

import Foundation
class ForecastList: Decodable {
    var cod: String?
    var message: Double?
    var cnt: Int?
    var list: [List]?
    
}
class List : Decodable {
    var dt : Int?
    var dt_txt : String?
    var main : Main?
    var weather : [Weather]?
    var wind: Wind?
}
class Main : Decodable {
    var temp : Float?
    var pressure : Float?
    var humidity: Int?
    var temp_min : Float?
    var temp_max : Float?
    var sea_level: Float?
    var grnd_level : Float?
}
class Wind : Decodable {
    var speed : Float?
    var deg: Float?
}
class WeatherForecast : Decodable {
    var weather : [Weather]?
    var name : String?
    var dt : Int?
    var main : Main?
    var wind : Wind?
}


/*
class Main : Decodable {
    var temp : Float?
    var pressure : Int?
    var humidity: Int?
    var temp_min : Float?
    var temp_max : Float?
}*/




