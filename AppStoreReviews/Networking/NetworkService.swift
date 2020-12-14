//
//  NetworkService.swift
//  AppStoreReviews
//
//  Created by Eduard Stern on 21/09/2020.
//  Copyright © 2020 ING. All rights reserved.
//

import Foundation

typealias NetworkResponseClosure<T: Decodable> = (Swift.Result<T, Error>) -> ()

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

protocol NetworkServiceInterface {
    func fetch<T: Decodable>(_ request: APIMapping, completion: @escaping NetworkResponseClosure<T>)
}

class NetworkService: NetworkServiceInterface {
    
    func fetch<T: Decodable>(_ request: APIMapping, completion: @escaping NetworkResponseClosure<T>) {
       
        URLSession.shared.dataTask(with: request.urlRequest) { data, response, error in
              do {
                if let error = error {
                  completion(.failure(error))
                  return
                }

                guard let data = data else {
                  preconditionFailure("No error was received but we also don't have data...")
                }

                let decodedObject = try JSONDecoder().decode(T.self, from: data)

                completion(.success(decodedObject))
              } catch {
                completion(.failure(error))
              }
            }.resume()
    }
}
