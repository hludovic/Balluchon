//
//  TranslateViewController.swift
//  Balluchon
//
//  Created by Ludovic HENRY on 15/07/2020.
//  Copyright © 2020 Ludovic HENRY. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var textFieldResult: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    private var mode: TranslateMode? {
        didSet {
            refreshMode()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mode = .enToFr
        backgroundView.layer.cornerRadius = 10
        textField.layer.cornerRadius = 10
        translateButton.layer.cornerRadius = 10
        textFieldResult.layer.cornerRadius = 10
        activityIndicator.stopAnimating()
        
        
        // Do any additional setup after loading the view.
    }
    
    private func refreshMode() {
        if let mode = mode {
            if mode == .enToFr {
                originLabel.text = "English"
                destinationLabel.text = "French"
                textField.text = "Enter your text here"
            } else {
                originLabel.text = "French"
                destinationLabel.text = "English"
                textField.text = "Entrez votre texte ici"
            }
        }
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
    
    @IBAction func translateButton(_ sender: UIButton) {
        let translateService = TranslateService.shared
        
        guard let text = textField.text, let mode = mode, text != "" else {
            print("ERROR")
            return
        }
        
        let from: String
        let to: String
        if mode == .enToFr {
            from = "en"
            to = "fr"
        } else {
            from = "fr"
            to = "en"
        }
        
        translateService.translate(from: from, to: to, text: text) { (success, result) -> (Void) in
            guard success, let result = result else {
                print("ERROR")
                return
            }
            print("-------------FIN")
            self.textFieldResult.text = result.data.translations[0].translatedText
            
        }
        
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
}
