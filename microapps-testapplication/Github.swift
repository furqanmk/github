//
//  Github.swift
//  microapps-testapplication
//
//  Created by Furqan on 22/12/2015.
//  Copyright © 2015 Furqan Khan. All rights reserved.
//

import UIKit

class Github {
    
    static let languages = [
        "JavaScript",
        "Java",
        "Python",
        "CSS",
        "PHP",
        "Ruby",
        "C++",
        "C",
        "Shell",
        "CSharp",
        "Objective-C",
        "R",
        "VimL",
        "Go",
        "Perl",
        "CoffeeScript",
        "TeX",
        "Swift",
        "Scala",
        "Emacs Lisp",
        "Haskell",
        "Lua",
        "Clojure",
        "Matlab",
        "Arduino",
        "Makefile",
        "Groovy",
        "Puppet",
        "Rust",
        "PowerShell"
    ]
    
    static func repositories (language: String, completion: ([Repository]) -> Void) {
        let request = NSURLRequest.requestForRepositories(language)
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            guard let _ = error else {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    var repositories = [Repository]()
                    if let array = ((json as! NSDictionary)["items"]) as? [NSDictionary] {
                        for item in array {
                            let name = item["name"] as! String
                            let description = item["description"] as! String
                            let issuesUrl = item["issues_url"] as! String
                            let contributorsUrl = item["contributors_url"] as! String
                            let stargazers = item["stargazers_count"] as! Int
                            let language = item["language"] as! String
                            if let _owner = item["owner"] as? NSDictionary {
                                let username = _owner["login"] as! String
                                let avatarUrl = _owner["avatar_url"] as! String
                                let image = UIImage(data: NSData(contentsOfURL: NSURL(string: avatarUrl)!)!)
                                let owner = Owner(username: username, image: image!)
                                let repository = Repository(name: name, description: description, issuesUrl: issuesUrl, contributorsUrl: contributorsUrl, owner: owner, stargazers: stargazers, language: language)
                                repositories.append(repository)
                                
                            }
                            
                        }
                        completion(repositories)
                        
                    } else { completion(repositories) }
                    
                } catch {
                    
                }
                return
            }
            
            print("Error: \(error?.localizedDescription)", true)
            
        }).resume()
    }
}

class Repository {
    var name: String!,
    description: String!,
    issues: [Issue],
    contributors: [Contributor],
    issuesUrl: String,
    contributorsUrl: String,
    owner: Owner,
    stargazers: Int,
    language: String
    
    init (name: String, description: String, issuesUrl: String, contributorsUrl: String, owner: Owner, stargazers: Int, language: String) {
        self.name = name
        self.description = description
        self.issuesUrl = issuesUrl
        self.contributorsUrl = contributorsUrl
        self.owner = owner
        self.stargazers = stargazers
        self.language = language
        self.issues = []
        self.contributors = []
    }
    
    func addIssue (issue: Issue) { issues.append(issue) }
    func addContributor (contributor: Contributor) { contributors.append(contributor) }
    
    
    func newestIssues (count: Int, completion: ([Issue]) -> Void) {
        let issuesUrlRequest = NSURLRequest.requestForIssues(issuesUrl, state: .Open)
        NSURLSession.sharedSession().dataTaskWithRequest(issuesUrlRequest, completionHandler: { (data, response, error) -> Void in
            guard let _ = error else {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    var issues = [Issue]()
                    if let array = json as? NSArray {
                        for item in array {
                            let title = item["title"] as! String
                            let state = (item["state"] as! String == "open") ? IssueState.Open: IssueState.Closed
                            let body = item["body"] as? String
                            let number = item["number"] as! Int
                            issues.append(Issue(state: state, title: title, body: body, number: number))
                        }
                        if issues.count > count { completion(Array(issues[0...2])) }
                        else { completion(issues) }
                        
                    } else {  }
                    
                } catch {
                    
                }
                return
            }
            
            print("Error: \(error?.localizedDescription)", true)
            
        }).resume()
    }
    
    func topContributors (count: Int, completion: ([Contributor]) -> Void) {
        let issuesUrlRequest = NSURLRequest.requestForContributors(contributorsUrl)
        NSURLSession.sharedSession().dataTaskWithRequest(issuesUrlRequest, completionHandler: { (data, response, error) -> Void in
            guard let _ = error else {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    var contributors = [Contributor]()
                    if let array = json as? NSArray {
                        for item in array {
                            
                            let username = item["login"] as! String
                            let contributions = item["contributions"] as! Int
                            let avatarUrl = item["avatar_url"] as! String
                            let image = UIImage(data: NSData(contentsOfURL: NSURL(string: avatarUrl)!)!)
                            contributors.append(Contributor(username: username, image: image!, contributions: contributions))
                            
                        }
                        if array.count > count { completion(Array(self.contributors[0..<count])) }
                        else { completion(self.contributors) }
                        
                    } else {  }
                    
                } catch {
                    
                }
                return
            }
            
            print("Error: \(error?.localizedDescription)", true)
            
        }).resume()
    }

    
}

struct Issue {
    var state: IssueState,
    title: String,
    body: String?,
    number: Int
}

class Contributor: Owner {
    var contributions: Int
    init(username: String, image: UIImage, contributions: Int) {
        self.contributions = contributions
        super.init(username: username, image: image)
        
    }
}

class Owner {
    var username: String, image: UIImage
    init(username: String, image: UIImage) {
        self.username = username
        self.image = image
    }
}

enum IssueState {
    case Open, Closed
}

extension NSURLRequest {
    static func requestForRepositories(language: String) -> NSURLRequest {
        let url = "https://api.github.com/search/repositories?q=language:\(language)&sort=stars&order=desc"
        return NSURLRequest(URL: NSURL(string: url)!)
    }
    
    static func requestForIssues(issuesUrl: String, state: IssueState) -> NSURLRequest {
        let range = issuesUrl.rangeOfString("{/number}")
        var url = issuesUrl
        url.removeRange(range!)
        url += "?state=\(state == .Open ? "open" : "closed")&sort=created_at&order=desc"
        return NSURLRequest(URL: NSURL(string: url)!)
    }
    
    static func requestForContributors (contributorsUrl: String) -> NSURLRequest {
        let url = contributorsUrl + "?q=sort=contributions&order=asc"
        return NSURLRequest(URL: NSURL(string: url)!)
    }
    
}
