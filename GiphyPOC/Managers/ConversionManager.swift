//
//  ConvertManager.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import Foundation
import UIKit

protocol ConvertingProtocol: class {
    func convertGif(id: String)
    func gifConverted(id: String, image: UIImage?)
}

struct ConvertingProcess {
    let id: String
    let workItem: DispatchWorkItem
}

// This manager converts gif from NSData to UIImage. It does that based on multithreading, with maximum 12 processes in the same time
class ConversionManager {
    
    // buffer for tracking the current processes that are running in DispatchQueue
    var processBuffer: [ConvertingProcess] = []
    private var concurrentQueue: DispatchQueue?
    private weak var output: ConvertingProtocol?
    
    init() {
        concurrentQueue = DispatchQueue(label: "GifConverter", attributes: [.initiallyInactive, .concurrent])
        concurrentQueue?.setTarget(queue: DispatchQueue.global(qos: .background))
        concurrentQueue?.activate()
    }
    
    func setup(delegate: ConvertingProtocol) {
        self.output = delegate
    }
    
    func convertToImage(id: String, url: String) {
        // if there is no prepared image already
        if processBuffer.first(where: {$0.id == id}) == nil {
            
            // creating work item for conversion in background
            let convertingWorkItem = DispatchWorkItem {
                let gif = UIImage.gifImageWithURL(gifUrl: url)
                self.output?.gifConverted(id: id, image: gif)
            }
            
            // check how many are there in the buffer
            if processBuffer.count > 12 {
                
                // clean if if there are more than 12
                while processBuffer.count > 11 {
                    processBuffer[0].workItem.cancel()
                    processBuffer.removeFirst()
                }
            }
            
            let convertingProcess = ConvertingProcess(id: id, workItem: convertingWorkItem)
            processBuffer.append(convertingProcess)
            
            // start workitem as concurrent process
            // 2 seconds of timeout are needed because of scrolling
            concurrentQueue?.asyncAfter(deadline: .now() + .seconds(2), execute: convertingWorkItem)
        }
    }
    
}
