//
//  ResponseMapper.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import Foundation

protocol ApiResponseMapper {
    associatedtype T
    associatedtype U
    
    static func map(response: [T]) -> [U]
    
    // If you return nil, then map will ignore your data
    static func transform(response: T) -> U?
}

extension ApiResponseMapper {
    static func map(response: [T]) -> [U] {
        return response.compactMap(transform)
    }
    
    static func map(response: T) -> U? {
        return transform(response: response)
    }
}
