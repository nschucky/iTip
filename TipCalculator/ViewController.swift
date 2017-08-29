//
//  ViewController.swift
//  TipCalculator
//
//  Created by Antonio Alves on 8/20/17.
//  Copyright © 2017 Antonio Alves. All rights reserved.
//

import UIKit

enum DefaultKeys: String {
    case defaultTipIndex
    case lastCalculatorValue
    case uiMode
    case lastDate
}

class ViewController: UIViewController {
    
    @IBOutlet weak var displayTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var itemsView: UIView!
    @IBOutlet weak var yourTipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    
    var isTyping = false
    let defaults = UserDefaults.standard
    let numberFormatter = NumberFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "MyriadPro-Light", size: 25)!], for: .normal)
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidBecomeActive, object: nil, queue: OperationQueue.main, using: applicationDidBecomeActive)
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillResignActive, object: nil, queue: OperationQueue.main, using: applicationWillResign)
        
        registerForAction()
    }
    
    func registerForAction() {
        guard let lastTip = tipLabel.text, lastTip != "" else { return }
        if let bundleId = Bundle.main.bundleIdentifier {
            let type = bundleId + ".DynamicAction"
            
            let newQuickAction = UIApplicationShortcutItem(type: type, localizedTitle: "Copy Last Result", localizedSubtitle: lastTip, icon: nil, userInfo: nil)

            UIApplication.shared.shortcutItems = []
            var existingShortcutItems = UIApplication.shared.shortcutItems ?? []
            if !existingShortcutItems.contains(newQuickAction) {
                
                existingShortcutItems.append(newQuickAction)
                UIApplication.shared.shortcutItems = existingShortcutItems
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaultSegmentedIndex = defaults.integer(forKey: DefaultKeys.defaultTipIndex.rawValue)
        segmentedControl.selectedSegmentIndex = defaultSegmentedIndex
        self.updateAnimated(false)
        let mode = defaults.bool(forKey: DefaultKeys.uiMode.rawValue)
        updateUILightMode(mode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        displayTextField.becomeFirstResponder()
        
    }
    
    func updateUILightMode(_ mode: Bool) {
        if mode {
            self.view.backgroundColor = .white
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.tintColor = .black
            
            displayTextField.textColor = .black
            yourTipLabel.textColor = .black
            totalLabel.textColor = .black
            tipLabel.textColor = .black
            totalTextLabel.textColor = .black
            settingsBarButton.tintColor = .black
        } else {
            self.view.backgroundColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.tintColor = .white
            
            displayTextField.textColor = .white
            yourTipLabel.textColor = .white
            totalLabel.textColor = .white
            tipLabel.textColor = .white
            totalTextLabel.textColor = .white
            settingsBarButton.tintColor = .white
        }
    }
    

    @IBAction func segmentedDidChange(_ sender: UISegmentedControl) {
        updateValues()
    }
    
    @IBAction func displayValueDidChange(_ sender: UITextField) {
        updateAnimated(true)
    }
    
    func updateAnimated(_ animated: Bool) {
        guard let amountString = displayTextField.text as NSString? else { return }
        let amoutFloat = amountString.floatValue
        if amoutFloat == 0 {
            isTyping = false
            hideResultsViewAnimated(animated)
        } else if amoutFloat > 0 && !isTyping {
            showResultsViewsAnimated(animated)
            isTyping = !isTyping
        }
        updateValues()
    }
    
    
    func updateValues() {
        if let displayValue = displayTextField.text as NSString? {
            var total: Float = 0
            var tip: Float = 0
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                total = displayValue.floatValue * 1.15
                tip = displayValue.floatValue * 0.15
            case 1:
                total = displayValue.floatValue * 1.18
                tip = displayValue.floatValue * 0.18
            case 2:
                total = displayValue.floatValue * 1.20
                tip = displayValue.floatValue * 0.20
            case 3:
                total = displayValue.floatValue * 1.25
                tip = displayValue.floatValue * 0.25
            default:
                total = 0
                tip = 0
            }
            numberFormatter.numberStyle = .currency
            let tipNumber = NSNumber(value: tip)
            let totalNumber = NSNumber(value: total)
            tipLabel.text = numberFormatter.string(from: tipNumber)
            totalLabel.text = numberFormatter.string(from: totalNumber)
            registerForAction()
        }
    }
    
    func showResultsView() {
        self.itemsView.frame.origin.y = 0
        self.itemsView.isHidden = false
        
    }
    
    func hideResultsView() {
        self.itemsView.frame.origin.y = self.view.frame.height
        self.itemsView.isHidden = true
        
    }
    
    func showResultsViewsAnimated(_ animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.7, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
                self.showResultsView()
            }, completion: nil)
        } else {
            self.showResultsView()
        }

    }
    
    func hideResultsViewAnimated(_ animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
                self.hideResultsView()
            }, completion: { finished in
                
            })
        } else {
            self.hideResultsView()
            self.itemsView.isHidden = true
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        guard let lastValue = defaults.string(forKey: DefaultKeys.lastCalculatorValue.rawValue) else { return }
        displayTextField.becomeFirstResponder()
        
        guard let lastDate = defaults.value(forKey: DefaultKeys.lastDate.rawValue) as? Date else { return }
        let date = Date()
        if date.timeIntervalSince(lastDate) < 10 * 60 {
            displayTextField.text = "\(lastValue)"
            updateAnimated(false)
        } else {
            displayTextField.text = nil
            updateAnimated(false)
        }
    }
    
    func applicationWillResign(_ notification: Notification) {
        let resignTime = Date()
        let lastValue = displayTextField.text
        defaults.set(lastValue, forKey: DefaultKeys.lastCalculatorValue.rawValue)
        defaults.set(resignTime, forKey: DefaultKeys.lastDate.rawValue)
    }
    
}


