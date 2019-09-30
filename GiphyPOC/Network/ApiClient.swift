//
//  ApiClient.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import Foundation
import Alamofire

struct ApiClient {
    
    typealias JSON = [String: Any]
    typealias SuccessCompletion<T> = ((T) -> Void)?
    typealias FailureCompletion = ((ApiError) -> Void)?
    
    static let shared = ApiClient()
    
    func request(_ request: ApiRequest, success: SuccessCompletion<JSON>, failure: FailureCompletion) {
        let request = prepareRequest(request)
        request.validate().response { (response) in
            do {
                try self.validateResponse(response)
                var json = JSON()
                if let data = response.data, let responseJson = try self.serializeToJson(data: data) {
                    json = responseJson
                }
                
                success?(json)
            } catch {
                let responseError = error as? ApiError ?? ApiError.generic
                failure?(responseError)
            }
        }
    }
}

private extension ApiClient {
    
    private var host: ApiHost {
        return .development
    }
    
    private func prepareRequest(_ request: ApiRequest) -> DataRequest {
        let endpointUrl = "\(host.rawValue)/\(request.path)"
        return Alamofire.request(endpointUrl, method: request.method, parameters: request.parameters, encoding: request.encoding, headers: request.headers)
    }
    
    private func validateResponse(_ response: DefaultDataResponse) throws {
        let statusCode = response.response?.statusCode ?? 0
        
        switch statusCode {
        case 401:
            throw ApiError.invalidCredentials
        case 500..<Int.max:
            throw ApiError.server(statusCode: statusCode)
        case 400..<500:
            throw ApiError.request(statusCode: statusCode)
        case 0:
            if let urlError = response.error as? URLError {
                switch urlError.code {
                case URLError.timedOut:
                    throw ApiError.timeout
                case URLError.notConnectedToInternet, URLError.networkConnectionLost:
                    throw ApiError.noInternetConnection
                default:
                    throw ApiError.generic
                }
            }
        default:
            break
        }
    }
    
    private func serializeToJson(data: Data) throws -> JSON? {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    }

}
