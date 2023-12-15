//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Denis Abramov on 29.11.2023.
//

import Foundation

class NetworkManager {
    var client: NetworkClientProtocol

    init(client: NetworkClientProtocol) {
        self.client = client
    }

    func fetch<T>(with request: URLRequest,
                  decodingType: T.Type,
                  completion: @escaping(Result<T,
                                        NetworkError>)-> Void) where T: Decodable {
        
        self.client.fetch(with: request, decodingType: decodingType) { result in
            completion(result)
        }
    }
}
