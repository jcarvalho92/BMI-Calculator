//
//  FootstepViewController.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2021-03-30.
//  Copyright © 2021 Juliana de Carvalho. All rights reserved.
//
//  Student 1: Abdeali Mody - Student Id: 301085484
//  Student 2: Juliana de Carvalho - Student Id: 301137060

import UIKit
import HealthKit

class FootstepViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var goal: UITextField!
    
    @IBOutlet var msgReachedGoal: UILabel!
    @IBAction func changeGoal(_ sender: UIButton) {
        let newGoalStr = goal.text ?? "0"
        newGoal = Double(newGoalStr)!
    }
    
    var healthStore: HealthStore = HealthStore()
    var steps : [Step] = []
    var db: DBHelper = DBHelper()
    var todayStr = ""
    var goalReached = false
    var goalValue = 0.0
    var newGoal = 0.0
    @IBOutlet var tableView: UITableView!
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: Date()+1)!
        let endDate = Date()+1
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            let count = statistics.sumQuantity()?.doubleValue(for: .count() )
            let date = statistics.startDate
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .medium
            let dateStr = formatter.string(from: date)
            
            if (dateStr == self.todayStr)
            {
                let goalinput = self.goalValue
                if(count ?? 0 >= goalinput ){
                    NotificationCenter.default.post(name: .countReachedTheGoal, object: nil)
                }
            }
            self.db.insertSteps( steps: count ?? 0, date: dateStr, goal: self.goalValue)

        }
    }

    @objc func updateGoalDisplay(){
        print("Goal Reached!")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let today = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        todayStr = formatter.string(from: today)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGoalDisplay), name: .countReachedTheGoal, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self

        healthStore.requestAuthorization{ success in
            if success {
                self.healthStore.calculateSteps {statisticsCollection in
                    if let statisticsCollection = statisticsCollection {
                    
                        self.updateUIFromStatistics(statisticsCollection)
                        
                    }
                }
            }
        }
        
        steps = db.readSteps()
        
        if(steps.count > 0){
            goalValue = steps[0].goal
            goal.text = String(goalValue)
        }
       

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Footstepcell", for: indexPath)

        let stepsCount = Int(steps[indexPath.row].qtySteps)
        cell.textLabel?.text = String(stepsCount)
        let stepsDate = steps[indexPath.row].dateSteps
        cell.detailTextLabel?.text = stepsDate

          return cell
    }
    


}
