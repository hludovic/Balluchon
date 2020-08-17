//
//  DeviseViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 14/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {

    // MARK: - IBOutlet Properties
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var resultatLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundConvert: UIView!
    @IBOutlet weak var loadingStackView: UIStackView!

    // MARK: - Properties
    private let converter = Converter()

    private var mode: Converter.Mode? {
        didSet {
            if mode == .dolToEur {
                originLabel.text = "Dollars"
                destinationLabel.text = "Euros"
                textField.placeholder = "$"
            } else {
                originLabel.text = "Euros"
                destinationLabel.text = "Dollars"
                textField.placeholder = "€"
            }
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        converter.displayDelegate = self
        mode = .dolToEur

        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
        navigationItem.rightBarButtonItem = refreshButton

        backgroundView.layer.cornerRadius = 10
        backgroundConvert.layer.cornerRadius = 10
        backgroundConvert.layer.shadowColor = UIColor.black.cgColor
        backgroundConvert.layer.shadowOffset = .zero
        backgroundConvert.layer.shadowRadius = 3
        backgroundConvert.layer.shadowOpacity = 0.5
        convertButton.layer.cornerRadius = 10

        refreshData()
    }

    // MARK: - IBAction Methods
    @IBAction func pressSwitchButton(_ sender: UIButton) {
        mode = (mode! == .dolToEur) ? .eurToDol : .dolToEur
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }

    @IBAction func convertButton(_ sender: UIButton) {
        converter.convertValue(mode: mode, value: textField.text)
        textField.resignFirstResponder()
    }
}

// MARK: - Private Methods
private extension ConverterViewController {
    @objc func refreshData() {
        converter.fetchData { (success) -> Void in
            guard success else {
                self.displayError("We were unable to refresh the data")
                return
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension ConverterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "," {
            textField.text = textField.text! + "."
            return false
        }
        return true
    }
}

// MARK: - ConverterDelegate
extension ConverterViewController: ConverterDelegate {
    func displayResult(_ text: String) {
        DispatchQueue.main.async { self.resultatLabel.text = text }
    }

    func displayError(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func displayActivity(_ activity: Bool) {
        DispatchQueue.main.async {
            if activity {
                self.convertButton.isEnabled = false
                self.textField.isEnabled = false
                self.loadingStackView.isHidden = false
            } else {
                self.convertButton.isEnabled = true
                self.textField.isEnabled = true
                self.loadingStackView.isHidden = true
            }
        }
    }
    
}
