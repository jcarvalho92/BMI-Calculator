//
//  ViewController.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2020-12-10.
//  Copyright © 2020 Juliana de Carvalho. All rights reserved.
//

import UIKit

struct Category{
    let title: String
    let initRange: Double
    let finalRange: Double
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let data: [Category] = [
           Category(title: "Severe Thinness", initRange: 0, finalRange: 15.9),
           Category(title: "Moderate Thinness",initRange: 16, finalRange: 16.9),
           Category(title: "Mild Thinness",initRange: 17, finalRange: 18.4),
           Category(title: "Normal",initRange: 18.5, finalRange: 24.9),
           Category(title: "Overweight",initRange:25, finalRange: 29.9),
           Category(title: "Obese Class 1",initRange:30, finalRange: 34.9),
           Category(title: "Obese Class 2", initRange:35, finalRange: 39.9),
           Category(title: "Obese Class 3", initRange:40, finalRange: 999),
       ]
    var weightValue: Double = 0.0
    var heightValue: Double = 0.0
    var result: Double = -1

    var db: DBHelper = DBHelper()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var categoriesLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var scoreTxt: UITextField!

    @IBOutlet var age: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var weight: UITextField!
    @IBOutlet var height: UITextField!
    @IBOutlet var unit: UISwitch!
    @IBOutlet var ageValue: UIStepper!
    
    @IBAction func ageAction(_ sender: UIStepper) {
        age.text = String(Int(ageValue.value))
    }
    
    @IBAction func unitChoosen(_ sender: Any) {
        if (unit.isOn){
            //metric
            weight.placeholder = "Kilograms"
            height.placeholder = "Meters"
           
        }
        else{
            //imperial
            weight.placeholder = "Pounds"
            height.placeholder = "Inches"
            
        }
        
    }
    
    @IBAction func submit(_ sender: UIButton) {
        categoriesLabel.text = "See your Category below!!!"
        scoreTxt.isHidden = false
        scoreLabel.isHidden = false
        
        var value = weight.text
        weightValue = (value! as NSString).doubleValue
        
        if (weightValue <= 0)
        {
            showAlertInvalidInput(message: "Invalid Weight")
        }
        value = height.text
        heightValue = (value! as NSString).doubleValue
        
        if (heightValue <= 0)
        {
           showAlertInvalidInput(message: "Invalid Height")
        }
        
        scoreTxt.text = Calculate()
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        let todayStr = formatter.string(from: today)
        
       db.insert(name: name.text!, age: Int(age.text!)!, gender: "F", choosenUnit: (unit.isOn ? "metric" : "imperial"), weight: weightValue, height: heightValue, date: todayStr, bmiScore: Double(scoreTxt.text!)!)

        tableView.reloadData()
        
    }

    func Calculate() -> String {

        if (unit.isOn){
            //metric
            result = weightValue / (heightValue * heightValue)
            
        }
        else{
            //imperial
            result = (weightValue * 703) / (heightValue * heightValue)
        }
   
        return String(format: "%.2f", result)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        cell.textLabel?.text = data[indexPath.row].title

        var rangeStr = ""
        
        if ( data[indexPath.row].initRange == 0){
          rangeStr = "<= " + String(data[indexPath.row].finalRange)
        }
        else{
            if (data[indexPath.row].finalRange == 999){
               rangeStr = ">= " + String(data[indexPath.row].initRange)
            }
            else{
                rangeStr = String(data[indexPath.row].initRange) + " - " + String(data[indexPath.row].finalRange)
            }
        }
        
         cell.detailTextLabel?.text = rangeStr
        
        if(result >= data[indexPath.row].initRange && result <= data[indexPath.row].finalRange ){
            if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2){
                cell.backgroundColor = UIColor.cyan
            }
            else{
                if (indexPath.row == 3){
                   cell.backgroundColor = UIColor.green
                }
                else
                {
                    cell.backgroundColor = UIColor.red
                }
            }
            
        }
      
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
         
        age.text = String(Int(ageValue.value))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showAlertInvalidInput(message: String){
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default))

        present(alert, animated: true, completion: nil)
    }


}

