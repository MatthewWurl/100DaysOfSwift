//
//  ActionViewController.swift
//  Extension
//
//  Created by Matt X on 12/21/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {
    @IBOutlet weak var scriptTextView: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var savedScriptsForURL: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let examplesButton = UIBarButtonItem (
            title: "Examples",
            style: .plain,
            target: self,
            action: #selector(showExampleScripts)
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(done)
        )
        
        navigationItem.leftBarButtonItem = examplesButton
        navigationItem.rightBarButtonItem = doneButton
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] dict, error in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                        self?.getSavedScriptsForURL()
                    }
                }
            }
        }
    }
    
    func getSavedScriptsForURL() {
        savedScriptsForURL = UserDefaults.standard.dictionary(forKey: "SavedScriptsForURL") as? [String:String] ?? [:]
        
        if let url = URL(string: pageURL) {
            if let host = url.host {
                scriptTextView.text = savedScriptsForURL[host]
            }
        }
    }
    
    func setSavedScriptsForURL() {
        if let url = URL(string: pageURL) {
            if let host = url.host {
                savedScriptsForURL.updateValue(scriptTextView.text, forKey: host)
            }
        }
        
        UserDefaults.standard.set(savedScriptsForURL, forKey: "SavedScriptsForURL")
    }

    @objc func done() {
        DispatchQueue.global(qos: .background).async {
            self.setSavedScriptsForURL()
        }
        
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": scriptTextView.text ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func showExampleScripts() {
        let examplesAlert = UIAlertController(
            title: "Examples",
            message: "Here are some pre-written example scripts.",
            preferredStyle: .actionSheet
        )
        
        examplesAlert.addAction(
            UIAlertAction(title: "Display an alert", style: .default) { [weak self] _ in
                self?.scriptTextView.text = ExampleScripts.displayAlert.rawValue
            }
        )
        
        examplesAlert.addAction(
            UIAlertAction(title: "Replace page content", style: .default) { [weak self] _ in
                self?.scriptTextView.text = ExampleScripts.replacePageContent.rawValue
            }
        )
        
        examplesAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(examplesAlert, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scriptTextView.contentInset = .zero
        } else {
            scriptTextView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                right: 0
            )
        }
        
        scriptTextView.scrollIndicatorInsets = scriptTextView.contentInset
        
        let selectedRange = scriptTextView.selectedRange
        scriptTextView.scrollRangeToVisible(selectedRange)
    }
}
