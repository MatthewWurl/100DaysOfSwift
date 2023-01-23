//
//  ViewController.swift
//  SecretSwift
//
//  Created by Matt X on 1/16/23.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var secretTextView: UITextView!
    
    var hasPassword: Bool {
        KeychainWrapper.standard.hasValue(forKey: "Password")
    }
    var doneButton: UIBarButtonItem!
    var passwordButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here..."
        
        passwordButton = UIBarButtonItem(
            title: "Password",
            style: .plain,
            target: self,
            action: #selector(setPassword)
        )
        passwordButton.isHidden = true
        
        doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(saveSecretMessage)
        )
        doneButton.isHidden = true
        
        navigationItem.leftBarButtonItem = passwordButton
        navigationItem.rightBarButtonItem = doneButton
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(saveSecretMessage),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }

    @IBAction func authenticateWithBiometricsTapped(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // Error with authentication...
                    }
                }
            }
        } else {
            // No biometrics...
            let ac = UIAlertController(
                title: "Biometrics unavailable",
                message: "Your device is not configured for biometric authentication.",
                preferredStyle: .alert
            )
            
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(ac, animated: true)
        }
    }
    
    @IBAction func authenticateWithPasswordTapped(_ sender: UIButton) {
        guard hasPassword else {
            let ac = UIAlertController(
                title: "No password set",
                message: "Sorry, you must use biometric authentication until a password is set.",
                preferredStyle: .alert
            )
            
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(ac, animated: true)
            return
        }
        
        let ac = UIAlertController(title: "Enter password", message: nil, preferredStyle: .alert)
        
        ac.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "Password"
        }
        
        ac.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                guard let passwordEntered = ac?.textFields?[0].text else { return }
                
                if passwordEntered == KeychainWrapper.standard.string(forKey: "Password") {
                    self?.unlockSecretMessage()
                }
            }
        )
        
        present(ac, animated: true)
    }
    
    func unlockSecretMessage() {
        secretTextView.isHidden = false
        passwordButton.isHidden = false
        doneButton.isHidden = false
        
        title = "Secret Message"
        
        secretTextView.text = KeychainWrapper.standard.string(forKey: "SecretMessage")
    }
    
    @objc func saveSecretMessage() {
        guard secretTextView.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secretTextView.text, forKey: "SecretMessage")
        
        secretTextView.resignFirstResponder()
        secretTextView.isHidden = true
        passwordButton.isHidden = true
        doneButton.isHidden = true
        
        title = "Nothing to see here..."
    }
    
    @objc func setPassword() {
        let ac = UIAlertController(
            title: "Type your new password",
            message: "This can be used instead of biometric authentication.",
            preferredStyle: .alert
        )
        
        ac.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "Password"
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.addAction(
            UIAlertAction(title: "OK", style: .default) { [weak ac] _ in
                guard let password = ac?.textFields?[0].text else { return }
                
                KeychainWrapper.standard.set(password, forKey: "Password")
            }
        )
        
        present(ac, animated: true)
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEnd = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secretTextView.contentInset = .zero
        } else {
            let bottomInset = keyboardViewEnd.height - view.safeAreaInsets.bottom
            secretTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        }
        
        secretTextView.scrollIndicatorInsets = secretTextView.contentInset
        
        let selectedRange = secretTextView.selectedRange
        secretTextView.scrollRangeToVisible(selectedRange)
    }
}
