//
//  ViewController.swift
//  microapps-testapplication
//
//  Created by Furqan on 22/12/2015.
//  Copyright © 2015 Furqan Khan. All rights reserved.
//

import UIKit
import UITags

class SearchViewController: UIViewController, UITagsViewDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var tags: UITags!
    
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var goButtonCenterYConstraint: NSLayoutConstraint!
    
    var selectedLanguage: String! {
        didSet {
            performSegueWithIdentifier("gotoRepsitoriesViewController", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tags.delegate = self
        tags.tags = Github.languages
    }
    
    override func viewDidAppear(animated: Bool) {
        animateScreen()
    }

    func animateScreen() {
        logoHeightConstraint.constant -= 100
        logoWidthConstraint.constant -= 100
        logoCenterYConstraint.constant -= 100
        goButtonCenterYConstraint.constant += 40
        UIView.animateWithDuration(1.2) { _ in
            self.view.layoutIfNeeded()
        }
        UIView.animateWithDuration(0.5, delay: 0.5, options: .CurveEaseIn, animations: { _ in
            self.textField.alpha = 1
            self.goButton.alpha = 1
        }, completion: nil)
    }
    
    func restoreScreen() {
        logoHeightConstraint.constant += 100
        logoWidthConstraint.constant += 100
        logoCenterYConstraint.constant += 170
        goButtonCenterYConstraint.constant -= 40
        textField.alpha = 0
        goButton.alpha = 0
        tags.alpha = 0
    }
    
    func showTags() {
        logoCenterYConstraint.constant -= 70
        UIView.animateWithDuration(1.2) { _ in
            self.tags.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func hideTags() {
        logoCenterYConstraint.constant += 70
        UIView.animateWithDuration(0.3) { _ in
            self.tags.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        restoreScreen()
    }
    
    func tagSelected(atIndex index:Int) -> Void {
        selectedLanguage = Github.languages[index]
    }
    
    func tagDeselected(atIndex index:Int) -> Void {
        selectedLanguage = Github.languages[index]
    }
    
    @IBAction func go(sender: AnyObject) {
        if textField.text!.isEmpty {
            let alertView = UIAlertController(title: "Error", message: "You didn't select a language", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        } else {
            selectedLanguage = textField.text
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoRepsitoriesViewController" {
            let reposVC = segue.destinationViewController as! RepositoriesViewController
            reposVC.language = selectedLanguage
        }
    }

}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        showTags()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        selectedLanguage = textField.text
        return true
    }
}


