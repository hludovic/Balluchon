//
//  DeviseViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class DeviseViewController: UIViewController {
    
    @IBOutlet weak var eurosDollardsLabel: UILabel!
    @IBOutlet weak var resultatLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    
    @IBOutlet weak var loadingStackView: UIStackView!
    private var dollardRate: Double?
    
    private var switchWallue: convertTo = .dollard {
        didSet {
            refreshTitleLabel()
        }
    }
    
    enum convertTo {
        case euro, dollard
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTitleLabel()
        getCurrency()
    }

    @IBAction func pressSwitchButton(_ sender: UIButton) {
        if switchWallue == .dollard {
            switchWallue = .euro
        } else {
            switchWallue = .dollard
        }
    }
    
    private func refreshTitleLabel() {
        if switchWallue == .dollard {
            eurosDollardsLabel.text = "Conversion Euros vers Dollards"
            textField.placeholder = "€"
        } else {
            eurosDollardsLabel.text = "Conversion Dollard vers Euros"
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
        
        
        
        switch switchWallue {
        case .dollard:
            resultatLabel.text = "\(dollardRate * Double(textFieldString)!)"
        case .euro:
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
