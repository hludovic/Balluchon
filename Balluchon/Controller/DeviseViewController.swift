//
//  DeviseViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class DeviseViewController: UIViewController {
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var resultatLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundConvert: UIView!
    
    @IBOutlet weak var loadingStackView: UIStackView!
    private var dollardRate: Double?
    
    private var mode: Mode? {
        didSet {
            refreshMode()
        }
    }
    
    enum Mode {
        case eurToDol, dolToEur
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mode = .dolToEur
        backgroundView.layer.cornerRadius = 10
        backgroundConvert.layer.cornerRadius = 10
        getCurrency()
    }

    @IBAction func pressSwitchButton(_ sender: UIButton) {
        if mode! == .dolToEur {
            mode = .eurToDol
        } else {
            mode = .dolToEur
        }
    }
    
    private func refreshMode() {
        if mode == .dolToEur {
            originLabel.text = "Dollards"
            destinationLabel.text = "Euros"
            textField.placeholder = "€"
        } else {
            originLabel.text = "Euros"
            destinationLabel.text = "Dollards"
            textField.placeholder = "$"
        }
    }
    
    private func refreshCurency(start: Bool) {
        if start {
            convertButton.isEnabled = false
            textField.isEnabled = false
            loadingStackView.isHidden = false
        } else {
            convertButton.isEnabled = true
            textField.isEnabled = true
            loadingStackView.isHidden = true
        }
    }
    
    private func getCurrency() {
        refreshCurency(start: true)
        CurrencyService.shared.getCurrency { (success, currency) -> (Void) in
            if success, let currency = currency {
                self.dollardRate = currency.rates.USD
                print(currency.rates.USD)
                self.refreshCurency(start: false)
            } else {
                print("ERROR FINAL")
            }
        }
    }
    
    private func convert() {
        guard let dollardRate = dollardRate else {
            print("Le taux n'a pas été téléchargé")
            return
        }
        
        guard let textFieldString = textField.text, textField.text != "" else {
            print("Textfield non présent")
            return
        }
        
        switch mode! {
        case .dolToEur:
            resultatLabel.text = "\(dollardRate * Double(textFieldString)!)"
        case .eurToDol:
            resultatLabel.text = "\(Double(textFieldString)! / dollardRate)"
        }
        
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
        
    @IBAction func convertButton(_ sender: UIButton) {
        convert()
    }    
    
}
