//
//  Connection.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/11/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import Foundation
import Alamofire
import ReachabilitySwift

protocol RedditAPIConnectionDelegate: class {
    func noInternetConnection()
}

class RedditAPIConnection {
    
    private let serviceUrl = "https://www.reddit.com/reddits.json"
    var delegate: RedditAPIConnectionDelegate?
    
    func fetchData(completion: @escaping (_ data: Any?) -> ()) {
        let internetConnection = Reachability()
        
        internetConnection?.whenReachable = { reachability in
            Alamofire.request(self.serviceUrl).responseJSON { response in
                CoreDataController.sharedInstance.deleteDataFromEntity("RedditPostEntity")
                completion(self.parseData(response.result.value))
            }
        }
        
        internetConnection?.whenUnreachable = { reachability in
            self.delegate?.noInternetConnection()
            completion(IMRedditPostMO.loadPostsFromLocalDatabase())
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.showAlertErrorWithMessage(reachability.currentReachabilityString)
        }
        
        do {
            try internetConnection?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

    }
    
    private func parseData(_ json: Any?) -> [RedditPost] {
        var posts: [RedditPost] = []
        
        if let children = ((json as? [String: NSObject])?["data"] as? [String: NSObject])?["children"] as? [[String: NSObject]] {
            for child in children {
                if let post = child["data"] as? [String: NSObject] {
                    let title = post["title"] as! String
                    let iconImg = post["icon_img"] as? String
                    let submitText = post["submit_text"] as! String
                    let category = post["advertiser_category"] as? String
                    let advertiserCategory =  category ?? "Without category"
                    
                    let post = RedditPost(title: title, iconImg: iconImg, submitText: submitText, advertiserCategory: advertiserCategory)
                    _ = IMRedditPostMO.savePostToLocalDatabase(post)
                    posts.append(post)
                }
            }
        }
        
        return posts
    }
}
