//
//  ViewController.swift
//  Calculator
//
//  Created by Eduardo Barrón on 03/08/17.
//  Copyright © 2017 QuetzalCode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    var isUserTipingSomenthing = false
    var brain = CalculatorBrain()

    @IBAction func appendDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if isUserTipingSomenthing{
            display.text = display.text! + digit
        }else{
            display.text = digit
            isUserTipingSomenthing = true
        }
        //print("digit = \(digit)")
    }
    
    @IBAction func enter() {
        isUserTipingSomenthing = false;
        if let result = brain.pushOperand(operand: displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
    }
    
    var displayValue:Double{
        get{
            return Double(display.text!) ?? 0
        }
        set{
            display.text! = "\(newValue)"
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        if isUserTipingSomenthing{
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(symbol: operation){
                displayValue = result
            }else{
                displayValue = 0
            }

        }
    }
}

