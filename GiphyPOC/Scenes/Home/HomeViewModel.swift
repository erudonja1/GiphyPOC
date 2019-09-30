//
//  HomeViewModel.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import Foundation
import UIKit

protocol HomeViewProtocol: class {
    func showResults(results: [Giphy])
    func showError(message: String)
    
    func imageUpdated(for indexPath: IndexPath)
}

class HomeViewModel {
    weak var output: HomeViewProtocol?
    var giphys: [Giphy] = []
    var queryString: String = ""
    var currentPage: Int = 0
    private var conversionManager = ConversionManager()
    
    func setup(output delegate: HomeViewProtocol) {
        self.output = delegate
        self.conversionManager.setup(delegate: self as ConvertingProtocol)
    }
    
    func search(){
        let manager = GiphyManager()
        
        manager.fetchGiphys(for: queryString, page: currentPage, success: { results in
            
            if results.isEmpty == false {
                self.giphys.append(contentsOf: results)
                self.output?.showResults(results: self.giphys)
            }
            
            // If there is no results, that means nothing should be refreshed on view.
        }, failure: { error in
            let message = error.errorDescription ?? "Ooops, something went wrong. Please try again."
            self.output?.showError(message: message)
        })
    }
    
    func nextPage(){
        self.currentPage = self.currentPage + 1
        self.search()
    }
    
    func reset(){
        queryString = ""
        currentPage = 0
        giphys = []
    }
}

extension HomeViewModel: ConvertingProtocol {

    func convertGif(id: String){
        if let giphy = giphys.first(where: {$0.id == id}), giphy.cachedImage == nil {
            self.conversionManager.convertToImage(id: id, url: giphy.url)
        }
    }
    
    func gifConverted(id: String, image: UIImage?){
        if let index = giphys.firstIndex(where: {$0.id == id}) {
            giphys[index].cachedImage = image
            let indexPath = IndexPath(row: index, section: 0)
            self.output?.imageUpdated(for: indexPath)
        }
    }

}
