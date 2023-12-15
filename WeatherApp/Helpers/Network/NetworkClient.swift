//
//  NetworkClient.swift
//  WeatherApp
//
//  Created by Denis Abramov on 29.11.2023.
//

import Foundation

final class NetworkClient: NetworkClientProtocol {
    
    private var session = URLSession(configuration: .default)
    
    func fetch<T>(with request: URLRequest,
                  decodingType: T.Type,
                  completion: @escaping(Result<T,
                                        NetworkError>) -> Void) where T: Decodable {
        
        let fetchTask = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(Result.failure(.failedRequestError))
                return
            }
            
            switch httpResponse.responseType {
            case .noError:
                
                if let data = data {
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType,
                                                                    from: data)
                        completion(.success(genericModel))
                    }  catch DecodingError.keyNotFound(let key, let context) {
                        print("could not find key \(key) in JSON: \(context.debugDescription)")
                        completion(.failure(.invalidDataError))
                    } catch DecodingError.valueNotFound(let type, let context) {
                        print("could not find type \(type) in JSON: \(context.debugDescription)")
                        completion(.failure(.invalidDataError))
                    } catch DecodingError.typeMismatch(let type, let context) {
                        print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                        completion(.failure(.invalidDataError))
                    } catch DecodingError.dataCorrupted(let context) {
                        print("data found to be corrupted in JSON: \(context.debugDescription)")
                        completion(.failure(.invalidDataError))
                    } catch let error as NSError {
                        NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                        completion(.failure(.invalidDataError))
                    }
                } else {
                    completion(.failure(.invalidDataError))
                }
            case .redirectionError,
                    .informationalError,
                    .clientError,
                    .serverError,
                    .undefinedError,
                    .failedRequestError,
                    .jsonConversionError,
                    .invalidDataError,
                    .unauthorisedResponseError,
                    .httpResponseError,
                    .jsonParsingError,
                    .invalidURLError:
                completion(.failure(httpResponse.responseType))
            }
        }
        fetchTask.resume()
    }
}
