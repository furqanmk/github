//
//  IssueTableViewCell.swift
//  microapps-testapplication
//
//  Created by Furqan on 26/12/2015.
//  Copyright © 2015 Furqan Khan. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {
    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var issueBody: UILabel!
    @IBOutlet weak var issueState: UILabel!
    @IBOutlet weak var issueNumber: UILabel!

    func setupIssue(issue: Issue) {
        issueTitle.text = issue.title
        issueBody.text = issue.body
        issueState.text = issue.state == .Open ? "open": "closed"
        issueNumber.text = "#\(issue.number)"
    }
}
