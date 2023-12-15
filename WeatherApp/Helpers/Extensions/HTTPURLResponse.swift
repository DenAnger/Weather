//
//  HTTPURLResponse.swift
//  WeatherApp
//
//  Created by Denis Abramov on 29.11.2023.
//

import Foundation

extension HTTPURLResponse {
    var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
    }

    var responseType: NetworkError {

        switch self.status?.responseType {
        case .informational:
            return .informationalError
        case .success:
            return .noError
        case .redirection:
            return .redirectionError
        case .clientError:
            return .clientError
        case .serverError:
            return .serverError
        default:
            return .undefinedError

        }
    }
}
