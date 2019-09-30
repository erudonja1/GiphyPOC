//
//  GiphyResponseMapper.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import Foundation

final class GiphyResponseMapper: ApiResponseMapper {
    static func transform(response: GiphyResponse) -> Giphy? {
        return Giphy(id: response.id,
                     title: response.title,
                     url: response.url,
                     cachedImage: nil)
    }
}
