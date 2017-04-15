//
//  AppDetailViewController.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/14/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import UIKit
import AlamofireImage

class AppDetailViewController: UIViewController {
    
    @IBOutlet weak var appImg: UIImageView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appDescription: UILabel!
    @IBOutlet weak var appCategory: UILabel!
    
    var post: RedditPost!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        if let img = post.iconImg, img != "" {
            let url = URL(string: img)
            appImg.af_setImage(withURL: url!, placeholderImage: UIImage(named: "default-placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
        }
        
        appTitle.text = post.title
        appDescription.text = post.submitText
        appCategory.text = "Category: \(post.advertiserCategory)"
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white;
        navigationController?.navigationBar.barTintColor = UIColor.clear
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
