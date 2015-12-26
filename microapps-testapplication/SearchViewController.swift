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
        self.tags.delegate = self
        self.tags.tags = Github.languages
    }
    
    override func viewDidAppear(animated: Bool) {
        animateScreen()
    }

    func animateScreen() {
        self.logoHeightConstraint.constant -= 100
        self.logoWidthConstraint.constant -= 100
        self.logoCenterYConstraint.constant -= 100
        self.goButtonCenterYConstraint.constant += 40
        UIView.animateWithDuration(1.2) { _ in
            self.view.layoutIfNeeded()
        }
        UIView.animateWithDuration(0.5, delay: 0.5, options: .CurveEaseIn, animations: { _ in
            self.textField.alpha = 1
            self.goButton.alpha = 1
            self.tags.alpha = 1
        }, completion: nil)
    }
    
    func tagSelected(atIndex index:Int) -> Void {
        selectedLanguage = Github.languages[index]
    }
    
    func tagDeselected(atIndex index:Int) -> Void { }
    
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

