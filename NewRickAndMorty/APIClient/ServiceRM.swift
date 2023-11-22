//
//  ServiceRM.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 18.11.2023.
//

import Foundation

final class ServiceRM {
    static let shared = ServiceRM()
    
    private init() {}
    
    enum RMServiceError: Error {
        case failedToRequest
        case failedToGetData
    }
    
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, compition: @escaping (Result<T,Error>)-> Void ) {
        guard let urlRequest = self.request(from: request) else {
            compition(.failure(RMServiceError.failedToRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                compition(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(type.self, from: data)
                compition(.success(json))
            } catch  {
                compition(.failure(error))
            }
        }
        task.resume()
        
    }
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
