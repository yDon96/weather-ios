//
//  ApiService.swift
//  CloudyEye
//
//  Created by Youssef Donadeo on 05/10/22.
//

import Foundation

class ApiService {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    
    func fetch<Request: Encodable, Response: Decodable>(_ endpoint: Endpoint,
                                                        method: Method = .get,
                                                        body: Request? = nil,
                                                        then callback: ((Result<Response, ApiService.Error>) -> Void)? = nil)
    {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.httpMethod = method.rawValue
        
        if let body = body {
            do{
                urlRequest.httpBody = try self.encoder.encode(body)
            } catch {
                callback?(.failure(.internal(reason: "Could not encode body request")))
            }
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            if let error = error {
                callback?(.failure(.generic(reason: "Could not fetch data: \(error.localizedDescription)")))
            } else if let data = data {
                do {
                    let result = try self.decoder.decode(Response.self, from: data)
                    callback?(.success(result))
                } catch {
                    callback?(.failure(.generic(reason: "Could not decode data: \(error.localizedDescription)")))
                }
            }
        }
        
        dataTask.resume()
        
    }
}

extension ApiService {
    
    enum Error: LocalizedError {
        case generic(reason: String)
        case `internal`(reason: String)
        
        var errorDescription: String? {
            switch self {
            case .generic(let reason):
                return reason
            case .internal(let reason):
                return "Internal Error: \(reason)"
            }
        }
    }
    
    enum Method: String {
        case get
        case post
    }
    
    enum Endpoint {
        case forcast(query: String)
        
        var url: URL {
            var components = URLComponents()
            components.host = "api.open-meteo.com"
            components.scheme = "https"
            switch self {
            case .forcast(let query):
                components.path = "v1/forecast"
                components.queryItems = [
                    URLQueryItem(name: "topic", value: query),
                    URLQueryItem(name: "page", value: "urls")
                ]

            }
            return components.url!
        }
    }
}
