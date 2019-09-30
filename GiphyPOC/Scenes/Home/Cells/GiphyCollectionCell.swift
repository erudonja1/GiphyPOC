//
//  GiphyCollectionCell.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import UIKit

enum LoadingState {
    case notLoading
    case loading
    case loaded(UIImage)
}

class GiphyCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var loadingState: LoadingState = .notLoading {
        didSet {
            switch loadingState {
            case .notLoading:
                self.imageView.image = nil
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            case .loading:
                self.imageView.image = nil
                self.activityIndicatorView.startAnimating()
                self.activityIndicatorView.isHidden = false
            case let .loaded(img):
                self.imageView.image = img
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            }
        }
    }
    
    func setup(title: String, url: String, cachedImage: UIImage?) {
        self.titleLabel.text = title
        if let cachedImage = cachedImage {
            loadingState = .loaded(cachedImage)
        } else {
            loadingState = .loading
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.loadingState = .notLoading
    }
}
