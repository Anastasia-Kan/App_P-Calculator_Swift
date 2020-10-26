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
    
    
    
    // Add variables and constants
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        refRuby.delegate = self
        refTemp.delegate = self
        gotRuby.delegate = self
        gotTemp.delegate = self
    
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
    
    @IBAction func calculateP(_ sender: Any) {
        calcP.resignFirstResponder()
        
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
        }
        if (280...310).contains(RT) {
                print("everything is ok")
            } else {print("something is wrong")
                resultP.text = "Check your values"
            }
        if (690...800).contains(lambda) {
                print("everything is ok")
        } else {print("something is wrong")
            resultP.text = "Check your values"
        }
        if (280...5000).contains(T) {
                    print("everything is ok")
                } else {print("something is wrong")
                    resultP.text = "Check your values"
                }
        
        // Beginning equation preparation: extra parameters
        resultP.text = ""
        var deltaRT: Double = RT - 296
        var deltaT: Double = T - 296
        // Making T-corrections for the measured ruby to get lambda at 296K
        if (T <= 50) {
            var deltaLambda = -0.887
        }
        if (50...296).contains(T){
            var deltaLambda = (0.00664 * deltaT)        }
        var A: Double
        A = RT + lambda0
        print(A)
        //resultP.text = String["\(A)"]
        
    }
        /*// Starting working on formula to calculate Pressure: resultP.text =

        var A = 0.0
        var B = 0.0
      
        //resultP.text = referenceRuby + measuredRuby + referenceTemp + measuredTemp
        
        //var P = 0
        if lambda != nil && lambda0 != nil && RT != nil && T != nil {
            let X: Double = lambda!/lambda0!
            let Y: Double = (lambda! - lambda0!) / lambda0!
            let mao1 = A / B
            let mao2 = pow(X, B)
            let mao3 = mao1 * mao2
            let shen1 = A * Y
            let shen2 = B / Y
            let shen3 = 1 + shen2
            
        
        
        
        if selectedButton.titleLabel?.text == "Mao (1986) hydrostatic"
         {
              var A = 1904
              var B = 7.665
            var P: Double = mao3 - mao1
            print ("\(P)")
            resultP.text = "\(P)"
          }
        if selectedButton.titleLabel?.text == "Mao (1986) non-hydrostatic"
        {
             var A = 1904
             var B = 5
            var P: Double = mao3 - mao1
            print ("\(P)")
            resultP.text = "\(P)"
         }
        if selectedButton.titleLabel?.text == "Shen (2020)"
        {
            var A = 1870
            var B = 5.63
            var P: Double = shen1 * shen3
            print ("\(P)")
            resultP.text = "\(P)"
         }
        
        }
        
            //var P: Double
        //var P = A + B
        
        // print "\(P)"
       // resultP.text = "\(P)"
        
        
      //  P =
        /*
reftemp=eval(ruby.reftemp.value)
temp=eval(ruby.temp.value)
lam0=eval(ruby.lambda0.value)
lam=eval(ruby.lambda.value)
deltaT = temp-296
deltaTref = reftemp-296 */
            
            
            
            
            
        
        }*/
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

