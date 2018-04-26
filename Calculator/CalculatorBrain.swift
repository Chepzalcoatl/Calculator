//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Eduardo Barrón on 04/08/17.
//  Copyright © 2017 QuetzalCode. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private enum Op : CustomStringConvertible{
        case Operand(Double)
        case UnaryOperation (String , (Double) -> Double)
        case BinaryOperation (String, (Double,Double)->Double)
        
        var description:String{
            get{
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol,_):
                    return symbol
                case .BinaryOperation(let symbol,_):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op:Op){
            knownOps[op.description] = op
        }
        learnOp(op: Op.BinaryOperation("×",*))
        learnOp(op: Op.BinaryOperation("÷"){$1 / $0})
        learnOp(op: Op.BinaryOperation("−"){$1 - $0})
        learnOp(op: Op.BinaryOperation("+",+))
        learnOp(op: Op.UnaryOperation("√",sqrt))
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol:String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func evaluate() -> Double? {
        let (result, reminder) = evaluate(ops: opStack)
        print("\(opStack) = \(String(describing: result)) with \(reminder) left over")
        return result
    }
    
    private func evaluate(ops:[Op]) -> (result:Double?, remainingOps:[Op]) {
        if(!ops.isEmpty){
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand,remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operationEvaluation = evaluate(ops: remainingOps)
                if let operand = operationEvaluation.result{
                    return(operation(operand),operationEvaluation.remainingOps)
                }
                
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(ops: remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(ops: op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        return (nil, ops)
    }
}
