//
//  NetworkError.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case noResponse
    case invalidResponseType
    case statusCodeError(statusCode: Int)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "잘못된 URL 입니다."
        case .requestFailed(let error):
            "요청에 실패하였습니다.\n에러: \(error.localizedDescription)"
        case .noResponse:
            "서버로부터 응답을 받지 못했습니다."
        case .invalidResponseType:
            "응답 형식이 유효하지 않습니다."
        case .statusCodeError(let statusCode):
            "잘못된 상태 코드입니다 - \(statusCode)"
        case .noData:
            "데이터를 받지 못했습니다."
        }
    }
}
