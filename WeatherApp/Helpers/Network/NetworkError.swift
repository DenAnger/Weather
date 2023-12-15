//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Denis Abramov on 28.11.2023.
//

import Foundation

enum NetworkError: Error {
    case informationalError
    case noError
    case redirectionError
    case clientError
    case serverError
    case undefinedError
    case failedRequestError
    case jsonConversionError
    case invalidDataError
    case unauthorisedResponseError
    case httpResponseError
    case jsonParsingError
    case invalidURLError

    var localizedDescription: String {
        
        switch self {
        case .informationalError: 
            return "Informational error"
        case .noError: 
            return "No error"
        case .redirectionError: 
            return "Redirection error"
        case .clientError: 
            return "Client error occurred"
        case .serverError: 
            return "Service error occurred"
        case .undefinedError: 
            return "Undefined error occurred"
        case .failedRequestError: 
            return "Request failed"
        case .invalidDataError: 
            return "received invalid data from server"
        case .unauthorisedResponseError: 
            return "Unauthorised web service access"
        case .httpResponseError: 
            return "Response unsuccessful"
        case .jsonParsingError: 
            return "Failed to decode received data"
        case .jsonConversionError: 
            return "Failed to encode data"
        case .invalidURLError: 
            return "Invalid URL"
        }
    }
}
