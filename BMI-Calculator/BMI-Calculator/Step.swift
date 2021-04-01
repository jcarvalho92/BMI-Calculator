//
//  Step.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2021-03-31.
//  Copyright © 2021 Juliana de Carvalho. All rights reserved.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}
