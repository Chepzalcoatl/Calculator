//
//  ViewController.swift
//  Calculator
//
//  Created by Eduardo Barron on 30/10/15.
//  Copyright © 2015 Eduardo Barron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    var userIsTyping = false
    var operandStack = Array<Double>()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userIsTyping){
            display.text = display.text! + digit
        }else{
            userIsTyping = true
            display.text = digit
        }
    }
    
    @IBAction func enter() {
        userIsTyping = false
        operandStack.append(displayValue)
        print("Operand Stack = \(operandStack)")
    }
    
    var displayValue : Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsTyping = false;
            
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if(userIsTyping){
            enter()
        }
        
        switch operation{
            case "×": performOperation {$0 * $1}
            case "÷": performOperation {$1 / $0}
            case "+": performOperation {$0 + $1}
            case "−": performOperation {$1 - $0}
            default:break;
        }
    }
    
    func performOperation(operation:(Double, Double) ->Double){
        if operandStack.count>=2{
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    
}

