//
//  GiphyListRequest.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import Alamofire

enum GiphyRequests: ApiRequest {
    case list(apiKey: String, q: String, page: Int)
    
    var path: String {
        switch self {
        case .list:
            return "search"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .list(apiKey, q, page):
            return ["api_key": apiKey,
                    "q": q,
                    "offset": page * 20,
                    "limit": 20
            ]
        }
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
}
