//
//  RubyVC.swift
//  App_Pressure-Calculator
//
//  Created by Anastasia Kantor on 2020-10-15.
//

import UIKit

class CellClass: UITableViewCell {
    }

class RubyVC: UIViewController {
    // Presenting all the TextFields and Buttons
    @IBOutlet weak var refRuby: UITextField!
    @IBOutlet weak var refTemp: UITextField!
    @IBOutlet weak var gotRuby: UITextField!
    @IBOutlet weak var gotTemp: UITextField!
    @IBOutlet weak var calcP: UIButton!
    @IBOutlet weak var resultP: UITextField!
    @IBOutlet weak var CalibrationBTN: UIButton!
    @IBOutlet weak var saveToLogBook: UIButton!
    
    
    // Add variables and constants
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    var Pressure = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        refRuby.delegate = self
        refTemp.delegate = self
        gotRuby.delegate = self
        gotTemp.delegate = self
        
        CalibrationBTN.layer.cornerRadius = 10
        CalibrationBTN.clipsToBounds = true
        calcP.layer.cornerRadius = 10
        calcP.clipsToBounds = true
        saveToLogBook.layer.cornerRadius = 10
        saveToLogBook.clipsToBounds = true
    }
    
    // Excluding all caracters except for decimal NUMBERS
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let invalidCaracters = CharacterSet(charactersIn: "0123456789.").inverted
        
        return (string.rangeOfCharacter(from: invalidCaracters) == nil)
    }
    
    // Selecting calibration: Nice Drop-down menu
    func addTransparentView(frames: CGRect) {
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            
            let tableviewheight = CGFloat(self.dataSource.count * 50)
            
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: tableviewheight)
        }, completion: nil)
    }
    
    // Selecting calibration (cont): nice exit of selection
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    // Selecting calibration (cont): Making a choise
    @IBAction func SelectCalibration(_ sender: Any) {
        dataSource = ["Mao (1986) hydrostatic", "Mao (1986) non-hydrostatic", "Shen (2020)"]
        selectedButton = CalibrationBTN
        addTransparentView(frames: CalibrationBTN.frame)
    }
    
    // To dismiss Keybord
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        refRuby.resignFirstResponder()
        gotRuby.resignFirstResponder()
        refTemp.resignFirstResponder()
        gotTemp.resignFirstResponder()
        calcP.resignFirstResponder()
    }
    // Mao's equation:
    func Mao(A : Double, B : Double, lambda : Double, lambda0 : Double) -> Double
    {   let m1 = A / B
        let m2 = lambda / lambda0
        let m3 = pow(m2, B)
        let m4 = m1 * m3
        Pressure = m4 - m1
        return Pressure
    }
    // Shen's equation
    func Shen(A : Double, B : Double, lambda : Double, lambda0 : Double) -> Double
    {   let deltaLambda = lambda - lambda0
        let sh1 = deltaLambda / lambda0
        let sh2 = A * sh1
        let sh3 = B * sh1
        let sh4 = 1 + sh3
        Pressure = sh2 * sh4
        return Pressure
    }
 
    @IBAction func calculateP(_ sender: Any) {
        
        refRuby.resignFirstResponder()
        gotRuby.resignFirstResponder()
        refTemp.resignFirstResponder()
        gotTemp.resignFirstResponder()
        calcP.resignFirstResponder()
        
        
        // Checking that calibration selected - doesn't work!!!
        if selectedButton.titleLabel?.text == "" {
            resultP.text = "Choose calibration"
            return
        }
        // Checking that numbers entered
        guard let lambda0 = Double(refRuby.text!) else {
            resultP.text = "Some value is missing"
            return}
        guard let RT = Double(refTemp.text!) else {
            resultP.text = "Some value is missing"
            return}
        guard let lambda = Double(gotRuby.text!) else {
            resultP.text = "Some value is missing"
            return}
        guard let T = Double(gotTemp.text!) else {
            resultP.text = "Some value is missing"
            return}
        
        // Checking that all the numbers are in allowed ranges
        if (690...800).contains(lambda0) {
            print("everything is ok")
        } else {print("something is wrong")
                resultP.text = "Check your values"
                return
        }
        if (280...310).contains(RT) {
                print("everything is ok")
            } else {print("something is wrong")
                    resultP.text = "Check your values"
                    return
            }
        if (690...1500).contains(lambda) {
                print("everything is ok")
        } else {print("something is wrong")
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
        
        if (50...296).contains(RT){
            corrLambda0 = (0.00664 * deltaRT) + (6.76e-6 * deltaRTsqr) - (2.33e-8 * deltaRTcub)
        }
        if (RT >= 296) {
            corrLambda0 = (0.00746 * deltaRT) - (3.01e-6 * deltaRTsqr) + (8.76e-9 * deltaRTcub)
        }
        
        let lam0 = lambda0 - corrLambda0
        
        if (50...296).contains(T){
            corrLambda = (0.00664 * deltaT) + (6.76e-6 * deltaTsqr) - (2.33e-8 * deltaTcub)
        }
        if (T >= 296) {
            corrLambda = (0.00746 * deltaT) - (3.01e-6 * deltaTsqr) + (8.76e-9 * deltaTcub)
        }
        
        let lam = lambda - corrLambda

        // Calculating pressure according to chosen equation with T-corrections
        if selectedButton.titleLabel?.text == "Mao (1986) hydrostatic" {
            Mao(A: 1904, B: 7.665, lambda: lam, lambda0: lam0)
        }
        if selectedButton.titleLabel?.text == "Mao (1986) non-hydrostatic" {
            Mao(A: 1904, B: 5, lambda: lam, lambda0: lam0)
        }
        if selectedButton.titleLabel?.text == "Shen (2020)" {
            Shen(A: 1870, B: 5.63, lambda: lam, lambda0: lam0)
        }
        
        print(Pressure)
        let P = ((Pressure * 100).rounded()) / 100
        resultP.text = String(P)
        }
    
/*
    @IBAction func save(_ sender: Any) {
    }
 */
    
    
 }

// Selecting calibration (cont)
extension RubyVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}

// Add TextField Delegates
extension RubyVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

