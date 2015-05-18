//
//  DataController.swift
//  FoodTracker
//
//  Created by Brown Magic on 5/15/15.
//  Copyright (c) 2015 codeHatcher. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController {
  
  //create class function, we won't need an instance of the data controller, pass in dictionary and we want tuples coming back out
  class func jsonAsUSDAIdAndNameSearchResults(json:NSDictionary) -> [(name:String, idValue:String)] {
    var usdaItemsSearchResults:[(name:String, idValue:String)] = []
    var searchResult:(name:String, idValue:String)
    
    if json["hits"] != nil {
      // the hits array is complex so just use anyObject as type
      let results:[AnyObject] = json["hits"]! as [AnyObject]
      
      // iterate through all the results as itemDictionary
      for itemDictionary in results {
        // before using a key, make sure it exists first
        if itemDictionary["_id"] != nil {
          if itemDictionary["fields"] != nil {
            let fieldsDictionary = itemDictionary["fields"] as NSDictionary
            if itemDictionary["item_name"] != nil {
              let idValue:String = itemDictionary["_id"]! as String
              let name:String = fieldsDictionary["item_name"]! as String
              searchResult = (name: name, idValue: idValue)
              usdaItemsSearchResults += [searchResult]
            }
          }
        }
      }
    }
    
    return usdaItemsSearchResults
  }
  
  func saveUSDAItemForId(idValue: String, json : NSDictionary) {
    if json["hits"] != nil {
      let results:[AnyObject] = json["hits"]! as [AnyObject]
      
      for itemDictionary in results {
        // check that there is an id and that it equals the idValue
        if itemDictionary["_id"] != nil && itemDictionary["_id"] as String == idValue {
          
          // make sure we don't save the same object twice into core data
          let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
          var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
          
          let itemDictionaryId = itemDictionary["_id"]! as String
          
          // does the idValue equal itemDictionaryId, you replace the %@ with the second argument passed in
          // predicate
          let predicate = NSPredicate(format: "idValue == %@", itemDictionaryId)
          requestForUSDAItem.predicate = predicate
          
          var error:NSError?
          
          var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
          
          // if items exist, don't write again
          if items?.count != 0 {
            // item is already saved so don't save it again
            return
          } else {
            // we haven't save to coreData yet so go ahead and do that
          }
          
        }
      }
    }
  }
  
}
