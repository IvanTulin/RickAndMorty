//
//  RMRequest.swift
//  NewRickAndMorty
//
//  Created by Ivan Tulin on 18.11.2023.
//

import Foundation

///UrlSessionRequets
struct RMRequest{
    
    private let baseUrl = "https://rickandmortyapi.com/api"
    private let endPoint: EndPoint
    private let pathComponent: [String]
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var string = baseUrl
        string += "/"
        string += endPoint.rawValue
        
        if !pathComponent.isEmpty {
            pathComponent.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap {
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
     init(endPoint: EndPoint, pathComponent: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponent = pathComponent
        self.queryParameters = queryParameters
    }
    
}
