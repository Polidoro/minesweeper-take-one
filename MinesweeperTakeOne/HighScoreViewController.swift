//
//  HighScoreViewController.swift
//  MinesweeperTakeOne
//
//  Created by Vincent Polidoro on 1/30/16.
//  Copyright © 2016 Vincent Polidoro. All rights reserved.
//

// TODO: Add touch action for cells in high score list
// TODO: Reintroduce board type into getHighScores method

import UIKit
import CoreData

class HighScoreViewController: UITableViewController {

    var highScores = [HighScore]()
    let CellIdentifier = "HighScoreReuseIdendifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHighScores()
        self.title = "High Scores"
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
    }

    func getHighScores() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContent = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "HighScores")
        var savedHighScores = [NSManagedObject]()
        
        do {
            let fetchResults = try managedContent.executeFetchRequest(fetchRequest)
            savedHighScores = fetchResults as! [NSManagedObject]

            // Greate new highScore objects for each high score in the database
            for savedHighScore in savedHighScores {
                highScores.append(HighScore(highScoreName: savedHighScore.valueForKey("player_name") as! String, highScoreDate: savedHighScore.valueForKey("time") as! Int))
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return highScores.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel!.text = "Name: \(highScores[indexPath.row].playerName)"

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
