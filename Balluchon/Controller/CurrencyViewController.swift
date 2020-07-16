//
//  DeviseViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController, CurrencyDisplayDelegate {
    func displayActivity(_ activity: Bool) {
        if activity {
            convertButton.isEnabled = false
            textField.isEnabled = false
            loadingStackView.isHidden = false
        } else {
            convertButton.isEnabled = true
            textField.isEnabled = true
            loadingStackView.isHidden = true
        }
    }
    
    
    let currencyViewModel = CurrencyController()
    
    func displayResult(_ text: String) {
        resultatLabel.text = text
    }
    
    func displayError(_ text: String) {
        //
    }
    
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var resultatLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundConvert: UIView!
    @IBOutlet weak var loadingStackView: UIStackView!
    
    private var mode: CurrencyMode? {
        didSet {
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyViewModel.displayDelegate = self
        mode = .dolToEur
        backgroundView.layer.cornerRadius = 10
        backgroundConvert.layer.cornerRadius = 10
        currencyViewModel.fechingData()
    }
    
    @IBAction func pressSwitchButton(_ sender: UIButton) {
        if mode! == .dolToEur {
            mode = .eurToDol
        } else {
            mode = .dolToEur
        }
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
        
    @IBAction func convertButton(_ sender: UIButton) {
        currencyViewModel.convertValue(mode: mode!, value: textField.text!)
    }    
    
}
