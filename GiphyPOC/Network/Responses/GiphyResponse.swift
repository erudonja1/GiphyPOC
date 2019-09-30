//
//  GiphyResponse.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import ObjectMapper

class GiphyResponse: Mappable {
    private(set) var id = ""
    private(set) var title = ""
    private(set) var url = ""
    
    required convenience init(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        url <- map["images.fixed_height.url"]
    }
}
