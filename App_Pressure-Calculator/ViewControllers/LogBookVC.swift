//
//  LogBookVC.swift
//  App_Pressure-Calculator
//
//  Created by Anastasia Kantor on 2020-10-30.
//

import UIKit

class LogBookVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private var logBook: LogBook?
    private var mainTBC: MainTabBarController?
    private var flatData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let temp = self.tabBarController as? MainTabBarController else {
                fatalError("Smth is wrong")
            }
        self.mainTBC = temp   // saving link to MainTabBarController
        self.logBook = mainTBC!.logBook  // saving link to logBook
            
        self.tableView.dataSource = self
        self.tableView.delegate = self
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            flatData.removeAll()
            for (key, value) in self.logBook!.data {
                value.forEach { element in
                    flatData.append("\(key) \(element.dateTime) \(element.pressure)")
                }
            }
            self.tableView.reloadData()
        }
}

extension LogBookVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
        cell.textLabel?.text = flatData[indexPath.row]
        return cell
    }

}
