//
//  ViewController.swift
//  MinorDianping
//
//  Created by Apple on 2017/4/24.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let FIRST_RUN = false
    
    // MARK: CSV File Functions
    private func cleanRows(file:String) -> String{
        // use a uniform \n for end of lines
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    private func getStringFieldsForRow(row: String, delimiter:String) -> [String]{
        return row.components(separatedBy: delimiter)
    }
    
    func convertCSV(file:String) -> [[String:String]]?{
        let rows = cleanRows(file: file).components(separatedBy: "\n")
        if rows.count > 0 {
            var data = [[String:String]]()
            let columnTitles = getStringFieldsForRow(row: rows.first!, delimiter: ",")
            for row in rows{
                let fields = getStringFieldsForRow(row: row, delimiter: ",")
                if fields.count != columnTitles.count{continue}
                var dataRow = [String:String]()
                for (index, field) in fields.enumerated(){
                    dataRow[columnTitles[index]] = field
                }
                data += [dataRow]
            }
            return data
        }
        else {
            print("No data in file")
        }
        return nil
    }
    
    // MARK: Data reading and writing functions
    func readDataFromFile(file:String, type: String) -> String!{
        guard let filepath = Bundle.main.path(forResource: file, ofType: type)
            else{
                return nil
        }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: String.Encoding.utf8)
            return contents
        } catch {
            print("File Read Error")
            return nil
        }
    }
    
//    func fetchOneResultFromCoreData<T:NSManagedObject>(index: Int) -> T?{
//        let fetchRequest:NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
//        do{
//            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
//            return searchResults[index]
//        }
//        catch{
//            print("Error: \(error)")
//
//        }
//        return nil
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // MARK: Core Data Fetch Function

        let fetchRequest:NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            print("number of results: \(searchResults.count)")
            
            for result in searchResults as [Restaurant]{
                print("\(result.name!) is in \(result.location!) of \(result.city!.cityName!).")
            }
            
        }
        catch{
            print("Error: \(error)")
        }
//        let restaurant:Restaurant = fetchOneResultFromCoreData(index: 0)! as! Restaurant
//        print(restaurant.location)
        
        if(FIRST_RUN){
            // MARK: CSV File Operations
            let file:String = readDataFromFile(file: "Nanjing", type: "csv")
            guard let contents:[[String:String]] = convertCSV(file: file)else {
                print("Parse Successfully")
                return
            }
            
            let numOfRestaurants = contents.count - 1
            
            // MARK: - Core Data Operations
            let cityClassName:String = String(describing: City.self)
            let restaurantClassName:String = String(describing: Restaurant.self)
            
            let city:City = NSEntityDescription.insertNewObject(forEntityName: cityClassName, into: DatabaseController.getContext()) as! City
            city.cityName = "Nanjing"
            
            for i in 0 ..< numOfRestaurants{
                let restaurant:Restaurant = NSEntityDescription.insertNewObject(forEntityName: restaurantClassName, into: DatabaseController.getContext()) as! Restaurant
                restaurant.location = contents[i + 1]["位置"]
                restaurant.name = contents[i + 1]["餐厅名"]
                city.addToRestaurants(restaurant)
            }
            
            DatabaseController.saveContext()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

