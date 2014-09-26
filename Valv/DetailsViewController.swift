//
//  DetailsViewController.swift
//  Valv
//
//  Created by Hannes Gruber on 12/08/14.
//  Copyright (c) 2014 Hannes Gruber. All rights reserved.
//

import UIKit

protocol DetailsDelegate: class {
    func didRate()
}

class DetailsViewController: UIViewController {
    
    var product: Product!
    weak var delegate: DetailsDelegate?
    var doingRequest = false
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStar: UIImageView!
    
    // Rating Bar
    @IBOutlet weak var ratingBarDeleteButton: UIButton!
    @IBOutlet weak var ratingBarLabel: UILabel!
    @IBOutlet weak var ratingAcivityIndicator: UIActivityIndicatorView!
    
    
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
            ratingBarDeleteButton.hidden = false
        } else {
            ratingBarLabel.text = ""
            ratingBarDeleteButton.hidden = true
        }
        
        for i in 1...10 {
            var imageView = (self.view.viewWithTag(i) as UIImageView)
            let recognizer = UITapGestureRecognizer(target: self, action:"starClicked:")
            imageView.addGestureRecognizer(recognizer)
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action:"deleteClicked")
        ratingBarDeleteButton.addGestureRecognizer(recognizer)
        

    }
    
    func starClicked(sender: AnyObject) {
        if !LOGGED_IN {
            
            UIAlertView(title: "Not logged in", message: "You need to be logged in to be able to rate a product.", delegate: nil, cancelButtonTitle: "Ok").show()
            
        } else if !doingRequest {
            doingRequest = true
            if (sender is UITapGestureRecognizer ){
                if let i = (sender as UITapGestureRecognizer).view?.tag {
                    println("starClicked!!!\(i)")
                    fillRatingStars(i)
                    ratingManager.rate(product.uuid, rating: i, callback: ratingCallback)
                    ratingBarLabel.text = ""
                    ratingAcivityIndicator.startAnimating()
                }
            }
        }
    }
    
    
    func deleteClicked() {
        if !doingRequest {
            doingRequest = true
            ratingManager.rate(product.uuid, rating: 0, callback: ratingCallback)
            ratingBarLabel.text = ""
            fillRatingStars(0)
            ratingAcivityIndicator.startAnimating()
        }
    }

    
    func ratingCallback(success: Bool, rating: Int ) {
        println("ratingCallback success=\(success)")
        doingRequest = false
        ratingAcivityIndicator.stopAnimating()
        if (success) {
            product.userRating = String(rating)
            
            if rating == 0 {
                ratingBarDeleteButton.hidden = true
                ratingStar.image = UIImage(named: "rating_rec.png")
                ratingLabel.text = product.userProposedRating
            } else {
                ratingBarDeleteButton.hidden = false
                ratingBarLabel.text = product.userRating
                ratingStar.image = UIImage(named: "rating_user.png")
                ratingLabel.text = product.userRating
            }
            
            self.delegate?.didRate()
        } else {
            
            if !product.userRating.isEmpty {
                fillRatingStars(product.userRating.toInt()!)
                ratingBarDeleteButton.hidden = false
            } else {
                fillRatingStars(0)
            }
            
        }
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
