//
//  MainWeatherViewController.swift
//  WeatherBeat
//
//  Created by Timo Virtanen on 03/10/2018.
//  Copyright © 2018 Timo Virtanen. All rights reserved.
//

import UIKit
import CoreLocation

class MainWeatherViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var ViewA: UIView!
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var IconView: UIImageView!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    
    var locationManager:CLLocationManager!
    var net : Networker!
    var currentCity : CurrentCity!
    var isUsingGPS : Bool!
    var lastNetDate: Double!;
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(true)
        print("Main appear")
        let defaultDB = UserDefaults.standard
        let cityHere =  defaultDB.string(forKey: "city")
        defaultDB.synchronize()
        if cityHere == "usegps" {
            self.lastNetDate = Date().timeIntervalSince1970
            determineMyCurrentLocation()
        }
        if !self.isUsingGPS {
            print("CityHere")
            print(cityHere)
            print("Not Using GPS")
            self.lastNetDate = Date().timeIntervalSince1970
            net.fetch(city: cityHere ?? "Turku")
        }
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("main load")
        City.text = "Test"
        windSpeed.text = "0 m/s"
        temperature.text = "20 C"
        // Do any additional setup after loading the view, typically from a nib.
        net = Networker()
        net.callingView = self
       // net.fetch()
        self.isUsingGPS = false
        determineMyCurrentLocation()
    }
    func testUpdate(){
        print("TESTUPDATE")

        
        if let forecast = net.forecast {
           
            let cityT = forecast.name
            print("setting label")
            print(cityT)
            City.text = cityT
            let tempT = forecast.main?.temp
            var temp = 0.0
            if let temp1 = tempT {
                temp = Double(temp1 - 273.15)
                var tempS = String.localizedStringWithFormat("%.1f C", temp)
                temperature.text = tempS

            }
            
            var wind = forecast.wind?.speed
            windSpeed.text = "\(wind ?? 0.0) m/S"
            var desc = forecast.weather?[0].description
            descLabel.text = desc
            
            if let windN = wind {
                if(windN > 5.00) {
                    IconView.image = UIImage(imageLiteralResourceName: "windy")
                }
            }
            if let description = desc {
                if description.range(of:"rain") != nil {
                    IconView.image = UIImage(imageLiteralResourceName: "rainy")
                }
                if description.range(of:"drizzle") != nil {
                    IconView.image = UIImage(imageLiteralResourceName: "rainy")
                }
                if description.range(of:"cloud") != nil {
                    IconView.image = UIImage(imageLiteralResourceName: "cloudy")
                }
                if description.range(of:"fog") != nil {
                    IconView.image = UIImage(imageLiteralResourceName: "cloudy2")
                }
                if description.range(of:"snow") != nil {
                    IconView.image = UIImage(imageLiteralResourceName: "snow")
                }
                if description.range(of:"clear") != nil {
                    IconView.image = UIImage(imageLiteralResourceName: "sunny")
                }

            }
      
        }
    }
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        var lat = Double(userLocation.coordinate.latitude ?? 0)
        var long = Double(userLocation.coordinate.longitude ?? 0)
        
        let myPlace = CurrentCity(lat: lat, long: long)
        self.currentCity = myPlace
        self.net.fetchForCoords(lat: lat, long: long)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

    
    
}
class CurrentCity {

    var lat : Double = 0.0
    var long : Double = 0.0
    
    init(lat : Double, long: Double ) {
        self.long = long
        self.lat = lat
    }
}


