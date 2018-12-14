//
//  CollectionViewController.swift
//  NFCTagReader
//
//  Created by David Tran on 12/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var recipeNames: [String] = []
    let user = "robot"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getRecipes()
    }

    func getRecipes() {
        print("Getting Recipes")
        
        recipeNames = []
        
        Alamofire.request("https://stark-beach-45459.herokuapp.com/recipes?user_name="+user, method: .get).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                print(json)
                
                for (_, subJson):(String,JSON) in json {
                    for (key, value):(String,JSON) in subJson {
                        let val = "\(value)"
                        
                        if(key == "name") {
                             self.recipeNames.append(val)
                        }
                    }
                }
            }
            print(self.recipeNames)
            
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func add(_ sender: Any) {
        self.performSegue(withIdentifier: "add", sender: self)
    }
    
    @IBAction func unwindToRecipes(segue: UIStoryboardSegue) {
//        getRecipes()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    
    /* Pass data through Segue */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            if let destinationVC = segue.destination as? MessagesTableViewController {
                
                print("Trying to set recipe name")
                
                if let collectionView = self.collectionView,
                    let indexPath = collectionView.indexPathsForSelectedItems?.first,
                    let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell,
                    let recipeName = cell.label.text {
                    destinationVC.recipeName = recipeName
                    destinationVC.user = user
                    print("Set recipe name to : " + recipeName)
                }
            }
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return recipeNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        cell.label.text = recipeNames[indexPath.item]
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
