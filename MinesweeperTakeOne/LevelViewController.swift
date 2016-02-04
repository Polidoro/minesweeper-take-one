//
//  LevelViewController.swift
//  MinesweeperTakeOne
//
//  Created by Vincent Polidoro on 12/26/15.
//  Copyright © 2015 Vincent Polidoro. All rights reserved.
//

import UIKit
import CoreData

class LevelViewController: UITableViewController {

    let CellIdentifier = "SettingIdentifier" // Cell identifier for list of board settings
    var boardTypes = [BoardSetting]() // Array of objects used to build each table cell
    
    // Declare segues
    let HighScoreSegue = "HighScoreSegue"
    let BoardSegue = "BoardSegue"
 
    @IBAction func addGameType(sender: AnyObject) {
        title = "Blargh"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game Types"

        setDefaultBoards()
        getBoards()
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
    }

    // If there are no boards in CoreData populate it with some default settings
    func setDefaultBoards() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("BoardTypes", inManagedObjectContext: managedContext)
        
        // Fetch a list of board types
        let fetchRequest = NSFetchRequest(entityName: "BoardTypes")
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)

            // If the list is empty, populate a default set of board types
            if result.count == 0 {
                let defaultBoardArray = [("Easy",4,4,2),("Medium",8,6,16),("Hard",20,16,20),("Wacky",40,40,20)]

                // For each default board type, create a new setting object and save it
                for (name, rows, cols, bombs) in defaultBoardArray {
                    let setting = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                    setting.setValue(name, forKey: "name")
                    setting.setValue(cols, forKey: "columns")
                    setting.setValue(rows, forKey: "rows")
                    setting.setValue(bombs, forKey: "bombs")
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // Format is (cols, rows, bombs)
    func getBoards() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContent = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "BoardTypes")
        var boardSettings = [NSManagedObject]()
        
        do {
            let fetchResults = try managedContent.executeFetchRequest(fetchRequest)
            boardSettings = fetchResults as! [NSManagedObject]
            for boardSetting in boardSettings {
                boardTypes.append(BoardSetting(name: boardSetting.valueForKey("name")! as! String, width: Int(boardSetting.valueForKey("rows")! as! NSNumber),height: Int(boardSetting.valueForKey("columns")! as! NSNumber),bombs: Int(boardSetting.valueForKey("bombs")!as! NSNumber)))
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
        return boardTypes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel!.text = String(boardTypes[indexPath.row])

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Perform Segue
        performSegueWithIdentifier(BoardSegue, sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == HighScoreSegue {
            
        } else if segue.identifier == BoardSegue {
            let indexPath = tableView.indexPathForSelectedRow
            let chosenBoard = boardTypes[indexPath!.row]
            let destinationViewController = segue.destinationViewController as! BoardViewController
            
            destinationViewController.chosenBoardSetting = chosenBoard
        }
    }

}
