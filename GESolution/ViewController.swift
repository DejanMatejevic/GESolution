//
//  ViewController.swift
//  GESolution
//
//  Created by Dejan Matejevic on 10/22/16.
//  Copyright © 2016 Dejan Matejevic. All rights reserved.
//


import SystemConfiguration
import UIKit
import CoreData


let colorNormal : UIColor = UIColor.white
let colorSelected : UIColor = UIColor.orange
let titleFontAll : UIFont = UIFont(name: "Arial", size: 20.0)!

let attributesNormal = [
    NSForegroundColorAttributeName : colorNormal,
    NSFontAttributeName : titleFontAll
]

let attributesSelected = [
    NSForegroundColorAttributeName : colorSelected,
    NSFontAttributeName : titleFontAll
]



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, NSFetchedResultsControllerDelegate
    
{
    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var datum: UILabel!
    
    @IBOutlet weak var Train: UITabBarItem!
    @IBOutlet weak var Bus: UITabBarItem!
    @IBOutlet weak var Flight: UITabBarItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var tableData = [NSManagedObject]()
    
    var trains = [NSManagedObject]()
    var buses = [NSManagedObject]()
    var flights = [NSManagedObject]()
    
    let now = NSDate()
    let formatter = DateFormatter()
    
    
    @IBAction func ButtonBuyTicket(_ sender: AnyObject) {
        
        let Alert = UIAlertController(title: "GoEuroSolution", message: "Offer details are not yet implemented!", preferredStyle: UIAlertControllerStyle.alert)
        
        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //print("Handle Ok logic here")
        }))
        
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //print("Handle Cancel Logic here")
        }))
        
        present(Alert, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath as IndexPath) as! TableViewCell
        
        
        let row = tableData[indexPath.row]
        
        cell.StartEndTimeTravel.text = (row.value(forKey: "departure") as! String?)! + " - " + (row.value(forKey: "arrival") as! String?)!
        
        if (row.value(forKey: "stops") as! Int?)! == 0 {
            cell.NumberOfStations.text = "Direct"
        
        
        }else{cell.NumberOfStations.text = String((row.value(forKey: "stops") as! Int?)!) + "  stops"}
        
        cell.TravelTime.text = travelTime(departureTime: (row.value(forKey: "departure") as! String?)!, arrivalTime: (row.value(forKey: "arrival") as! String?)!)
        
   
        cell.Price.text = "€" + String((row.value(forKey: "price") as! Double?)!)
        
        switch (row.value(forKey: "logo") as! String?)! {
        case "http://cdn-goeuro.com/static_content/web/logos/{size}/postbus.png":
            let image : UIImage = UIImage(named: "postbus")!
            cell.Logo.image = image
        case "http://cdn-goeuro.com/static_content/web/logos/{size}/meinfernbus_flixbus.png":
            let image : UIImage = UIImage(named: "meinfernbus_flixbus")!
            cell.Logo.image = image
        case "http://cdn-goeuro.com/static_content/web/logos/{size}/deutsche_bahn.png":
            let image : UIImage = UIImage(named: "deutsche_bahn")!
            cell.Logo.image = image
        case "http://cdn-goeuro.com/static_content/web/logos/{size}/air_berlin.png":
            let image : UIImage = UIImage(named: "air_berlin")!
            cell.Logo.image = image
        case "http://cdn-goeuro.com/static_content/web/logos/{size}/transavia_airlines.png":
            let image : UIImage = UIImage(named: "transavia_airlines")!
            cell.Logo.image = image
        case "http://cdn-goeuro.com/static_content/web/logos/{size}/turkish_airlines.png":
            let image : UIImage = UIImage(named: "turkish_airlines")!
            cell.Logo.image = image
        default: break
        }
   
        return cell
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        
        getData(busesAPI: "https://api.myjson.com/bins/37yzm", trainsAPI: "https://api.myjson.com/bins/3zmcy", flightsAPI: "https://api.myjson.com/bins/w60i")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        datum.text = formatter.string(from: now as Date) 
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.tag {
        case 0:
            self.tableData = trains
        case 1:
            self.tableData = buses
        case 2:
            self.tableData = flights
        default: break
        }
        tableView.reloadData()
        segmentedControl.selectedSegmentIndex = 0
    }
    
    
    func getData(busesAPI: String, trainsAPI: String, flightsAPI: String) {
        
        
        if connectedToNetwork() {
            
            deleteEntity(entityName: "BusesTable")
            deleteEntity(entityName: "TrainsTable")
            deleteEntity(entityName: "FlightsTable")
            
            do {
            
                let data = NSData(contentsOf: NSURL(string: busesAPI)! as URL)
            
                let jsonResult = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
            
                for lines in jsonResult as! [Dictionary<String, AnyObject>] {
                
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let entityDescription = NSEntityDescription.entity(forEntityName: "BusesTable", in: context)
                    let redTabele = BusesTable(entity: entityDescription!, insertInto: context)
                
                    redTabele.iD = Int16(lines["id"] as! Int)
                    redTabele.logo = lines["provider_logo"] as? String
                    redTabele.price = lines["price_in_euros"] as! Double
                    redTabele.departure = lines["departure_time"] as? String
                    redTabele.arrival = lines["arrival_time"] as? String
                    redTabele.stops = Int16(lines["number_of_stops"] as! Int)
     
                    do {
                        try context.save()
                    
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                
                } //end for
            
            } catch let error as NSError {
            
            print(error)
            
            } //end do
            
            do {
                
                let data = NSData(contentsOf: NSURL(string: trainsAPI)! as URL)
                
                let jsonResult = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                for lines in jsonResult as! [Dictionary<String, AnyObject>] {
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let entityDescription = NSEntityDescription.entity(forEntityName: "TrainsTable", in: context)
                    let redTabele = TrainsTable(entity: entityDescription!, insertInto: context)
                    
                    redTabele.iD = Int16(lines["id"] as! Int)
                    redTabele.logo = lines["provider_logo"] as? String
                    redTabele.price = lines["price_in_euros"] as! Double
                    redTabele.departure = lines["departure_time"] as? String
                    redTabele.arrival = lines["arrival_time"] as? String
                    redTabele.stops = Int16(lines["number_of_stops"] as! Int)
                    
                    do {
                        try context.save()
                        
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                } //end for
                
            } catch let error as NSError {
                
                print(error)
                
            } //end do

            do {
                
                let data = NSData(contentsOf: NSURL(string: flightsAPI)! as URL)
                
                let jsonResult = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                for lines in jsonResult as! [Dictionary<String, AnyObject>] {
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let entityDescription = NSEntityDescription.entity(forEntityName: "FlightsTable", in: context)
                    let redTabele = FlightsTable(entity: entityDescription!, insertInto: context)
                    
                    redTabele.iD = Int16(lines["id"] as! Int)
                    redTabele.logo = lines["provider_logo"] as? String
                    redTabele.price = Double(lines["price_in_euros"] as! String)!
                    redTabele.departure = lines["departure_time"] as? String
                    redTabele.arrival = lines["arrival_time"] as? String
                    redTabele.stops = Int16(lines["number_of_stops"] as! Int)
                    
                    do {
                        try context.save()
                        
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                } //end for
                
            } catch let error as NSError {
                
                print(error)
                
            } //end do
      
        } //end if

        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequestB: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"BusesTable")

        fetchRequestB.sortDescriptors = [NSSortDescriptor(key: "departure", ascending: true)]
        
        do {
            let results = try context.fetch(fetchRequestB)
            
            buses = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
        }

        let fetchRequestT: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"TrainsTable")
        
        fetchRequestT.sortDescriptors = [NSSortDescriptor(key: "departure", ascending: true)]
        do {
            let results = try context.fetch(fetchRequestT)
            
            trains = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        let fetchRequestF: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:"FlightsTable")
        
        fetchRequestF.sortDescriptors = [NSSortDescriptor(key: "departure", ascending: true)]
        do {
            let results = try context.fetch(fetchRequestF)
            
            flights = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    func deleteEntity(entityName: String) {
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let coord = context.persistentStoreCoordinator
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord?.execute(deleteRequest, with: context)
        } catch let error as NSError {
            debugPrint(error)
        }
    
    }
    
    func travelTime(departureTime: String, arrivalTime: String) -> String {
        
        var dep = NSDate()
        var arr = NSDate()
        formatter.dateFormat = "HH:mm"
        dep = formatter.date(from: departureTime)! as NSDate
        arr = formatter.date(from: arrivalTime)! as NSDate
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.allowedUnits = [NSCalendar.Unit.hour, NSCalendar.Unit.minute]
        let autoFormattedDifference = dateComponentsFormatter.string(from: dep as Date, to: arr as Date)
    
        return autoFormattedDifference!
    
    }
    
    @IBAction func segmentedControlAction(_ sender: AnyObject) {
       
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableData.sort { ($0.value(forKey: "departure") as! String?)! < ($1.value(forKey: "departure") as! String?)! }
        case 1:
            tableData.sort { ($0.value(forKey: "arrival") as! String?)! < ($1.value(forKey: "arrival") as! String?)! }
        case 2:
            tableData.sort { ($0.value(forKey: "price") as! Double?)! < ($1.value(forKey: "price") as! Double?)! }
        default: break
        }
        tableView.reloadData()
 
    }
    
}

