//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Senghuot Lim on 9/20/17.
//  Copyright © 2017 Home Brew. All rights reserved.
//

import Foundation

struct CalculatorBrain {

    private var accumulator: Double?
    private var resultsInPending = false
    public var unaryOperatorCompleted = false
    private var description = ""
    
    mutating func setOperand(_ value: Double) {
        accumulator = value
    }
    
    enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case clear
        case equal
    }
    
    private let OperationMap: [String: Operation] = [
        "π"     : Operation.constant(Double.pi),
        "√"     : Operation.unaryOperation(sqrt),
        "±"     : Operation.unaryOperation({return -$0}),
        "+"     : Operation.binaryOperation({return $0 + $1}),
        "−"     : Operation.binaryOperation({return $0 - $1}),
        "÷"     : Operation.binaryOperation({return $0 / $1}),
        "×"     : Operation.binaryOperation({return $0 * $1}),
        "C"     : Operation.clear,
        "="     : Operation.equal
    ]

    mutating func performOperation(symbol: String) {
        if let operation = OperationMap[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                unaryOperatorCompleted = true
                if resultsInPending {
                    description += "\(symbol)(\(accumulator!))"
                } else {
                    description = "\(symbol)(\(description))"
                }
                accumulator = function(accumulator!)
            case .binaryOperation(let function):
                if accumulator != nil {
                    pbo = pendingBinaryOperation(firstOperand: accumulator!, function: function)
                    resultsInPending = true
                }
                
                if (description == "") {
                  description += "\(accumulator!) \(symbol)"
                } else {
                  description += " \(symbol)"
                }
                
            case .clear:
                if (accumulator == nil) {
                    return
                }
                
                if (accumulator! != 0) {
                    accumulator = 0
                } else {
                    pbo = nil
                }
                description = ""
            case .equal:
                if !unaryOperatorCompleted {
                    description += " \(accumulator!)"
                }
                
                if (pbo != nil && accumulator != nil) {
                    accumulator = pbo?.compute(with: accumulator!)
                    pbo = nil
                }
                
                resultsInPending = false
                unaryOperatorCompleted = false
            }
        }
    }
    
    private var pbo: pendingBinaryOperation?
    
    struct pendingBinaryOperation {
        let firstOperand: Double
        let function: ((Double, Double) -> Double)
        
        func compute(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }

    var descriptionResult: String {
        get {
            if (resultsInPending) {
                return "\(description) ..."
            } else {
                return description != "" ? "\(description) =" : " "
            }
        }
    }
}
