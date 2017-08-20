//
//  ViewController.swift
//  TipCalculator
//
//  Created by Antonio Alves on 8/20/17.
//  Copyright © 2017 Antonio Alves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var itemsView: UIView!
    @IBOutlet weak var itemsViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "MyriadPro-Light", size: 25)!], for: .normal)
        displayTextField.becomeFirstResponder()
        self.updateAnimated(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        print(amoutFloat)
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
            tipLabel.text = "$\(tip)"
            totalLabel.text = "$\(total)"
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
    

}


