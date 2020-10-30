//
//  DiaRamanVC.swift
//  App_Pressure-Calculator
//
//  Created by Anastasia Kantor on 2020-10-15.
//

import UIKit

class DiaAnvilRamanVC: UIViewController, UITextFieldDelegate {

   
    @IBOutlet weak var AmbientPressurePeak: UITextField!
    @IBOutlet weak var MeasuredPeak: UITextField!
    @IBOutlet weak var resultP: UITextField!
    @IBOutlet weak var calcP: UIButton!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        AmbientPressurePeak.resignFirstResponder()
        MeasuredPeak.resignFirstResponder()
        resultP.resignFirstResponder()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmbientPressurePeak.delegate = self
        MeasuredPeak.delegate = self
        resultP.delegate = self
        
        calcP.layer.cornerRadius = 12
        calcP.clipsToBounds = true
    
        }
    
    @IBAction func calculatePressure(_ sender: Any) {
        
        // Checking that numbers entered
        guard let dia0 = Double(AmbientPressurePeak.text!) else {
            resultP.text = "Some value is missing"
            return}
        guard let dia = Double(MeasuredPeak.text!) else {
            resultP.text = "Some value is missing"
            return}
        
        
        // Checking that all the numbers are in allowed ranges
        if (1200...2500).contains(dia0) {
            print("everything is ok")
        } else {print("something is wrong")
                resultP.text = "Check your values"
                return
        }
        if (1200...2500).contains(dia0) {
                print("everything is ok")
            } else {print("something is wrong")
                    resultP.text = "Check your values"
                    return
            }
        
        // Calculating Pressure
        let diK = 547.0
        let diKp = 3.75
        
        let rat1 = (dia - dia0) / dia0
        let part1 = diK * rat1
        let part2 = 0.5 * (diKp - 1)
        let part3 = 1 + (part2 * rat1)
        let pressure = part1 * part3
        
        print(pressure)
        let P = ((pressure * 100).rounded()) / 100
        resultP.text = String(P)
     }
}
