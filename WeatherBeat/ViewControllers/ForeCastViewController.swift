//
//  ForeCastViewController.swift
//  WeatherBeat
//
//  Created by Timo Virtanen on 03/10/2018.
//  Copyright © 2018 Timo Virtanen. All rights reserved.
//

import UIKit
import CoreLocation

class TableInfo {
    var description : String?
    var temp : Float?
    var windSpeed: Float?
    var time: String?
}


class ForeCastViewController : UIViewController, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var forecastTable: UITableView!
    var net : Networker!
    var locationManager:CLLocationManager!
    var currentCity : CurrentCity!
    var isUsingGPS : Bool!
    var lastNetDate: Double!;
    var tableData : [TableInfo]?

    override func viewDidLoad() {
        self.isUsingGPS = false

        self.forecastTable.delegate = self
        self.forecastTable.dataSource = self
        self.tableData = [TableInfo?]() as! [TableInfo]
        
        var infoSet = TableInfo()
        infoSet.description = "Forecast in this city"
        infoSet.temp = 0.0
        infoSet.time = "Time"
        infoSet.windSpeed = 0.0
        
        self.tableData?.append(infoSet)

        super.viewDidLoad()
        net = Networker()
        net.callingforeView = self

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        print("Main appear")
        let defaultDB = UserDefaults.standard
        let cityHere = defaultDB.string(forKey: "city")
        defaultDB.synchronize()
        if cityHere == "usegps" {
            self.lastNetDate = Date().timeIntervalSince1970
            determineMyCurrentLocation()
            forecastTable.reloadData()
        }
        if !self.isUsingGPS {
            print("CityHere")
            print(cityHere)
            print("Not Using GPS")
            self.lastNetDate = Date().timeIntervalSince1970
            net.fetchForecast(city: cityHere ?? "nil")
            forecastTable.reloadData()

        }
        
        
    }

    func testUpdate(){
        print("Forecast UPDATE")
        if let forecastList = net.forecastList {
            
            
            var status = forecastList.cod
            var i = 0
            tableData?.removeAll()

            for listItem in forecastList.list! {
                print(listItem.weather?[0].description)
                print(listItem.main?.temp)
                print(listItem.wind?.speed)
                print(listItem.dt_txt)
                var newRow = TableInfo()
                newRow.description = listItem.weather?[0].description
                newRow.temp = listItem.main?.temp
                newRow.windSpeed = listItem.wind?.speed
                newRow.time = listItem.dt_txt
                tableData?.append(newRow)
                i = i+1
            }
            print(forecastList.list?[0].weather?[0].description)
            forecastTable.reloadData()
            }
        
        }

    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell2")
  
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell2")
        }
        var temp = tableData![indexPath.item].temp
        temp = temp! - 273.15
        var tempS = String.localizedStringWithFormat("%.1f", temp!)

        let fulldesc = " T: \(tempS) C - \(tableData![indexPath.item].description!)"
        
        if indexPath.item == 0 {
            cell!.textLabel!.text = tableData![indexPath.item].description
            let defaultDB = UserDefaults.standard
            var cityHere = defaultDB.string(forKey: "city")
            if(cityHere == "usegps") {
                cityHere = "Using GPS"
            }

            cell!.textLabel!.text = "City: \(cityHere ?? "None")"

        }else {
            cell!.textLabel!.text = fulldesc
            cell!.textLabel!.adjustsFontSizeToFitWidth = true
            cell!.detailTextLabel?.adjustsFontSizeToFitWidth = true
            cell!.detailTextLabel!.text = "\(tableData![indexPath.item].time ?? "")  - Wind: \((tableData![indexPath.item].windSpeed) ?? 0.0) m/s"
            cell!.imageView?.sizeToFit()
            cell!.imageView?.contentScaleFactor = CGFloat(0.4)
            cell!.imageView?.image = UIImage(imageLiteralResourceName: "windy")
            
            if let description = tableData![indexPath.item].description {
                if description.range(of:"rain") != nil {
                    cell!.imageView?.image = UIImage(imageLiteralResourceName: "rainy")
                }
                if description.range(of:"drizzle") != nil {
                    cell!.imageView?.image = UIImage(imageLiteralResourceName: "rainy")
                }
                if description.range(of:"cloud") != nil {
                    cell!.imageView?.image = UIImage(imageLiteralResourceName: "cloudy")
                }
                if description.range(of:"fog") != nil {
                    cell!.imageView?.image = UIImage(imageLiteralResourceName: "cloudy2")
                }
                if description.range(of:"snow") != nil {
                    cell!.imageView?.image = UIImage(imageLiteralResourceName: "snow")
                }
                if description.range(of:"clear") != nil {
                    cell!.imageView?.image = UIImage(imageLiteralResourceName: "sunny")
                }
                
            }

        }
     
        return cell!

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
   //TODO Ready the coords search
     self.net.fetchForecastForCoords(lat: lat, long: long)
}

func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
{
    print("Error \(error)")
}



}


