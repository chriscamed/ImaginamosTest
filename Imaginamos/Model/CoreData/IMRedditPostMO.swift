//
//  IMRedditPostMO.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/12/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import Foundation
import CoreData

class IMRedditPostMO: NSManagedObject {
    
    @NSManaged var title: String?
    @NSManaged var iconImg: String?
    @NSManaged var submitText: String?
    @NSManaged var advertiserCategory: String?
    
    static func savePostToLocalDatabase(_ post: RedditPost) -> Bool {
        let moc = CoreDataController.sharedInstance.managedObjectContext
        
        let redditPostEntity = NSEntityDescription.insertNewObject(forEntityName: "RedditPostEntity", into: moc) as! IMRedditPostMO
        redditPostEntity.setValue(post.title, forKey: "title")
        redditPostEntity.setValue(post.submitText, forKey: "submitText")
        redditPostEntity.setValue(post.iconImg, forKey: "iconImg")
        redditPostEntity.setValue(post.advertiserCategory, forKey: "advertiserCategory")
        
        do {
            try moc.save()
            print("Data saved successfully!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    static func loadPostsFromLocalDatabase() -> [RedditPost]? {
        let moc = CoreDataController.sharedInstance.managedObjectContext
        let postsFetch = NSFetchRequest<NSManagedObject>(entityName: "RedditPostEntity")
        postsFetch.returnsObjectsAsFaults = false
        
        do {
            let data = try moc.fetch(postsFetch) as! [IMRedditPostMO]
            var postsList: [RedditPost] = []
            
            for postMO in data {
                let title = postMO.title!
                let submitText = postMO.submitText!
                let iconImg = postMO.iconImg
                let advertiserCategory = postMO.advertiserCategory!
                
                postsList.append(RedditPost(title: title,
                                            iconImg: iconImg,
                                            submitText: submitText,
                                            advertiserCategory: advertiserCategory))
            }
            
            print("Data loaded successfully!")
            
            return postsList
        } catch let error as NSError {
            print("Error \(error)")
            return nil
        }
    }
    
}
