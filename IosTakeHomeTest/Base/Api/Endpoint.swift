//
//  Endpoint.swift
//  IosTakeHomeTest
//
//  Created by AMBE on 11/11/2022.
//

import Foundation

enum Endpoint {
    case people(page: Int)
    case detail(id: Int)
    case create(submissionData: Data?)
}

extension Endpoint {
    enum MethodType {
        case GET
        case POST(body: Data?)
    }
    
}

extension Endpoint {
    
    var host: String {"reqres.in"}
    
    var path: String {
        switch self {
        case .people:
            return "/api/users"
        case .detail(let id):
            return "/api/users/\(id)"
        case .create:
            return "/api/users"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .people:
            return .GET
        case .detail:
            return .GET
        case .create(let data):
            return .POST(body: data)
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .people(let page):
            return ["page":"\(page)"]
        default:
            return nil

        }
    }
    
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = queryItems?.compactMap({ item in
            URLQueryItem(name: item.key, value: item.value)
        })
        
        #if DEBUG
        requestQueryItems?.append(URLQueryItem(name: "delay", value: "1"))
        #endif
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}
