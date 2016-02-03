//
//  HighScore.swift
//  MinesweeperTakeOne
//
//  Created by Vincent Polidoro on 2/1/16.
//  Copyright © 2016 Vincent Polidoro. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HighScore {
    var playerName: String
    var boardType: Board
    var dateCreated: NSDate
    
    init(theScoreId: Int) {
        playerName = "Hello"
        boardType = Board(width: 0, height: 0, bombs: 0)
        dateCreated = NSDate()
    }

    func populateDefaults() {
        // Create Managed Object
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        var entityDescription = NSEntityDescription.entityForName("BoardTypes", inManagedObjectContext: managedContext)
        let newBoardType = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: managedContext)
        
        // Configure New Person
        newBoardType.setValue("TempName", forKey: "name")
        newBoardType.setValue(6, forKey: "rows")
        newBoardType.setValue(6, forKey: "columns")
        newBoardType.setValue(6, forKey: "bombs")
        
        do {
            try newBoardType.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        entityDescription = NSEntityDescription.entityForName("HighScores", inManagedObjectContext: managedContext)
        let newHighScore = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: managedContext)
        
        // Configure New Person
        newHighScore.setValue(1, forKey: "time")
        newHighScore.setValue("PlayerName", forKey: "player_name")
        
        NSLog(newBoardType.debugDescription)
        
        NSLog(NSStringFromClass(newBoardType.classForCoder))
        newHighScore.setValue (newBoardType, forKey: "board_type")
        
        do {
            try newHighScore.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
        
        /*let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("HighScores", inManagedObjectContext: managedContext)
        
        // Fetch a list of high scores
        let fetchRequest = NSFetchRequest(entityName: "HighScores")
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            
            // If the list is empty, populate a default set of high scores (for testing purposes only)
            if true || result.count == 0 { // TODO: Fix this conditional
                
                
                let setting = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                setting.setValue(playerName, forKey: "player_name")
                setting.setValue(1, forKey: "time")
                setting.setValue(NSSet(object: boardType), forKeyPath: "board_type")

                NSLog(setting.debugDescription)
                
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }*/
    }
    
    func save() {
        
    }
}