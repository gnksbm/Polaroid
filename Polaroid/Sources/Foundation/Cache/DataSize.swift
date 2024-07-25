//
//  DataSize.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

struct DataSize {
    let amount: Int
    let unit: Unit
    
    var toBytes: Int {
        amount.convertToBytes(from: unit)
    }
    
    init(amount: Int, unit: Unit = .byte) {
        self.amount = amount
        self.unit = unit
    }
    
    enum Unit: Int {
        case byte, kiloByte, megaByte, gigaByte
        
        var byteMultiplier: Double {
            pow(1024.0, exponent)
        }
        
        private var exponent: Double {
            Double(rawValue)
        }
    }
}

extension FloatLiteralType {
    func convertToBytes(from dataSize: DataSize.Unit) -> Self {
        self * dataSize.byteMultiplier
    }
}

extension IntegerLiteralType {
    func convertToBytes(from dataSize: DataSize.Unit) -> Self {
        Int(Double(self) * dataSize.byteMultiplier)
    }
}
