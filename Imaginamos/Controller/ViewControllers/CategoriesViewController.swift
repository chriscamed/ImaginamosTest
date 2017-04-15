//
//  MainViewController.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/11/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var internetConnMessage: UIView!
    @IBOutlet weak var msgViewBlurEffect: UIVisualEffectView!
    
    fileprivate var posts: [String: [RedditPost]] = [:]
    fileprivate var delay = 0.0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()        
        msgViewBlurEffect.effect = nil
        (UIApplication.shared.delegate as! AppDelegate).setupNavigationBar()
        internetConnMessage.layer.cornerRadius = 6
        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)                
        setupTableViewBackground()
        
        let redditConnection = RedditAPIConnection()
        redditConnection.delegate = self
        redditConnection.fetchData { data in
            if let error = data as? Error {
                (UIApplication.shared.delegate as! AppDelegate).showAlertErrorWithMessage(error.localizedDescription)
            } else if let posts = data as? [RedditPost] {
                self.posts = posts.groupBy { $0.advertiserCategory }
                if !self.internetConnMessage.isDescendant(of: self.view) {
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
                
            }            
        }
    }
    
    private func setupTableViewBackground() {
        tableView.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        let backgroundImage = UIImageView(image: UIImage(named: "main-img-home.jpg"))
        let containerView = UIView(frame: tableView.bounds)
        backgroundImage.frame = containerView.bounds
        blurEffectView.frame = containerView.bounds
        backgroundImage.contentMode = .scaleAspectFill
        containerView.addSubview(backgroundImage)
        containerView.addSubview(blurEffectView)
        tableView.backgroundView = containerView
        
        tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
    }
    
    fileprivate func showMessageAnimated() {
        DispatchQueue.main.async {
            self.view.addSubview(self.internetConnMessage)
            self.internetConnMessage.center = self.view.center
            self.internetConnMessage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.internetConnMessage.alpha = 0.0
            
            UIView.animate(withDuration: 0.5) {
                self.internetConnMessage.alpha = 1.0
                self.internetConnMessage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.msgViewBlurEffect.effect = UIBlurEffect(style: .light)
            }
        }
        
    }
    
    @IBAction func hideMessageAnimated(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4, animations: {
            self.internetConnMessage.alpha = 0.0
            self.internetConnMessage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.msgViewBlurEffect.effect = nil
        }) { completed in
            self.internetConnMessage.removeFromSuperview()
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
        
    }    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AppsListViewController {
            let vc = segue.destination as! AppsListViewController
            vc.appsList = sender as! [RedditPost]
        }
    }

}

extension CategoriesViewController: RedditAPIConnectionDelegate {
    func noInternetConnection() {
        showMessageAnimated()
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell", for: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        cell.textLabel?.text = Array(posts.keys)[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postKey = Array(posts.keys)[indexPath.row]
        performSegue(withIdentifier: "showAppsSegue", sender: posts[postKey])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.contentView.backgroundColor = UIColor.random
        cell.title.text = Array(posts.keys)[indexPath.row]
        
        delay += 0.2
        UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseIn, animations: {
            cell.contentView.alpha = 1.0
            cell.title.alpha = 1.0
        }, completion: nil)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postKey = Array(posts.keys)[indexPath.row]
        performSegue(withIdentifier: "showAppsSegue", sender: posts[postKey])
    }
    
}
