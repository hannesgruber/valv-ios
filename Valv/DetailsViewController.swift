//
//  DetailsViewController.swift
//  Valv
//
//  Created by Hannes Gruber on 12/08/14.
//  Copyright (c) 2014 Hannes Gruber. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var ptitle: String!
    var style: String!
    var desc: String!
    var rating: String!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = ptitle
        styleLabel.text = style
        descriptionLabel.text = desc
        ratingLabel.text = rating
    }

}
