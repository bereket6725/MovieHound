//
//  DetailMovieViewController.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/7/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import UIKit

class DetailMovieViewController: UIViewController {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    var movieItem:MovieModel? {
        didSet{
            configureView()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 20, height: 350)
        self.view.layer.cornerRadius = 5

    }
    func configureView(){
        if let movie = self.movieItem{
            self.titleLabel.text = movie.title
            self.descriptionTextView.text = movie.description
        }
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
