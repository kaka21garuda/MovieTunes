//
//  DetailViewController.swift
//  MovieTunes
//
//  Created by Buka Cakrawala on 5/1/17.
//  Copyright © 2017 Buka Cakrawala. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    
    var movieDelegate: TransferMovieDataDelegate!

    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    

    @IBAction func previewMovieAction(_ sender: UIButton) {
        
        UIApplication.shared.open(URL(string: movieDelegate.sendMovieData().itunesURL)!, options: [:], completionHandler: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = movieDelegate.sendMovieData().title
        releaseDateLabel.text = movieDelegate.sendMovieData().releasedDate
        priceLabel.text = movieDelegate.sendMovieData().price
        posterImageView.downloadedFrom(link: movieDelegate.sendMovieData().largerCoverImageURL)
        
        
    }
    
    


}
