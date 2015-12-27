//
//  RepositoriesViewController.swift
//  microapps-testapplication
//
//  Created by Furqan on 25/12/2015.
//  Copyright © 2015 Furqan Khan. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController {
    var language: String!
    var repositories = [Repository] ()
    
    var animationView: RPLoadingAnimationView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        Github.repositories(language) { (repositories) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if repositories.count == 0 {
                    self.stopLoadingAnimation()
                    
                    let alert = UIAlertController(title: "Error", message: "There are no repositories for this language", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: { (alert) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                self.stopLoadingAnimation()
                self.repositories = repositories
                self.tableView.reloadData()
            })
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if repositories.isEmpty {
            startLoadingAnimation()
        }
    }
    
    func startLoadingAnimation() {
        let animationFrame = CGRect(origin: CGPointZero, size: CGSize(width: 100, height: 100))
        animationView = RPLoadingAnimationView(
            frame: animationFrame,
            type: RPLoadingAnimationType.RotatingCircle,
            color: UIColor.blackColor(),
            size: animationFrame.size
        )
        animationView.center = view.center
        view.addSubview(animationView)
        animationView.setupAnimation()
    }
    
    func stopLoadingAnimation() {
        animationView.removeFromSuperview()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoRepositoryDetailViewController" {
            let repositoryDetailViewController = segue.destinationViewController as! RepositoryDetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            let repository = repositories[indexPath!.row]
            repositoryDetailViewController.repository = repository
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension RepositoriesViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.RepositoriesTableViewCell.rawValue) as! RepositoriesTableViewCell
        cell.setupRepository(repositories[indexPath.row])
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return repositories.count
        } else {
            return 0
        }
    }
}

enum TableViewCellIdentifiers: String {
    case RepositoriesTableViewCell = "repository-cell"
}
