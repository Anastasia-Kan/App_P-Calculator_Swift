//
//  RubyVC.swift
//  App_Pressure-Calculator
//
//  Created by Anastasia Kantor on 2020-10-15.
//

import UIKit

class RubyVC: UIViewController {
    // MARK: — Outlets
    @IBOutlet weak var refRuby: UITextField!
    @IBOutlet weak var refTemp: UITextField!
    @IBOutlet weak var gotRuby: UITextField!
    @IBOutlet weak var gotTemp: UITextField!
    @IBOutlet weak var calcP: UIButton!
    @IBOutlet weak var resultP: UITextField!
    @IBOutlet weak var calibrationSegments: UISegmentedControl!
    @IBOutlet weak var refTempScale: UISegmentedControl!
    @IBOutlet weak var gotTempScale: UISegmentedControl!
    @IBOutlet weak var infoRuby: UIButton!
    

    // MARK: — Variables and Constants
    var selectedCalibration = ""
    var refTScale = ""
    var gotTScale = ""
    
    var Pressure = 0.0
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        refRuby.delegate = self
        refTemp.delegate = self
        gotRuby.delegate = self
        gotTemp.delegate = self
        
        calcP.layer.cornerRadius = 10
        calcP.clipsToBounds = true
        
        infoRuby.layer.cornerRadius = 10
        infoRuby.clipsToBounds = true


        if let selectedCalibration = UserDefaults.standard.value(forKey: "selectedCalibration")
        {
            let calibration = selectedCalibration as! Int
            calibrationSegments.selectedSegmentIndex = calibration
        }
         
        if let refTempSelectedScale = UserDefaults.standard.value(forKey: "refTempSelectedScale")
        {
            let refTScale = refTempSelectedScale as! Int
            refTempScale.selectedSegmentIndex = refTScale
        }
         
        if let gotTempSelectedScale = UserDefaults.standard.value(forKey: "gotTempSelectedScale")
        {
            let gotTScale = gotTempSelectedScale as! Int
            gotTempScale.selectedSegmentIndex = gotTScale
        }
         selectingCalibration(calibrationSegments)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector (doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        refRuby.inputAccessoryView = toolbar
        gotRuby.inputAccessoryView = toolbar
        refTemp.inputAccessoryView = toolbar
        gotTemp.inputAccessoryView = toolbar
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
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
   
    
    // CHANGING text in TextField -> Calculate Pressure while entering data
    @IBAction func gotTempChanged(_ sender: Any) {
        calculateP((Any).self)
    }
        
    @IBAction func gotRubyChanged(_ sender: Any) {
        calculateP((Any).self)
    }
        
    @IBAction func refTempChanged(_ sender: Any) {
        calculateP((Any).self)
    }
    

    // Input info: Excluding all caracters except for decimal NUMBERS
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let invalidCaracters = CharacterSet(charactersIn: "0123456789.,-").inverted
        return (string.rangeOfCharacter(from: invalidCaracters) == nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
           
        if (refRuby.text == "") {
                refRuby.text = "694.22"
        }
        if (gotRuby.text == "") {
                gotRuby.text = "694.22"
        }
        if (refTemp.text == "")
        {
            if (refTScale == "K")
            {
                refTemp.text = "298"
            }
            if (refTScale == "C")
            {
                refTemp.text = "25"
            }
        }
        if (gotTemp.text == "")
        {
            if (gotTScale == "K")
            {
                gotTemp.text = "298"
            }
            if (gotTScale == "C")
            {
                gotTemp.text = "25"
            }
        }
    }
            
        
        
    // MARK: — Equations
    func Mao(A : Double, B : Double, lambda : Double, lambda0 : Double) -> Double
    {   let m1 = A / B
        let m2 = lambda / lambda0
        let m3 = pow(m2, B)
        let m4 = m1 * m3
        Pressure = m4 - m1
        return Pressure
    }

    func Shen(A : Double, B : Double, lambda : Double, lambda0 : Double) -> Double
    {   let deltaLambda = lambda - lambda0
        let sh1 = deltaLambda / lambda0
        let sh2 = A * sh1
        let sh3 = B * sh1
        let sh4 = 1 + sh3
        Pressure = sh2 * sh4
        return Pressure
    }
    
    // MARK: - IBActions
    
    @IBAction func selectingCalibration(_ sender: UISegmentedControl)
    {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "selectedCalibration")

        if(calibrationSegments.selectedSegmentIndex == 0)
        {
            let segmentControl = UserDefaults.standard
            selectedCalibration = "Mao-hydro"
        }
        else if(calibrationSegments.selectedSegmentIndex == 1)
        {   let segmentControl = UserDefaults.standard
            selectedCalibration = "Mao-non-hydro"
        }
        else if(calibrationSegments.selectedSegmentIndex == 2)
        {   let segmentControl = UserDefaults.standard
            selectedCalibration = "Shen"
        }
    }
    
    
    @IBAction func selectingRefTempScale(_ sender: UISegmentedControl)
    {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "refTempSelectedScale")
          
        if(refTempScale.selectedSegmentIndex == 0)
        {   let refT = UserDefaults.standard
            refTScale = "C"
        }
        else if(refTempScale.selectedSegmentIndex == 1)
        {   let refT = UserDefaults.standard
            refTScale = "K"
        }
    }
    
    
    @IBAction func selectingGotTempScale(_ sender: UISegmentedControl)
    {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "gotTempSelectedScale")

        if(gotTempScale.selectedSegmentIndex == 0)
        {   let gotT = UserDefaults.standard
            gotTScale = "C"
        }
        else if(refTempScale.selectedSegmentIndex == 1)
        {   let gotT = UserDefaults.standard
            gotTScale = "K"
        }
    }
    
    @IBAction func calculateP(_ sender: Any)
    {

        let lambda0 = Double(refRuby.text!.doubleValue)
        var RT = Double(refTemp.text!.doubleValue)
        let lambda = Double(gotRuby.text!.doubleValue)
        var T = Double(gotTemp.text!.doubleValue)

        if (gotTScale == "C")
        {
            T += 273
        }
        if (refTScale == "C")
        {
            RT += 273
        }
            
    // Checking that all the numbers are in allowed ranges
        if (690...800).contains(lambda0)
        {
            print("everything is ok")
        } else {
            resultP.text = "Check your values"
            return
        }
        if (10...310).contains(RT)
        {
            print("everything is ok")
        } else {
            resultP.text = "Check your values"
            return
        }
        if (690...1500).contains(lambda)
        {
            print("everything is ok")
        } else {
            resultP.text = "Check your values"
            return
        }
            
            // Making T-corrections for lambda and lambda0
            
        let deltaT = T - 296
        let deltaTsqr = deltaT * deltaT
        let deltaTcub = deltaT * deltaT * deltaT
        let deltaRT = RT - 296
        let deltaRTsqr = deltaRT * deltaRT
        let deltaRTcub = deltaRT * deltaRT * deltaRT
        var corrLambda = -0.887
        var corrLambda0 = -0.887
            
            
        if (50...296).contains(RT)
        {
            corrLambda0 = (0.00664 * deltaRT) + (6.76e-6 * deltaRTsqr) - (2.33e-8 * deltaRTcub)
        }
        if (RT >= 296)
        {
            corrLambda0 = (0.00746 * deltaRT) - (3.01e-6 * deltaRTsqr) + (8.76e-9 * deltaRTcub)
        }
        
        let lam0 = lambda0 - corrLambda0
        
        if (50...296).contains(T)
        {
            corrLambda = (0.00664 * deltaT) + (6.76e-6 * deltaTsqr) - (2.33e-8 * deltaTcub)
        }
        if (T >= 296)
        {
            corrLambda = (0.00746 * deltaT) - (3.01e-6 * deltaTsqr) + (8.76e-9 * deltaTcub)
        }
        
        let lam = lambda - corrLambda
            
            // Calculating pressure according to chosen equation with T-corrections
            
        if selectedCalibration == "Mao-hydro"
        {
            Mao(A: 1904, B: 7.665, lambda: lam, lambda0: lam0)
        }
        if selectedCalibration == "Mao-non-hydro"
        {
            Mao(A: 1904, B: 5, lambda: lam, lambda0: lam0)
        }
        if selectedCalibration == "Shen"
        {
            Shen(A: 1870, B: 5.63, lambda: lam, lambda0: lam0)
        }
     
        let P = ((Pressure * 100).rounded()) / 100
        resultP.text = String(P)
    }
}

// Add TextField Delegates
extension RubyVC : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

extension String
{
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double
    {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self)
        {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self)
            {
                return result.doubleValue
            }
        }
        return 0
    }
}
