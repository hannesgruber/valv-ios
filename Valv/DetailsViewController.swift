//
//  DetailsViewController.swift
//  Valv
//
//  Created by Hannes Gruber on 12/08/14.
//  Copyright (c) 2014 Hannes Gruber. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var product: Product!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStar: UIImageView!
    
    // Rating Bar
    @IBOutlet weak var ratingBarLabel: UILabel!
    
    
    @IBOutlet weak var rating1: UIImageView!
    @IBOutlet weak var rating2: UIImageView!
    @IBOutlet weak var rating3: UIImageView!
    @IBOutlet weak var rating4: UIImageView!
    @IBOutlet weak var rating5: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = product.title
        styleLabel.text = product.category
        descriptionLabel.text = product.desc
        
        var ratingText = product.ratingValue
        var starName = "rating_mean.png"
        if !product.userRating.isEmpty {
            ratingText = product.userRating
            starName = "rating_user.png"
        } else if !product.userProposedRating.isEmpty {
            ratingText = product.userProposedRating
            starName = "rating_rec.png"
        }

        ratingLabel.text = ratingText
        ratingStar.image = UIImage(named: starName)
        
        // Update Rating Bar
        if !product.userRating.isEmpty {
            ratingBarLabel.text = ratingText
            var ratingValue = ratingText.toInt()
            fillRatingStars(ratingValue!)
        } else {
            ratingBarLabel.text = ""
        }

    }
    
    @IBAction func ratingStarClicked(sender: UITapGestureRecognizer) {
        var starNumber = sender.view?.tag
        println("CLICK!!!\(starNumber)")
        fillRatingStars(starNumber!)
        ratingManager.rate(product.uuid, rating: starNumber!, callback: ratingCallback)
        
    }
    
    func ratingCallback(success: Bool) {
        println("ratingCallback success=\(success)")
    }
    
    func fillRatingStars(numberOfStars: Int) {
        for i in 1...10 {
            if i <= numberOfStars {
                (self.view.viewWithTag(i) as UIImageView).image = UIImage(named: "rating_user.png")
            } else {
                (self.view.viewWithTag(i) as UIImageView).image = UIImage(named: "rating_mean.png")
            }
        }
    }

}
