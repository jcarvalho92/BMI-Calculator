//
//  TrackerViewController.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2020-12-10.
//  Copyright © 2020 Juliana de Carvalho. All rights reserved.
//  Student Id: 30113760
//  Student 1: Abdeali Mody - Student Id: 301085484
//  Student 2: Juliana de Carvalho - Student Id: 301137060

import UIKit

class TrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var db: DBHelper = DBHelper()
    var bmiData:[BMI] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bmiData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackerCell", for: indexPath)

        cell.textLabel?.text = "Weight: "+String(bmiData[indexPath.row].weight) + " BMI Score: "+String(bmiData[indexPath.row].bmiScore)
        cell.detailTextLabel?.text = bmiData[indexPath.row].date

          return cell
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        var newWeight = 0.0
        var newScore = ""
        let editAction = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in

            //1. Create the alert controller.
            let alert = UIAlertController(title: "Edit weight", message: "Enter your new weight", preferredStyle: .alert)

            //2. Add the text field.
            alert.addTextField { (textField) in
                if (self.bmiData[indexPath.row].choosenUnit == "metric"){
                   textField.placeholder = "Kilograms"
                }
                else{
                   textField.placeholder = "Pounds"
                }
            }

            // 3. Grab the value from the text field and update
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
              
                //getting the weight from the input
                newWeight = (textField!.text! as NSString).doubleValue
               
                //calling the calculate function
                newScore = self.Calculate(unit: self.bmiData[indexPath.row].choosenUnit, weightValue: newWeight, heightValue: self.bmiData[indexPath.row].height)
               
                
                let today = Date()
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .medium
                let todayStr = formatter.string(from: today)
                
                
                //updating the information in the database
                self.db.update(newWeight: newWeight, newDate: todayStr,  newScore: Double(newScore)!, name: self.bmiData[indexPath.row].name, date: self.bmiData[indexPath.row].date)
              
                
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                //ref to ViewController
                guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "trackerListView") as? TrackerViewController else {
                    print("couldn't find the view controller")
                    return
                }
                destinationViewController.title = "Tracker BMI Calculator"
                self.navigationController?.pushViewController(destinationViewController, animated: true)
            }))
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)

        }

        editAction.backgroundColor = UIColor.green

        let swipeActions = UISwipeActionsConfiguration(actions: [editAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {

     let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
        //deleting the info in the database
        self.db.delete(name: self.bmiData[indexPath.row].name, weight: self.bmiData[indexPath.row].weight, date: self.bmiData[indexPath.row].date)
        
         self.bmiData = self.db.read()
        
        //checking if the user deletes everything
        if (self.bmiData.count == 0){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            //ref to ViewController
            guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainViewController") as? ViewController else {
                print("couldn't find the view controller")
                return
            }
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
        
        
         // Deleting the row from the tableview
         tableView.beginUpdates()
         tableView.deleteRows(at: [indexPath],with: .automatic)
         tableView.endUpdates()
     }

     let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
     return swipeActions
    }

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(Style.DarkOn == true){
            self.view.backgroundColor = Style.DarkBackgroundColor
        }
        
        if(Style.LightOn == true){
            self.view.backgroundColor = Style.LightBackgroundColor
        }
        
        
        bmiData = db.read()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    func Calculate(unit: String, weightValue: Double, heightValue: Double) -> String {
        var result = 0.0
        
         if (unit == "metric"){
             result = weightValue / (heightValue * heightValue)
             
         }
         else{
             result = (weightValue * 703) / (heightValue * heightValue)
         }
    
         return String(format: "%.2f", result)
     }

}
