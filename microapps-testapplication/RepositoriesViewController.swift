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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView.instance
        Github.repositories(language) { (repositories) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.repositories = repositories
                self.tableView.reloadData()
            })
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoRepositoryDetailViewController" {
            let repositoryDetailViewController = segue.destinationViewController as! RepositoryDetailViewController
            let indexPath = tableView.indexPathForSelectedRow
            let repository = repositories[indexPath!.row]
            repositoryDetailViewController.repository = repository
        }
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

extension UIView {
    class var instance: UIView {
        return UIView()
    }
}

enum TableViewCellIdentifiers: String {
    case RepositoriesTableViewCell = "repository-cell"
}
