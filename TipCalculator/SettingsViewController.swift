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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iTip Settings"
        let defaultSegmentedIndex = defaults.integer(forKey: DefaultKeys.defaultTipIndex.rawValue)
        segmentedControl.selectedSegmentIndex = defaultSegmentedIndex
    }
    
    

    @IBAction func segmentedDidChange(_ sender: UISegmentedControl) {
        defaults.set(sender.selectedSegmentIndex, forKey: DefaultKeys.defaultTipIndex.rawValue)
        defaults.synchronize()
    }
}
