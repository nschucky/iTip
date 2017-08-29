//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Antonio Alves on 8/20/17.
//  Copyright © 2017 Antonio Alves. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let defaults = UserDefaults.standard
    @IBOutlet weak var uiModeEnabler: UISwitch!
    @IBOutlet weak var selectValueLabel: UILabel!
    @IBOutlet weak var selectModeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iTip Settings"
        let defaultSegmentedIndex = defaults.integer(forKey: DefaultKeys.defaultTipIndex.rawValue)
        uiModeEnabler.isOn = defaults.bool(forKey: DefaultKeys.uiMode.rawValue)
        segmentedControl.selectedSegmentIndex = defaultSegmentedIndex
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "MyriadPro-Light", size: 25)!], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let mode = defaults.bool(forKey: DefaultKeys.uiMode.rawValue)
        updateUIModeLight(mode)
    }
    
    @IBAction func uiModeDidChange(_ sender: UISwitch) {
        defaults.set(sender.isOn, forKey: DefaultKeys.uiMode.rawValue)
        updateUIModeLight(sender.isOn)
    }
    
    

    @IBAction func segmentedDidChange(_ sender: UISegmentedControl) {
        defaults.set(sender.selectedSegmentIndex, forKey: DefaultKeys.defaultTipIndex.rawValue)
        defaults.synchronize()
    }
    
    func updateUIModeLight(_ shouldUpdate: Bool) {
        if shouldUpdate {
            self.view.backgroundColor = .white
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.tintColor = .black

            self.selectModeLabel.textColor = .black
            self.selectValueLabel.textColor = .black
        } else {
            
            self.view.backgroundColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.tintColor = .white
            
            self.selectModeLabel.textColor = .white
            self.selectValueLabel.textColor = .white
        }
    }
}
