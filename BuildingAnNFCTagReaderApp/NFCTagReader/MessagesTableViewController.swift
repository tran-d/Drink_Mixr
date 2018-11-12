/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The view controller that scans and displays NDEF messages.
 */

import UIKit
import CoreNFC
import SwiftyJSON
import Alamofire

//struct cellData {
//    let cellID: Int!
//    let text : String!
//    let value : Double!
//}

/// - Tag: MessagesTableViewController
class MessagesTableViewController: UITableViewController, NFCNDEFReaderSessionDelegate {
    
    // MARK: - Properties
    
    let reuseIdentifier = "reuseIdentifier"
    var detectedMessages = [NFCNDEFMessage]()
    var session: NFCNDEFReaderSession?
    var ingredients = [String]()
    var volumes = [String]()
    var user = "robot"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("https://stark-beach-45459.herokuapp.com/ingredients", method: .get).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                print(json)
                
                for (key,_):(String, JSON) in json {
                    if key != "_id" {
                        print(key)
                        self.ingredients.append(key)
                        self.volumes.append("0.0")
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    /// - Tag: beginScanning
    @IBAction func beginScanning(_ sender: Any) {
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold your iPhone near the item to learn more about it."
        session?.begin()
    }
    
    // MARK: - NFCNDEFReaderSessionDelegate
    
    /// - Tag: processingTagData
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            // Process detected NFCNDEFMessage objects.
            self.detectedMessages.append(contentsOf: messages)
            
            if let text = String(data: messages[0].records[0].payload, encoding: .utf8) {
                print(text)
                if (text == "\u{02}endrink_mixr"){
                    self.POST_Order()
                }
                
            } else {
                print("Invalid data")
            }
        }
    }
    
    /// - Tag: endScanning
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // Check the invalidation reason from the returned error.
        if let readerError = error as? NFCReaderError {
            // Show an alert when the invalidation reason is not because of a success read
            // during a single tag read mode, or user canceled a multi-tag read mode session
            // from the UI or programmatically using the invalidate method call.
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "Session Invalidated",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        // A new session instance is required to read new tags.
        self.session = nil
    }
    
    // MARK: - addMessage(fromUserActivity:)
    
    func addMessage(fromUserActivity message: NFCNDEFMessage) {
        DispatchQueue.main.async {
            self.detectedMessages.append(message)
            //            self.tableView.reloadData()
            
            print("NFC tag detected")
            self.POST_Order()
        }
    }
    
    
    // POSTs an order by reading text fields and making a HTTPS POST Request
    func POST_Order() {
        
        // reads ingredient and volume values and update array
        let cells = self.tableView.visibleCells as! Array<CustomRecipeTableViewCell>
        
        for cell in cells {
            let index = self.tableView.indexPath(for: cell)!.row
                ingredients[index] = cell.ingredient_label.text!
                volumes[index] = cell.volume_value.text!
        }
        
        var order = [String:Double]()
        for (ingredient, volume) in zip(ingredients, volumes) {
            order[ingredient] = (volume as NSString).doubleValue
            print("\(ingredient): \((volume as NSString).doubleValue)")
        }
        
        let parameters: Parameters = [
        "user_name": user,
        "order": order
        ]
        
        Alamofire.request("https://stark-beach-45459.herokuapp.com/order", method: .post, parameters: parameters,  encoding: JSONEncoding.default)
    }
    @IBAction func test(_ sender: Any) {
        self.POST_Order()
    }
}

