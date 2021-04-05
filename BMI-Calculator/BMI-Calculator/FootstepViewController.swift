//
//  FootstepViewController.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2021-03-30.
//  Copyright © 2021 Juliana de Carvalho. All rights reserved.
//

import UIKit
import HealthKit

class FootstepViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var healthStore: HealthStore = HealthStore()
    var steps : [Step] = []
    var db: DBHelper = DBHelper()
    
    @IBOutlet var tableView: UITableView!
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            let count = statistics.sumQuantity()?.doubleValue(for: .count() )
      
            let date = statistics.startDate
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .medium
            let dateStr = formatter.string(from: date)
            
            self.db.insertSteps( steps: count ?? 0, date: dateStr)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        healthStore.requestAuthorization{ success in
            if success {
                self.healthStore.calculateSteps {statisticsCollection in
                    if let statisticsCollection = statisticsCollection {
                        //update the UI
                        self.updateUIFromStatistics(statisticsCollection)
                        
                    }
                }
            }
        }
        steps = db.readSteps()

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
