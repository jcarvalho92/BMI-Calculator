//
//  SettingsViewController.swift
//  BMI-Calculator
//
//  Created by Juliana de Carvalho on 2021-04-14.
//  Copyright © 2021 Juliana de Carvalho. All rights reserved.
//  Student 1: Abdeali Mody - Student Id: 301085484
//  Student 2: Juliana de Carvalho - Student Id: 301137060

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var darkLabel: UILabel!
    @IBOutlet var close: UIButton!
    @IBOutlet var lightLabel: UILabel!
    @IBOutlet var defaultLabel: UILabel!
    @IBOutlet var theme: UILabel!
    @IBOutlet var defaultSwitch: UISwitch!
    @IBOutlet var lightSwitch: UISwitch!
    @IBOutlet var darkSwitch: UISwitch!

    @IBAction func CloseButton(_ sender: UIButton) {
        print("test close")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DefaultAction(_ sender: UISwitch) {
        defaultSwitch.isOn = true
        lightSwitch.isOn = false
        darkSwitch.isOn = false
        
        let DefaultDefault = UserDefaults.standard
        DefaultDefault.set(true, forKey: "DefaultDefault")
        
        let LightDefault = UserDefaults.standard
        LightDefault.set(false, forKey: "LightDefault")
        
        let DarkDefault = UserDefaults.standard
        DarkDefault.set(false, forKey: "DarkDefault")
    }
    
    @IBAction func LightAction(_ sender: UISwitch) {
        
        self.view.backgroundColor = Style.LightBackgroundColor
        
        defaultSwitch.isOn = false
        lightSwitch.isOn = true
        darkSwitch.isOn = false
        
        let DefaultDefault = UserDefaults.standard
        DefaultDefault.set(false, forKey: "DefaultDefault")
        
        let LightDefault = UserDefaults.standard
        LightDefault.set(true, forKey: "LightDefault")
        
        let DarkDefault = UserDefaults.standard
        DarkDefault.set(false, forKey: "DarkDefault")
    
    }
    
    
    @IBAction func DarkAction(_ sender: UISwitch){
        
        self.view.backgroundColor = Style.DarkBackgroundColor
        darkLabel.textColor = UIColor.systemGreen
        lightLabel.textColor = UIColor.systemGreen
        defaultLabel.textColor = UIColor.systemGreen
        theme.textColor = UIColor.systemGreen
        
        defaultSwitch.isOn = false
        lightSwitch.isOn = false
        darkSwitch.isOn = true
        
        let DefaultDefault = UserDefaults.standard
        DefaultDefault.set(false, forKey: "DefaultDefault")
        
        let LightDefault = UserDefaults.standard
        LightDefault.set(false, forKey: "LightDefault")
        
        let DarkDefault = UserDefaults.standard
        DarkDefault.set(true, forKey: "DarkDefault")

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if(Style.DarkOn == true){
            darkSwitch.isOn = true
            lightSwitch.isOn = false
            defaultSwitch.isOn = false
            
            self.view.backgroundColor = Style.DarkBackgroundColor
            
            darkLabel.textColor = UIColor.systemGreen
            lightLabel.textColor = UIColor.systemGreen
            defaultLabel.textColor = UIColor.systemGreen
            theme.textColor = UIColor.systemGreen
        }
        
        if(Style.LightOn == true){
            darkSwitch.isOn = false
            lightSwitch.isOn = true
            defaultSwitch.isOn = false
            
            self.view.backgroundColor = Style.LightBackgroundColor
        }
    }
    
}
