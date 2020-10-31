//
//  LogBookVC.swift
//  App_Pressure-Calculator
//
//  Created by Anastasia Kantor on 2020-10-30.
//

import UIKit

class LogBookVC: UIViewController {

    @IBOutlet weak var TimeField: UITextField!
    @IBOutlet weak var pressureField: UITextField!
    @IBOutlet weak var sampleField: UITextField!
    @IBOutlet weak var save: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get current date and time
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        print(dateFormatter.string(from: now))
        
        TimeField.text = String(dateFormatter.string(from: now))
        
        save.layer.cornerRadius = 10
        save.clipsToBounds = true
        
    }
}

/*class LogBookVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var oneRow: UITableViewCell!
    @IBOutlet weak var log: UITableView!
    
    var logBook = [String : [String, String]]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return logBook.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
     
        //cell?.textLabel?.text = logBook[(String, String)]()
     
     return cell!
    }
    
     /*
    @IBOutlet weak var theTextfield: UITextField!
    @IBOutlet weak var theTableview: UITableView!
   
    var favorites = [String]()
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        // Get current date and time
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        print(dateFormatter.string(from: now))
        

        /*
        if let theSavedText = defaults.string(forKey: "thetext") {
            theTextfield.text = theSavedText
        }
  
        
        if let theSavedFav = defaults.array(forKey: "fav") {
            favorites = theSavedFav as! [String]
        }
        
    }
    
    
    @IBAction func letsSave(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        //defaults.set(theTextfield.text, forKey: "thetext")
        
        favorites.append(theTextfield.text!)
        
        defaults.set(favorites, forKey: "fav")
        
        theTableview.reloadData()
        theTextfield.text = ""
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = favorites[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        favorites.remove(at: indexPath.row)
        
        let defaults = UserDefaults.standard
        defaults.set(favorites, forKey: "fav")
        
        theTableview.reloadData()
    }       */
  }
}
*/
