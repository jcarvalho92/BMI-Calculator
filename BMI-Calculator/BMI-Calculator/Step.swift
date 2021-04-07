//
//  Step.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2021-03-31.
//  Copyright © 2021 Juliana de Carvalho. All rights reserved.
//  Student 1: Abdeali Mody - Student Id: 301085484
//  Student 2: Juliana de Carvalho - Student Id: 301137060

import Foundation

class Step
{
    var qtySteps: Double = 0.0
    var dateSteps: String = ""
    var goal: Double = 0.0

    init(qtySteps:Double, dateSteps:String, goal:Double)
    {
        self.qtySteps = qtySteps
        self.dateSteps = dateSteps
        self.goal = goal
    }
    
    
    
}
