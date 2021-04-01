//
//  FootstepViewController.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2021-03-30.
//  Copyright © 2021 Juliana de Carvalho. All rights reserved.
//

import UIKit
import HealthKit

class FootstepViewController: UIViewController {
    
    var healthStore: HealthStore = HealthStore()
    var steps: [Step] = [Step]()
    
    private func updateUIFromStatistics(_ statisticsCollection: HKStatisticsCollection){
    
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
            let count = statistics.sumQuantity()?.doubleValue(for: .count() )
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            self.steps.append(step)
            print("count \(step.count)")
            print("date \(step.date)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        


    }
    


}
