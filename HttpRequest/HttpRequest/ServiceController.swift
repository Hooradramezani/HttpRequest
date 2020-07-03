//
//  Apis.swift
//  HttpRequest
//
//  Created by Hoorad on 6/29/20.
//  Copyright © 2020 Hoorad. All rights reserved.
//

import Foundation


struct ServiceController {
    
    var service : ServiceNetworkLayer = ServiceNetworkLayer()
    
    enum ApisList{
        case Feed
    }
    
    var FeedApiRequest : GetRequest = {
        var feedRequest = GetRequest()
        feedRequest.headers = [Headers(dictionaryLiteral: ("Content-Type", "application/json"))]
        feedRequest.method = HTTPMethod.get.rawValue
        feedRequest.path = "/facts"
        feedRequest.scheme = "https"
        feedRequest.host = "cat-fact.herokuapp.com"
        return feedRequest
    }()
    
    
    func MakeRequestFor(api:ApisList,completion: (Data, Error) -> Void){
        
        switch api {
        case .Feed:
            service.get(FeedApiRequest) { (data, err) in
                if let data = data {
                    print("We Have Data \(data)")
                }else if let err = err {
                    print("we Have Err : \(err)")
                }
            }
        }
        
    }
    
}
