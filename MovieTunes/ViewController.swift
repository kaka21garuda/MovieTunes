//
//  ViewController.swift
//  MovieTunes
//
//  Created by Buka Cakrawala on 5/1/17.
//  Copyright © 2017 Buka Cakrawala. All rights reserved.
//

import UIKit
import Alamofire

protocol TransferMovieDataDelegate {
    
    func sendMovieData() -> Movie
    
}

class ViewController: UITableViewController, TransferMovieDataDelegate {
    
    var movies = [Movie]()
    
    var links = NSArray()
    
    var images: NSArray!
    var imageAttribute: [String: AnyObject]!
    var imageAttributeForLargerResolution: [String: AnyObject]!
    
    var dateAttribute: [String: AnyObject]!
    
    var chosenMovie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // MARK: - Networking Request
        getAllMovies()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendMovieData() -> Movie {
        return chosenMovie
    }
    
    func getAllMovies() {
        Alamofire.request("https://itunes.apple.com/us/rss/topmovies/limit=25/json").responseJSON { (response) in
            if let json = response.result.value as? [String: AnyObject] {
                let feed: [String: AnyObject] = json["feed"] as! [String: AnyObject]
                let entries = feed["entry"] as! NSArray
                
                for (index, entry) in entries.enumerated() {
                    
                    let movie = Movie()
                    
                    let dict = entry as! [String: AnyObject]
                    
                    if let link = dict["id"]?["label"] {
                        movie.itunesURL = link as! String
                    }
                    
                    if let title = dict["im:name"]?["label"] {
                        movie.title = title as! String
                    } else {
                        movie.title = "No Available"
                    }
                    
                    if let price = dict["im:price"]?["label"] {
                        movie.price = price as! String
                    } else {
                        movie.price = "$0.00"
                    }
                    
                    self.dateAttribute = dict["im:releaseDate"]?["attributes"] as! [String: AnyObject]
                    movie.releasedDate = self.dateAttribute["label"] as! String
                    
                    
                    self.images = dict["im:image"] as! NSArray
                    self.imageAttributeForLargerResolution = self.images[2] as! [String: AnyObject]
                    self.imageAttribute = self.images[0] as! [String: AnyObject]
                    
                    if let imageURL = self.imageAttribute["label"] {
                        movie.coverImageURL = imageURL as! String
                    }
                    
                    if let largerImageURL = self.imageAttributeForLargerResolution["label"] {
                        movie.largerCoverImageURL = largerImageURL as! String
                    }
                    
                    self.movies.append(movie)
                    
                    self.tableView.reloadData()
                    
                }
            }
            
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let detailViewController: DetailViewController = segue.destination as! DetailViewController
            detailViewController.movieDelegate = self
        }
    }
    
    
}

// MARK: TableView Data Source
extension ViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: MovieTableViewCell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        tableViewCell.titleLabel.text = movies[indexPath.row].title
        tableViewCell.priceLabel.text = movies[indexPath.row].price
        tableViewCell.dateLabel.text = movies[indexPath.row].releasedDate
        tableViewCell.movieImageView.downloadedFrom(link: movies[indexPath.row].coverImageURL)
    
        return tableViewCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenMovie = movies[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
}

