//
//  MovieCollectionViewController.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/4/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MovieCollectionViewController: UICollectionViewController {
    var nowPlaying = [MovieModel]()

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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

   }
