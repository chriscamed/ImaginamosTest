//
//  AppListViewController.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/12/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import UIKit
import AlamofireImage

class AppsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var appsList: [RedditPost] = []
    fileprivate var delay = 0.0
    fileprivate var isAlreadyLayed = false
    fileprivate let flipPresentAnimationController = FlipPresentAnimationController()
    fileprivate let flipDismissAnimationController = FlipDismissAnimationController()
    
    fileprivate let swipeInteractionController = SwipeInteractionController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewBackground()
        
        collectionView.register(UINib(nibName: "AppsListCollectionCell", bundle: Bundle.main) , forCellWithReuseIdentifier: "AppsListCollectionCell")
    }
    
    override func viewWillLayoutSubviews() {
        if !isAlreadyLayed {
            let top = topLayoutGuide.length
            let bottom = bottomLayoutGuide.length
            let newInsets = UIEdgeInsets(top: top, left: 10, bottom: bottom, right: 10)
            collectionView.contentInset = newInsets
            tableView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
            isAlreadyLayed = true
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
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UINavigationController {
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.viewControllers.first as! AppDetailViewController
            vc.post = sender as! RedditPost
            nvc.transitioningDelegate = self
            swipeInteractionController.wireToViewController(nvc)
        }
     }
    

}

extension AppsListViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppsListTableCell", for: indexPath) as! AppsListTableCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        cell.appTitle?.text = appsList[indexPath.row].title
        if let imgUrl = appsList[indexPath.row].iconImg, imgUrl != "" {
            cell.appImg.af_setImage(withURL: URL(string: imgUrl)!, placeholderImage: UIImage(named: "default-placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2))
        }
        
        cell.backgroundColor = UIColor.clear
        
        if cell.contentView.alpha != 1.0 {
            delay += 0.2
            UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseIn, animations: {
                cell.contentView.alpha = 1.0
            }, completion: nil)
        }
            
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailSegue", sender: appsList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppsListCollectionCell", for: indexPath) as! AppsListCollectionCell
        cell.appTitle.text = appsList[indexPath.row].title
        
        if let imgUrl = appsList[indexPath.row].iconImg, imgUrl != "" {
            cell.appImg.af_setImage(withURL: URL(string: imgUrl)!, placeholderImage: UIImage(named: "default-placeholder.png"), filter: nil, imageTransition: .crossDissolve(0.2))
        }
        
        delay += 0.2
        UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseIn, animations: {
            cell.appTitle.alpha = 1.0
            cell.appImg.alpha = 1.0
            cell.blurEffectView.alpha = 0.7
        }, completion: nil)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailSegue", sender: appsList[indexPath.row])
    }
    
}

extension AppsListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        flipPresentAnimationController.originFrame = self.view.frame
        return flipPresentAnimationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        flipDismissAnimationController.destinationFrame = self.view.frame
        return flipDismissAnimationController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
    }
}
