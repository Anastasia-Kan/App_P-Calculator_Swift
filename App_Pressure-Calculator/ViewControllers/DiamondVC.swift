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
    @IBOutlet weak var infoDia: UIButton!
    
    
    // MARK: — Variables and Constants
    var variation = "DiamondInside"
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        
        if (MeasuredPeak.text == "" || AmbientPressurePeak.text == "")
        {   if (variation == "DiamondAnvil")
            {   AmbientPressurePeak.text = "1334"
                MeasuredPeak.text = "1334"
            } else {
                MeasuredPeak.text = "1333"
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
        infoDia.layer.cornerRadius = 10
        infoDia.clipsToBounds = true
        resultP.layer.cornerRadius = 10
        resultP.clipsToBounds = true
        AmbientPressurePeak.layer.cornerRadius = 10
        AmbientPressurePeak.clipsToBounds = true
        MeasuredPeak.layer.cornerRadius = 10
        MeasuredPeak.clipsToBounds = true
        
        
        selectingVariation(variationRaman)

        if let variation = UserDefaults.standard.value(forKey: "selectedVariation")
        {
            let selectedIndex = variation as! Int
            variationRaman.selectedSegmentIndex = selectedIndex
        }
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector (doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        
        AmbientPressurePeak.inputAccessoryView = toolbar
        MeasuredPeak.inputAccessoryView = toolbar
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        /*let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)*/
    }
    
    @objc func doneClicked()
    {
        view.endEditing(true)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
      guard let tabBarController = tabBarController, let viewControllers = tabBarController.viewControllers else { return }
      let tabs = viewControllers.count
      if gesture.direction == .left {
          if (tabBarController.selectedIndex) < tabs {
              tabBarController.selectedIndex += 1
          }
      } else if gesture.direction == .right {
          if (tabBarController.selectedIndex) > 0 {
              tabBarController.selectedIndex -= 1
          }
      }
    }

    // MARK: - IBActions
    
    @IBAction func selectingVariation(_ sender: UISegmentedControl)
    {   UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "selectedVariation")
        
        if(variationRaman.selectedSegmentIndex == 0)
        {   let raman = UserDefaults.standard
            variation = "DiamondInside"
            AmbientPressurePeak.text = "1333"
            MeasuredPeak.text = "1333"
            NoteAnvil.isHidden = true
            NoteDiamond.isHidden = false
         }
         else if(variationRaman.selectedSegmentIndex == 1)
         {
            let raman = UserDefaults.standard
            variation = "DiamondAnvil"
            AmbientPressurePeak.text = "1334"
            MeasuredPeak.text = "1334"
            NoteAnvil.isHidden = false
            NoteDiamond.isHidden = true
         }
    }
    
    
    @IBAction func refPeakChanged(_ sender: Any) {
        calculatePressure((Any).self)
    }
    
    @IBAction func gotPeakChanged(_ sender: Any) {
        calculatePressure((Any).self)
    }
    

    @IBAction func calculatePressure(_ sender: Any) {

        // Checking that numbers entered
        
        var dia0 = Double(AmbientPressurePeak.text!.doubleValue)
        var dia = Double(MeasuredPeak.text!.doubleValue)
        
        // Checking that all the numbers are in allowed ranges
        if (1200...2500).contains(dia0)
        {   print("everything is ok")
        } else {
            resultP.text = "Check your values"
            return
        }
        if (1200...2500).contains(dia0)
        {
            print("everything is ok")
        } else {
            resultP.text = "Check your values"
            return
        }
        
        // Calculating Pressure
        if variation == "DiamondAnvil"
        {
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
        if variation == "DiamondInside"
        {
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


