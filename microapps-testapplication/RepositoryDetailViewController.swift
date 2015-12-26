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
    
    var repository: Repository!
    
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
    }
    
}
