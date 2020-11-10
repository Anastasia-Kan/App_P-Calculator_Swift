//
//  DiaRamanVC.swift
//  App_Pressure-Calculator
//
//  Created by Anastasia Kantor on 2020-10-15.
//

import UIKit

class DiamondVC: UIViewController, UITextFieldDelegate {

    // MARK: — Outlets
    @IBOutlet weak var AmbientPressurePeak: UITextField!
    @IBOutlet weak var MeasuredPeak: UITextField!
    @IBOutlet weak var resultP: UITextField!
    @IBOutlet weak var calcP: UIButton!
  
    @IBOutlet var NoteAnvil: UITextView!
    @IBOutlet var NoteDiamond: UITextView!
    
    @IBOutlet weak var variationRaman: UISegmentedControl!
    
    // MARK: — Variables and Constants
    var variation = "DiamondInside"
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        
        if (MeasuredPeak.text == "") {
            MeasuredPeak.text = "1333"
        if (AmbientPressurePeak.text == "") {
                AmbientPressurePeak.text = "1333"
            }
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmbientPressurePeak.delegate = self
        MeasuredPeak.delegate = self
        resultP.delegate = self
        
        calcP.layer.cornerRadius = 10
        calcP.clipsToBounds = true
        NoteAnvil.layer.cornerRadius = 10
        NoteAnvil.clipsToBounds = true
        NoteDiamond.layer.cornerRadius = 10
        NoteDiamond.clipsToBounds = true
        
        //NoteAnvil.isHidden = true
        //NoteDiamond.isHidden = true
        
        if let variation = UserDefaults.standard.value(forKey: "selectedVariation"){
            let selectedIndex = variation as! Int
            variationRaman.selectedSegmentIndex = selectedIndex
            }
        
        }
    
    // MARK: - IBActions
    
    @IBAction func selectingVariation(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "selectedVariation")
        
        if(variationRaman.selectedSegmentIndex == 0)
        { let raman = UserDefaults.standard
           variation = "DiamondInside"
           //NoteAnvil.isHidden = true
           //NoteDiamond.isHidden = false
          print(variation)
         }
         else if(variationRaman.selectedSegmentIndex == 1)
         {
            let raman = UserDefaults.standard
            variation = "DiamondAnvil"
            AmbientPressurePeak.text = "1334"
            MeasuredPeak.text = "1334"
            //NoteAnvil.isHidden = false
            //NoteDiamond.isHidden = true
            print(variation)
         }
   }
    
    

    
    
    @IBAction func calculatePressure(_ sender: Any) {
        view.endEditing(true)

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
        if variation == "DiamondAnvil" {
        let diK = 547.0
        let diKp = 3.75
        
        let rat1 = (dia - dia0) / dia0
        let part1 = diK * rat1
        let part2 = 0.5 * (diKp - 1)
        let part3 = 1 + (part2 * rat1)
        let pressure = part1 * part3
        let P = ((pressure * 100).rounded()) / 100
        resultP.text = String(P)

     }
        if variation == "DiamondInside" {
            let a = -0.00275
            let b = 2.61
            let c = dia0 - dia
            let D = (b * b) - (4 * a * c)
            let routD = pow(D, 0.5)
            let pressure = (-b + routD) / (2 * a)
            let P = ((pressure * 100).rounded()) / 100
            resultP.text = String(P)
        }


    }
}
