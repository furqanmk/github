//
//  RepositoryDetail.swift
//  microapps-testapplication
//
//  Created by Furqan on 25/12/2015.
//  Copyright © 2015 Furqan Khan. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak var ownerImage: UIImageView! {
        didSet {
            let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let effectView = UIVisualEffectView(effect: blur)
            effectView.frame = ownerImage.frame
            ownerImage.addSubview(effectView)
        }
    }
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoStargazers: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var issuesTableView: UITableView! {
        didSet {
            issuesTableView.estimatedRowHeight = 80.0
            issuesTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet var contributorImages: [UIImageView]!
    @IBOutlet var contributorUsernames:[UILabel]!
    @IBOutlet var contributorContributions: [UILabel]!
    
    var repository: Repository!
    var issues: [Issue] = [ ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRepository(repository)
    }
    
    private func setupOwner (owner: Owner) {
        ownerImage.image = owner.image
        ownerName.text = "@" + owner.username
    }
    
    func setupRepository (repository: Repository) {
        repoName.text = repository.name
        repoStargazers.text = "\(repository.stargazers)"
        repoLanguage.text = repository.language
        setupOwner(repository.owner)
        
        repository.newestIssues(3) { (issues) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.issues = issues
                self.issuesTableView.reloadData()
            })
        }
        
        repository.topContributors(3) { (contributors) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                for index in 0..<contributors.count {
                    self.setupContributor(forIndex: index, contributor: contributors[index])
                }
            })

            
        }
    }
    
    func setupContributor(forIndex index: Int, contributor: Contributor) {
        contributorImages[index].image = contributor.image
        contributorUsernames[index].text = "@" + contributor.username
        contributorContributions[index].text = "\(contributor.contributions)"
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension RepositoryDetailViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("issue-tableViewCell") as! IssueTableViewCell
        cell.setupIssue(issues[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
}
