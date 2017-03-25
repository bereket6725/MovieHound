//
//  MovieCollectionViewController.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/4/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import UIKit
import SafariServices
import SVProgressHUD
import PercentEncoder
import SwiftyJSON

private let reuseIdentifier = "Cell"

class MovieCollectionViewController: UICollectionViewController {
    var nowPlaying = [MovieModel]()
    let movieTransitionDelegate = MovieTransitionDelegate()


    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlayingMovies()
    }
    func loadPlayingMovies(){
        callMovieNowPlayingAPI{ movieArray in
            self.nowPlaying = movieArray
            self.collectionView?.reloadData()
        }
    }
    
    func callMovieNowPlayingAPI(completion: @escaping(([MovieModel])->Void)){
        APIManager.makeNetworkRequest(urlString: Constants.APIURLS.nowPlayingMovieAPIURL, completion: { results in
            DispatchQueue.main.async {
                completion(results)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.nowPlaying.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        let movie = nowPlaying[indexPath.row]
        cell.movieTitleLabel.text = movie.title
        CacheManager.getImage(forCell: cell, withMovieObject: movie)
        // Configure the cell
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showOverLay(forIndexPath: indexPath)
        
    }

    func showOverLay(forIndexPath indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let overlayVC = storyboard.instantiateViewController(withIdentifier: "Overlay") as! DetailMovieViewController
        overlayVC.delegate = self
        transitioningDelegate = movieTransitionDelegate
        overlayVC.transitioningDelegate = movieTransitionDelegate
        overlayVC.modalPresentationStyle = .custom
        let movie = nowPlaying[indexPath.row]
        self.present(overlayVC, animated: true, completion: nil)
        overlayVC.movieItem = movie
    }
}

let nytAPIKey = "b915e0e8e17f40b8a425f0d3ff73c0f2"

extension MovieCollectionViewController: DetailMovieViewControllerDelegate  {
    
    func detailMovieViewControllerUserDidTapDetails(_ controller: DetailMovieViewController) {
        self.dismiss(animated: true) {
            SVProgressHUD.show()
            // TODO: make a network request to determine URL to display
            let query = "Get Out".ped_encodeURI()
            let urlString = "https://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=\(nytAPIKey)&query=\(query)"
            APIManager.makeRawNetworkRequest(urlString: urlString, completion: { (data) in
                SVProgressHUD.dismiss()
                let json = JSON(data: data)
                let results = json["results"].arrayValue
                let firstResult = results.first!
                let link = firstResult["link"].dictionaryValue["url"]!.stringValue
                
                // TODO: parse data and extract URL, then present that URL
                let viewController = SFSafariViewController(url: URL(string: link)!)
                self.present(viewController, animated: true, completion: nil)
            })
        }
    }
    
}
