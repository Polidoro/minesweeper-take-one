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
    var dateCreated: Int
    
    init(highScoreName: String, highScoreDate: Int, highScoreBoardType: Board) {
        playerName = highScoreName
        boardType = highScoreBoardType
        dateCreated = highScoreDate
    }
    
    init(highScoreName: String, highScoreDate: Int) {
        playerName = highScoreName
        boardType = Board(width: 0, height: 0, bombs: 0)
        dateCreated = highScoreDate
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
        
        // Configure New High Score
        newHighScore.setValue(1, forKey: "time")
        newHighScore.setValue("PlayerName", forKey: "player_name")
        newHighScore.setValue (newBoardType, forKey: "board_type")
        
        do {
            try newHighScore.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    func save() {
        
    }
}