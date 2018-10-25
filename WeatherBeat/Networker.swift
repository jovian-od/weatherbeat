//
//  Networker.swift
//  WeatherBeat
//
//  Created by Timo Virtanen on 04/10/2018.
//  Copyright © 2018 Timo Virtanen. All rights reserved.
//

import UIKit
class Networker {
    let apikey = "v"
    var data : String = ""
    var forecast : WeatherForecast?
    var forecastList : ForecastList?
    
    var callingView : MainWeatherViewController?
    var callingforeView : ForeCastViewController?
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?){
        let resstr = String(data:data!, encoding: String.Encoding.utf8)
        print(resstr)
        do {
            let mainWeather = try JSONDecoder().decode(WeatherForecast.self, from: data!)
            print("MAIN")
            self.forecast = mainWeather
            print(mainWeather.name)
            print(mainWeather.weather?[0].description)
        }
        catch {
            print("JSON error")
        }
        DispatchQueue.main.async(execute: {() in
            self.callingView?.testUpdate()
        })
        
    }
    
    func doneFetchingForecast(data: Data?, response: URLResponse?, error: Error?){
        let resstr = String(data:data!, encoding: String.Encoding.utf8)
        print(resstr)
        do {
            let foreList = try JSONDecoder().decode(ForecastList.self, from: data!)
            print("Forecast Main")
            self.forecastList = foreList
        }
        catch {
            print("JSON Forecast error")
        }
        DispatchQueue.main.async(execute: {() in
            self.callingforeView?.testUpdate()
        })
        
    }
    
    func fetch(city: String)  {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=80d6671fb9d7757ac681c9fc3b18152a")
        print("FETCHING STARTS!");
    let task = session.dataTask(with: url!, completionHandler: doneFetching)

    task.resume()
;
}
    
    func fetchForCoords(lat: Double, long: Double)  {
        let latX = Double(lat).rounded()
        let longX = Double(long).rounded()
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latX)&lon=\(longX)&APPID=80d6671fb9d7757ac681c9fc3b18152a")
        print("FETCHING LATLONG STARTS!");
        print(url)
        let task = session.dataTask(with: url!, completionHandler: doneFetching)
        
       task.resume()
        ;
    }
    func fetchForecast(city: String)  {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&APPID=80d6671fb9d7757ac681c9fc3b18152a")
        print("FETCHING Forecast STARTS!");
        let task = session.dataTask(with: url!, completionHandler: doneFetchingForecast)
        
        task.resume()
        ;
    }
    
    func fetchForecastForCoords(lat: Double, long: Double)  {
        let latX = Double(lat).rounded()
        let longX = Double(long).rounded()
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latX)&lon=\(longX)&APPID=80d6671fb9d7757ac681c9fc3b18152a")
        print("FETCHING Forecast LATLONG STARTS!");
        print(url)
        let task = session.dataTask(with: url!, completionHandler: doneFetchingForecast)
        
        task.resume()
        ;
    }

    func sendAPIkey() -> Bool {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Tampere&APPID=80d6671fb9d7757ac681c9fc3b18152a")
        print("FETCHING STARTS!");
        let task = session.dataTask(with: url!, completionHandler: {(data, response, error)
            in let resstr = String(data: data!, encoding: String.Encoding.utf8)
            print("DONE!!")
            print(resstr!);
            DispatchQueue.main.async(execute: {() in
                print("safe response")
                print(resstr);
            })
            
        })
        task.resume();
        return true

    }
}
