//
//  BaseManagerProtocol.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import Foundation

protocol BaseManagerProtocol {
    // MARK: Notes
    // here should be defined functions that we need by default implemented in every manager
    // CRUD operations mostly
}

extension BaseManagerProtocol {
    typealias SuccessCompletion<T> = ((T) -> Void)?
    typealias FailureCompletion = ((ApiError) -> Void)?
    
}
