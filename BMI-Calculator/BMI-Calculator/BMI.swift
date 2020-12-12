//
//  BMI.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2020-12-11.
//  Copyright © 2020 Juliana de Carvalho. All rights reserved.
//

import Foundation

class BMI
{
    
    var name: String = ""
    var age: Int = 0
    var gender: String = ""
    var choosenUnit: String = ""
    var weight: Double = 0.0
    var height: Double = 0.0
    var date: String = ""
    var bmiScore: Double = 0.0
    
    init()
    {

    }
    
    init(name:String, age:Int, gender:String, choosenUnit : String, weight:Double, height:Double, date: String, bmiScore: Double)
    {
        self.name = name
        self.age = age
        self.gender = gender
        self.choosenUnit = choosenUnit
        self.weight = weight
        self.height = height
        self.date = date
        self.bmiScore = bmiScore
    }
    
    
    
}


