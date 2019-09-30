//
//  ApiRequest.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import Alamofire

protocol ApiRequest {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}

extension ApiRequest {
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
