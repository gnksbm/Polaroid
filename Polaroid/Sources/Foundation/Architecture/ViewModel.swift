//
//  ViewModel.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input, cancelBag: inout CancelBag) -> Output
}
