//
//  ViewController.swift
//  GiphyPOC
//
//  Created by Home Account on 6/19/19.
//  Copyright © 2019 Elvis Rudonja. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    private var viewModel: HomeViewModel = HomeViewModel()
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setup(output: self as HomeViewProtocol)
        setupView()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        viewModel.reset()
        viewModel.queryString = searchTextField.text ?? ""
        viewModel.search()
        collectionView.reloadData()
    }
    
    private func setupView(){
        // set delegates
        searchTextField.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // register cells
        let collectionCellNib = UINib(nibName: "GiphyCollectionCellView", bundle: .main)
        collectionView.register(collectionCellNib, forCellWithReuseIdentifier: "GiphyCollectionCell")
        
        // set placeholders
        searchButton.setTitle("Search", for: .normal)
        searchButton.layer.cornerRadius = 22
        searchTextField.attributedPlaceholder = NSAttributedString(string: "name, tag, type...",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        hideKeyboardWhenTappedAround()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{

    func giphyObject(for indexPath: IndexPath) -> Giphy {
        return viewModel.giphys[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.giphys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // preparing gifs can take a lot processor power, so it is moved to viewmodel and multithreading
        let giphy = giphyObject(for: indexPath)
        viewModel.convertGif(id: giphy.id)
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiphyCollectionCell", for: indexPath) as? GiphyCollectionCell {
            cell.setup(title: giphy.title, url: giphy.url, cachedImage: giphy.cachedImage)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == (scrollView.contentSize.height - scrollView.frame.size.height) {
            viewModel.nextPage()
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.reset()
        viewModel.queryString = searchTextField.text ?? ""
        viewModel.search()
        collectionView.reloadData()
        searchTextField.resignFirstResponder()
        return true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension HomeViewController: HomeViewProtocol {
    func showResults(results: [Giphy]) {
        collectionView.reloadData()
    }
    
    func imageUpdated(for indexPath: IndexPath) {
        DispatchQueue.main.async() {
            self.collectionView.reloadItems(at: [indexPath])
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


