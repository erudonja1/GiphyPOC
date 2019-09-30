//
//  GiphyManager.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import Foundation

class GiphyManager: BaseManagerProtocol {
    
    func fetchGiphys(for query: String, page: Int, success: SuccessCompletion<[Giphy]>, failure: FailureCompletion) {
        let worker = GiphyWorker()
        worker.fetchList(queryString: query, page: page, success: { (giphyResponses) in
            // map list of objects from response to the list of models
            let giphysList = GiphyResponseMapper.map(response: giphyResponses)
            success?(giphysList)
        }, failure: failure)
    }
}
