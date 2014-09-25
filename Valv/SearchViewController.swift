//
//  ViewController.swift
//  Valv
//
//  Created by Hannes Gruber on 11/08/14.
//  Copyright (c) 2014 Hannes Gruber. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet var searchResultsTableView : UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchManager.searchResults.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as SearchResultCell
        
        var product = searchManager.searchResults[indexPath.row]
        cell.title.text = product.title
        cell.category.text = product.category
        
        var ratingText = product.ratingValue
        var starName = "rating_mean.png"
        if !product.userRating.isEmpty {
            ratingText = product.userRating
            starName = "rating_user.png"
        } else if !product.userProposedRating.isEmpty {
            ratingText = product.userProposedRating
            starName = "rating_rec.png"
        }
        
        cell.rating.text = ratingText
        cell.star.image = UIImage(named: starName)
        
        return cell
    }
    
    func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat
    {
        return 51
    }

    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        searchManager.clearSearchResults()
        searchResultsTableView.reloadData() // to empty the list
        searchManager.search(searchBar.text, callback)
    }
    
    func callback() {
        // need to do this on main thread...
        dispatch_async(dispatch_get_main_queue()) {
            self.searchResultsTableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        
        if segue.identifier == "detailsSegue" {
            let index: NSIndexPath = searchResultsTableView.indexPathForSelectedRow()!
            let product = searchManager.searchResults[index.row]
            let vc = segue.destinationViewController as DetailsViewController
            vc.product = product
            // deselect so that row isnt selected when returning from details view
            searchResultsTableView.deselectRowAtIndexPath(index, animated: true)
        }
    }


}

