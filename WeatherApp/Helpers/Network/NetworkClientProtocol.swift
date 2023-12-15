//
//  NetworkClientProtocol.swift
//  WeatherApp
//
//  Created by Denis Abramov on 29.11.2023.
//

import Foundation

protocol NetworkClientProtocol {
    func fetch<T: Decodable>(with request: URLRequest,
                             decodingType: T.Type,
                             completion: @escaping (Result<T,
                                                    NetworkError>) -> Void)
}
