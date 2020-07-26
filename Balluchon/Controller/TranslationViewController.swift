//
//  TranslateViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController {
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var textFieldResult: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    // MARK: - Properties
    private let translater = Translater()
    
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
    
    // MARK: - Lifecycle
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
    
    // MARK: - IBAction Methods
    @IBAction func translateButton(_ sender: UIButton) {
        textField.resignFirstResponder()
        translater.translate(text: textField.text, to: destinationLanguage) { (success) -> (Void) in
            guard success else {
                self.displayError("We were unable to translate the text")
                return
            }
        }
    }

    @IBAction func switchLanguageButton(_ sender: UIButton) {
        destinationLanguage = (destinationLanguage == .en) ? .fr : .en
        textField.resignFirstResponder()
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate
extension TranslationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textField.text = String()
    }
}

// MARK: - TranslaterDelegate
extension TranslationViewController: TranslaterDelegate {
    func displayResult(_ text: String) { textFieldResult.text = text }
    
    func displayError(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
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
}
