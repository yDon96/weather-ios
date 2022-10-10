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
    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
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
                
        let dataTask = urlSession.dataTask(with: urlRequest){ data, response, error in
            if let error = error {
                callback?(.failure(.generic(reason: "Could not fetch data: \(error.localizedDescription)")))
            } else if let data = data {
                
                guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                    callback?(.failure(.generic(reason: "This is a BadRequest")))
                    return
                }

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
        case forcast(query: Codable)
        
        var url: URL {
            var components = URLComponents()
            components.host = "api.open-meteo.com"
            components.scheme = "https"
            switch self {
                case .forcast(let query):
                    let mirror = Mirror(reflecting: query)
                    var queryItems : [URLQueryItem] = []
                    mirror.children.forEach { child in
                        let myQuery = MyURLQueryItem(name: child.label!, value: child.value)
                        queryItems.append(myQuery.getQueryItem())
                    }
                    components.path = "/v1/forecast"
                    components.queryItems = queryItems
            }
            return components.url!
        }
    }
}

class MyURLQueryItem {
    var name: String
    var value: String?
    
    convenience init(name: String, value: Any?) {
        if let myStringArray = value as? String {
            self.init(name: name, value: myStringArray)
        } else if let myStringArray = value as? [String] {
            self.init(name: name, value: myStringArray)
        } else if let myStringArray = value as? Float {
            self.init(name: name, value: myStringArray)
        } else if let myStringArray = value as? Int {
            self.init(name: name, value: myStringArray)
        } else {
            self.init(name: name)
        }
    }
    
    init(name: String) {
        self.name = name
        self.value = nil
    }
    
    init(name: String, value: String?){
        self.name = name
        if let myString = value {
            self.value = myString
        }
    }
    
    init(name: String, value: Float?){
        self.name = name
        if let myFloat = value {
            self.value = String(format: "%.2f", myFloat)
        }
    }
    
   init(name: String, value: Int?){
        self.name = name
        if let myInt = value {
            self.value = String(myInt)
        }
    }
    
    init(name: String, value: [String]?){
        self.name = name
        if let myStringArray = value {
            self.value = myStringArray.joined(separator: ",")
        }
    }
    
    func getQueryItem() -> URLQueryItem {
        return URLQueryItem(name: self.name, value: self.value)
    }
}
