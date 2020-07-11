    //
//  File.swift
//  HttpRequest
//
//  Created by Hoorad on 7/4/20.
//  Copyright © 2020 Hoorad. All rights reserved.
//

import Foundation

struct ServiceNetworkTools : ServiceToolsProtocol {
    
    // Create a session for a URLSession
    var session : URLSession = {
        let session = URLSession.shared
        return session
    }()
    
    
    func configureRequest(_ httpRequest: HTTPRequest) throws -> URLRequest {
        
        guard let method = httpRequest.method  else {
            throw HTTPNetworkError.failed
        }
        guard let scheme = httpRequest.scheme else{
            throw HTTPNetworkError.missingURL
        }
        guard let host = httpRequest.host else{
            throw HTTPNetworkError.missingURL
        }
        guard let path = httpRequest.path else {
            throw HTTPNetworkError.missingURL
        }
        guard let url = getURL(scheme: scheme, path: path, host: host) else {
            throw HTTPNetworkError.missingURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method

        if httpRequest.headers != nil {
            guard let headers = httpRequest.headers else {
                throw HTTPNetworkError.headersNil
            }
            guard let headerfeilds = headers else {
                throw HTTPNetworkError.headersNil
            }
            request.allHTTPHeaderFields = headerfeilds
        }

        
        return request
    }
    

    
    func StartDataTaskWith(_ request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in

            if let data = data {
                completion(data,nil)
            }
            if let error = error {
                print ("\(error)")
                completion(nil,error)
            }
            
        })
        task.resume()
        
    }
    
    func JSONSerializationWith(_ data: Data, completion: @escaping([String:Any]?, Error?) -> Void) {
        
        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                completion(json,nil)
            }
        } catch let error as NSError {
            completion(nil,error)
        }
        
    }
    
    func getURL(scheme:String,path:String,host:String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        return component.url
    }
    
    
}
