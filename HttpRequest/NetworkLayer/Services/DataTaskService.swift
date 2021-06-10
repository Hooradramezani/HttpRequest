//
//  ApiRequest.swift
//  HttpRequest
//
//  Created by Hoorad on 6/28/20.
//  Copyright © 2020 Hoorad. All rights reserved.
//

import Foundation


public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()


protocol NetworkRouter{
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

protocol DataTaskDelegate {
    typealias Response = ((Result<Data,Error>) -> Void)
    func StartDataTask(_ request: URLRequest,completion: @escaping Response)
    func CancelDataTask()
}

final class DataTaskService: DataTaskDelegate{
        
    //MARK: Dependency Injection
    private var session : URLSession
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    //MARK: Properties
    private var task: URLSessionTask?
    
    //MARK: Start Task
    func StartDataTask(_ request: URLRequest, completion: @escaping (Result<Data,Error>) -> Void) {
        
        task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            do{
                let data = try self.ValidateResponse(response as? HTTPURLResponse,data)
                completion(.success(data))
            }catch let err{
                completion(.failure(err))
            }
        })
        self.task?.resume()
    }
    
    func CancelDataTask() {
        task?.cancel()
    }
    
}

extension DataTaskService{
    
    private func ValidateResponse(_ Response: HTTPURLResponse?, _ data: Data?) throws -> Data {
        guard let response = Response else { throw HTTPNetworkError.badRequest }
        switch response.statusCode {
        case 400:
            throw HTTPNetworkError.badRequest
        default:
            break
        }
        guard let data = data else { throw HTTPNetworkError.noData }
        return data
    }
}



protocol UploadTaskDelegate {
    func UploadTask(_ request: HTTPRequest,completion: @escaping(Data?, Error?) -> Void)
}
struct UploadTask: UploadTaskDelegate {
    
    func UploadTask(_ request: HTTPRequest, completion: @escaping (Data?, Error?) -> Void) {
        
    }
}
