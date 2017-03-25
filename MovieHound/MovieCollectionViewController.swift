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



extension MovieCollectionViewController: DetailMovieViewControllerDelegate  {
    
    func detailMovieViewControllerUserDidTapDetails(_ controller: DetailMovieViewController) {
        let movieTitle = controller.movieItem?.title ?? ""
        self.dismiss(animated: true) {
            SVProgressHUD.show()
            APIManager.makeNYTNetworkRequest(forQuery: movieTitle, completion: { (result) in
                switch result {
                case .success(let url):
                    SVProgressHUD.dismiss()
                    let viewController = SFSafariViewController(url: url)
                    self.present(viewController, animated: true, completion: nil)
                case .error(let errorDescription):
                    SVProgressHUD.showError(withStatus: errorDescription)
                    SVProgressHUD.dismiss(withDelay: 2)
                }
            })
        }
    }
    
}
