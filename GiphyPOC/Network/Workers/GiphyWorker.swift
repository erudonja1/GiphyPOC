//
//  GiphyWorker.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//
import ObjectMapper
import Foundation

final class GiphyWorker {
    
    func fetchList(queryString: String, page: Int, success: ApiClient.SuccessCompletion<[GiphyResponse]>, failure: ApiClient.FailureCompletion) {
        let request = GiphyRequests.list(apiKey: ApiHost.apiKey, q: queryString, page: page)
        ApiClient.shared.request(request, success: { json in
            let dataJson = json["data"]
            let giphyResponses: [GiphyResponse] = Mapper<GiphyResponse>().mapArray(JSONObject: dataJson) ?? [GiphyResponse]()
            success?(giphyResponses)
        
        }, failure: failure)
    }

}
