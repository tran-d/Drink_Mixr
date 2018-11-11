/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Message table view controller
 */

import UIKit
import CoreNFC

extension MessagesTableViewController {
    
    // MARK: - Table View Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
//                return detectedMessages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
//                let message = detectedMessages[indexPath.row].records[0].payload
//                cell.textLabel?.text = String(data: message, encoding: .utf8)
        cell.textLabel?.text = ingredients[indexPath.row]
        return cell
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        guard let indexPath = tableView.indexPathForSelectedRow,
    //            let payloadsTableViewController = segue.destination as? PayloadsTableViewController else {
    //            return
    //        }
    //        payloadsTableViewController.payloads = detectedMessages[indexPath.row].records
    //    }
    
}

