//
//  ViewController.swift
//  Calculator
//
//  Created by Senghuot Lim on 9/19/17.
//  Copyright © 2017 Home Brew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var descriptionDisplay: UILabel!
    @IBOutlet weak var display: UILabel!

    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    private var brain = CalculatorBrain()
    
    private var userInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userInTheMiddleOfTyping = true
        }
        brain.unaryOperatorCompleted = false;
    }
    
    private var usedDecimal = false
    
    @IBAction func decimalTouch(_ sender: UIButton) {
        if usedDecimal {
            return
        }

        usedDecimal = true
        
        if userInTheMiddleOfTyping {
            display.text = display.text! + sender.currentTitle!
        } else {
            display.text = sender.currentTitle!
            userInTheMiddleOfTyping = true
        }
    }
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
            usedDecimal = false
            if brain.result != nil {
                displayValue = brain.result!
            }
            descriptionDisplay.text! = brain.descriptionResult
        }
    }
}

