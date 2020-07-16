//
//  TranslateViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController, UITextViewDelegate, TranslationDisplayDelegate {
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var textFieldResult: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    let translationController = TranslationController()
    
    private var from: Language?
    private var to: Language?
    
    private var mode: TranslateMode? {
        didSet {
            if mode == .enToFr {
                from = .en
                to = .fr
                originLabel.text = "English"
                destinationLabel.text = "French"
                textField.text = "Enter your text here"
            } else {
                from = .fr
                to = .en
                originLabel.text = "French"
                destinationLabel.text = "English"
                textField.text = "Entrez votre texte ici"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        translationController.displayDelegate = self
        mode = .enToFr
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
        
        guard let from = from, let to = to, let text = textField.text else {
            displayAlert(text: "ERROR")
            return
        }
        
        translationController.translateText(from: from, to: to, text: text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textField.text = String()
    }
    
    @IBAction func switchLanguageButton(_ sender: UIButton) {
        if mode! == .enToFr {
            mode! = .frToEn
        } else {
            mode! = .enToFr
        }
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
