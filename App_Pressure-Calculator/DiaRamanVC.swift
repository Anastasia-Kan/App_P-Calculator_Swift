//
//  DiaRamanVC.swift
//  App_Pressure-Calculator
//
//  Created by Anastasia Kantor on 2020-10-15.
//

import UIKit

class DiaRamanVC: UIViewController {

   
    @IBOutlet weak var AmbientPressurePeak: UITextField!
    @IBOutlet weak var MeasuredPeak: UITextField!
    @IBOutlet weak var resultP: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func calculatePressure(_ sender: Any) {
    }
    

}
