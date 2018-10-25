//
//  WeatherTableDelegate.swift
//  WeatherBeat
//
//  Created by Timo Virtanen on 04/10/2018.
//  Copyright © 2018 Timo Virtanen. All rights reserved.
//

import UIKit

class WeatherTableDelegate : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func addClicked(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "City Name"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let city = alert.textFields?.first?.text {
                print("Your city: \(city)")
                var city = City(name: city, lat: 0.0, long: 0.0)
                self.cities.append(city)
                self.cityTable.reloadData()
                
                let defaults = UserDefaults.standard
                var cityArray = defaults.stringArray(forKey: "citiesArray") ?? [String]()
                cityArray.append(city.name)
                defaults.set(cityArray, forKey: "citiesArray")

            }
        }))
        
        self.present(alert, animated: true)

 
        cityTable.reloadData()
        
    }
    @IBAction func editClicked(_ sender: Any) {
        if (!cityTable.isEditing) {
            cityTable.setEditing(true, animated: true)
        }
        else {
            cityTable.setEditing(false, animated: true)
        }
    }
    @IBOutlet var pView: UIView!
    @IBOutlet weak var cityTable: UITableView!
    var cities : [City]!
    var mainWeatherController : MainWeatherViewController!
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rows")
        return cities.count+1 ;
    }
    
    override func viewDidLoad() {
        self.cities = [City?]() as! [City]

        super.viewDidLoad()
        self.cityTable.delegate = self
        self.cityTable.dataSource = self
    /*    var tamp = City(name: "Tampere", lat: 22.2, long: 22.22)
        var helsinki = City(name: "Helsinki", lat: 22.2, long: 22.22)
   
        
        self.cities.append(tamp)
        self.cities.append(helsinki)*/
        
        let defaults = UserDefaults.standard
        let cityArray = defaults.stringArray(forKey: "citiesArray") ?? [String]()
        
        
        //Add cities from user defaults
        if cityArray.count > 0 {
            for city in cityArray{
                var addable = City(name: city, lat: 22.2, long: 22.22)
                self.cities.append(addable)
                
            }
        }
       



        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_: UITableView, didSelectRowAt: IndexPath) {
        print("ROW selected")
        if(didSelectRowAt.item > 0) {
        print(didSelectRowAt.item)
            print(cities[didSelectRowAt.item-1].name)
            let city = cities[didSelectRowAt.item-1].name
            let defaultDB = UserDefaults.standard
            defaultDB.set(city, forKey: "city")
            defaultDB.synchronize()

        }
        else  {
            let defaultDB = UserDefaults.standard
            defaultDB.set("usegps", forKey: "city")
            defaultDB.synchronize()
        }
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell1")
        if(cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell1")
        }
        if (indexPath.item == 0) {
            cell!.textLabel!.text = "Use GPS"
            
        }
        else {
            var ind = indexPath.item-1
            var cName = cities[ind]
            print("city name")
            print(cName.name)
            cell!.detailTextLabel!.text = ""
            cell!.textLabel!.text = cName.name
        }
        print(indexPath.item)
        return cell!
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("editing:")
        
        if editingStyle == .delete {
            if(indexPath.item != 0){
            print("delete cell")
            var index = indexPath.item-1
            cities.remove(at: index)
                //Retrieve array
                let defaults = UserDefaults.standard
                var citiesA = defaults.stringArray(forKey: "citiesArray") ?? [String]()
                //Delete member
                citiesA.remove(at: indexPath.item)
                defaults.set(citiesA, forKey: "citiesArray")

                //Delete rows
                tableView.deleteRows(at: [indexPath], with: .fade)}
        } else if editingStyle == .insert {
            print("append")
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    }

    


