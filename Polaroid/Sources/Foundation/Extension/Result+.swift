//
//  Result+.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

extension Result where Success == Data, Failure == Error {
    func decode<T: Decodable>(type: T.Type) -> Result<T, Error> {
        flatMap { success in
            do {
                let newSuccess = try JSONDecoder().decode(type, from: success)
                return .success(newSuccess)
            } catch {
                return .failure(error)
            }
        }
    }
}
