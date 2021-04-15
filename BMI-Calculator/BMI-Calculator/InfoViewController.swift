//
//  InfoViewController.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2021-03-30.
//  Copyright © 2021 Juliana de Carvalho. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if(Style.DarkOn == true){
            self.view.backgroundColor = Style.DarkBackgroundColor
        }
        
        if(Style.LightOn == true){
            self.view.backgroundColor = Style.LightBackgroundColor
        }

        
    }
    

}
