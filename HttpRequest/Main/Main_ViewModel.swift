//
//  MainViewModel.swift
//  HttpRequest
//
//  Created by Hoorad on 6/29/20.
//  Copyright © 2020 Hoorad. All rights reserved.
//

import Foundation


struct MainViewModel {
    
    var service : ServiceController = ServiceController()
        
    func fetch(){
                
        service.RequestFor(api: .Feed) { (data, err) in
            print("Don")
            
            if let err = err {
                print(err.localizedDescription)
            }else if let data = data{
                print(data)
            }
        }
        
    }
}
