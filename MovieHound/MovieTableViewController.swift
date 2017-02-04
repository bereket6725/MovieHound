//
//  MovieTableViewController.swift
//  MovieHound
//
//  Created by Bereket Ghebremedhin on 2/2/17.
//  Copyright © 2017 Bereket Ghebremedhin. All rights reserved.
//

import UIKit

class MovieTableViewController: UITableViewController {
    var nowPlaying = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    func loadData(){
        Movie.nowPLaying { (success: Bool, movieList: [Movie]?) in
            //print(movieList ?? "couldnt get a movie List :(")
            if success{
            self.nowPlaying = movieList!
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }

        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.nowPlaying.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let movie = nowPlaying[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = movie.description

        return cell
    }



}
