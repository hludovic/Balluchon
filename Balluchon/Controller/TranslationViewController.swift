//
//  TranslateViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController, UITextViewDelegate, TranslaterDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var textFieldResult: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    let translater = Translater()
    private var destinationLanguage: Translater.Language = .en {
        didSet {
            if destinationLanguage == .en {
                originLabel.text = "French"
                destinationLabel.text = "English"
                textField.text = "Entrez votre texte à traduire ici"
            } else {
                originLabel.text = "English"
                destinationLabel.text = "French"
                textField.text = "Enter your text to translate here"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        translater.displayDelegate = self
        destinationLanguage = .en
        backgroundView.layer.cornerRadius = 10
        textField.layer.cornerRadius = 10
        translateButton.layer.cornerRadius = 10
        textFieldResult.layer.cornerRadius = 10
        activityIndicator.stopAnimating()
    }
    
    func displayResult(_ text: String) {
        textFieldResult.text = text
    }
    
    func displayError(_ text: String) {
        displayAlert(text: text)
    }
    
    func displayActivity(_ activity: Bool) {
        if activity {
            activityIndicator.startAnimating()
            translateButton.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            translateButton.isHidden = false
        }
    }
    
    func displayAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func translateButton(_ sender: UIButton) {
        
        textField.resignFirstResponder()
        do {
            try translater.translate(text: textField.text, to: destinationLanguage)
        } catch {
            print("ERROR")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textField.text = String()
    }
    
    @IBAction func switchLanguageButton(_ sender: UIButton) {
        textFieldResult.text = ""
        if destinationLanguage == .en {
            destinationLanguage = .fr
        } else {
            destinationLanguage = .en
        }
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
