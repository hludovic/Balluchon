//
//  DeviseViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController, CurrencyDisplayDelegate {
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var resultatLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundConvert: UIView!
    @IBOutlet weak var loadingStackView: UIStackView!

    let currencyController = CurrencyController()
    
    func displayResult(_ text: String) {
        resultatLabel.text = text
    }
    
    func displayError(_ text: String) {
        displayAlert(message: text)
    }

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
        
        currencyController.displayDelegate = self
        mode = .dolToEur
        backgroundView.layer.cornerRadius = 10
        backgroundConvert.layer.cornerRadius = 10
        backgroundConvert.layer.shadowColor = UIColor.black.cgColor
        backgroundConvert.layer.shadowOffset = .zero
        backgroundConvert.layer.shadowRadius = 3
        backgroundConvert.layer.shadowOpacity = 0.5
        convertButton.layer.cornerRadius = 10
        currencyController.fechingData()
    }
    
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
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
        currencyController.convertValue(mode: mode, value: textField.text)
    }    
    
}