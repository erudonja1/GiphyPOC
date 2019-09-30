//
//  ApiHost.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import Foundation

enum ApiHost: String {
    case development = "https://api.giphy.com/v1/gifs"
    //case production = "https://api.giphy.com/v1/gifs"
    
    static var apiKey: String{
        return "PrG2eRE0LosgNSv6SO6hokZAUOa6sweT" // development
    }
    
}
