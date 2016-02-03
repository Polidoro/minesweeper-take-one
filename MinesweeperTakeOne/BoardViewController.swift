//
//  BoardViewController.swift
//  MinesweeperTakeOne
//
//  Created by Vincent Polidoro on 12/27/15.
//  Copyright © 2015 Vincent Polidoro. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    // Define the layout elements for the game
    let theFlag = UIView() // Flag object to be drag-and-dropped onto board
    let moveCounter = UILabel() // Lable for displaying moves
    let timeCounter = UILabel()// = UILabel(frame: CGRect(x: 0,y: 0,width: 0,height: 0)) // Label for displaying timeTaken
    let bombCounter = UILabel() // Label to display bombs on board
    let flagCounter = UILabel() // Label to display flags placed
    let resetButton = UIButton(type: UIButtonType.System)
    let winLoseLabel = UILabel()

    // Declare the "Reset board" alert
    var confirmResetAlert = UIAlertController(title: "Reset Board", message: "Are you sure you want to reset the board? You will lose all progress in your current game.", preferredStyle: UIAlertControllerStyle.Alert)
    
    // Board specific data, defined by parent view
    var boardName: String!
    var countRows: Int!
    var countCols: Int!
    var countBombs: Int!
    var gameActive = false
    var theBoard: Board! // Minesweeper class used to set bombs and grid values
    var buttonArray = [[SquareButton]]() // The array of grid squares
    var oneSecondTimer:NSTimer? // The timer
    
    // Tracks the number of seconds elapsed since the game started
    var countSeconds:Int = 0  {
        didSet {
            timeCounter.text = "Time: \(countSeconds)"
            timeCounter.sizeToFit()
        }
    }
    
    // Tracks the number of seconds elapsed since the game started
    var countFlags:Int = 0  {
        didSet {
            flagCounter.text = "Flags Placed: \(countFlags)"
            flagCounter.sizeToFit()
        }
    }
    
    // Tracks the number of moves by the player
    var countMoves: Int = 0 {
        didSet {
            moveCounter.text = "Moves: \(countMoves)"
            moveCounter.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = boardName
        buildNewBoard()
        
        // Define the one second timer to manage the clock
        oneSecondTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("oneSecond"), userInfo: nil, repeats: true)
        timeCounter.frame.origin = CGPoint(x: 10, y: 80)
        timeCounter.text = "Time: \(countSeconds)"
        timeCounter.sizeToFit()

        // Define the move counter
        moveCounter.frame.origin = CGPoint(x: 100, y: 80)
        moveCounter.text = "Moves: \(countMoves)"
        moveCounter.sizeToFit()
        
        // Display bomb count
        bombCounter.frame.origin = CGPoint(x: 10, y: view.frame.height - 30)
        bombCounter.text = "Bombs: \(countBombs)"
        bombCounter.sizeToFit()
        
        // Display count of flags placed
        flagCounter.frame.origin = CGPoint(x: 100, y: view.frame.height - 30)
        flagCounter.text = "Flags Placed: \(countFlags)"
        flagCounter.sizeToFit()
       
        // Set up the flag and add a gesture recognizer to it
        theFlag.frame = CGRect(x: view.frame.width - 50, y: view.frame.height - 50, width: 40, height: 40)
        theFlag.backgroundColor = UIColor(patternImage: UIImage(named: "flag")!)
        let pan = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        theFlag.addGestureRecognizer(pan)
        
        // Place and stylize the Reset Board button
        resetButton.frame = CGRectMake(view.frame.width - 110, 75, 100, 30)
        resetButton.addTarget(self, action: Selector("confirmBoardReset:"), forControlEvents: .TouchUpInside)
        resetButton.setTitle("Reset Board", forState: .Normal)
        resetButton.backgroundColor = UIColor.whiteColor()
        resetButton.layer.cornerRadius = 3
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.blueColor().CGColor
        
        // Define the reset alert actions
        let confirm = UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
            self.resetBoard()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            
        })
        confirmResetAlert.addAction(confirm)
        confirmResetAlert.addAction(cancel)

        // Configure the winLoseLabel and hide it until a win or loss
        winLoseLabel.frame = CGRect(x: 10, y: view.frame.height - 160, width: view.frame.width - 20, height: 100)
        winLoseLabel.alpha = 0
        winLoseLabel.textColor = UIColor.whiteColor()
        winLoseLabel.textAlignment = .Center
        winLoseLabel.font = UIFont(name: "Avenir-Heavy", size: 26.0)
        
        // Add the necessary elements to the main view
        view.addSubview(theFlag)
        view.addSubview(moveCounter)
        view.addSubview(timeCounter)
        view.addSubview(flagCounter)
        view.addSubview(bombCounter)
        view.addSubview(resetButton)
        view.addSubview(winLoseLabel)
    }
    
    func buildNewBoard() {
        // Build the board and the UI
        theBoard = Board(width: countCols, height: countRows, bombs: countBombs)
        setUpGrid()
        view.bringSubviewToFront(theFlag)
        gameActive = true
    }
    
    // Checks if current game is active, if so prompt confirmation message
    func confirmBoardReset(sender: UIButton) {
        if gameActive {
            presentViewController(confirmResetAlert, animated: true, completion: nil)
        } else {
            resetBoard()
        }
    }
    
    // Resets the board
    func resetBoard() {
        // Reset all local counters
        oneSecondTimer?.invalidate()
        oneSecondTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("oneSecond"), userInfo: nil, repeats: true)
        countSeconds = 0
        countFlags = 0
        countMoves = 0
        winLoseLabel.alpha = 0
        
        // Clear the aray of buttons and build a new board
        buttonArray.removeAll()
        buildNewBoard()
    }
    
    // Triggered when the flag is dragged from the origin location
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(view)
        
        // Move the flag view
        theFlag.center = CGPoint(x:theFlag.center.x + translation.x, y:theFlag.center.y + translation.y)
        
        // Check each button in the button array
        for row in buttonArray {
            for gridView in row {
                // Highlight the square if it contains the center of the flag
                gridView.highlighted = CGRectContainsPoint(gridView.frame, theFlag.center)
                
                // Check if the center of flag is over a grid square
                if gestureRecognizer.state == UIGestureRecognizerState.Ended && CGRectContainsPoint(gridView.frame, theFlag.center) {
                    // If the gesture ends with the flag over a square, unhighlight and disable the square
                    gridView.highlighted = false
                    flagSquare(gridView)
                }
            }
        }
        
        // If the gesture is over, move the flag back to the original position
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            theFlag.center = CGPoint(x: view.frame.width - 30, y: view.frame.height - 30)
        }
        
        // Reduce the translation to 0 to maintain gesture motion
        gestureRecognizer.setTranslation(CGPointZero, inView: view)
    }
    
    // Builds the board, returns width of each grid object
    func setUpGrid() {
        // Determine width of each square in the grid
        let squareWidth = Int(view.frame.width)/countCols

        // For each item in the grid, create a new gridSquare
        for row in 0..<countRows {
            var gridRow = [SquareButton]()
            for col in 0..<countCols {
                // Define a grid square as a button
                let gridSquare = SquareButton(theSquare: theBoard.board[row][col], rect: CGRect(x: col*squareWidth, y: row*squareWidth + 110, width: squareWidth, height: squareWidth), row: row, col: col)
                gridSquare.setImage(UIImage(named: "unopened")!, forState: .Normal)
                
                // Add a gesture recognizer to handle long presses and target for taps
                let long = UILongPressGestureRecognizer(target: self, action: "removeFlag:")
                gridSquare.addGestureRecognizer(long)
                gridSquare.addTarget(self, action: "squareTapped:", forControlEvents: .TouchUpInside)
                
                // Add gridSquare to an array for future usage, then render it on the main view
                gridRow.append(gridSquare)
                view.addSubview(gridSquare)
            }
            buttonArray.append(gridRow)
        }
    }
    
    // Triggered when a mine is revealed
    func gameOver(theSquare: SquareButton) {
        
        // Reveal all the mines on the board
        for row in buttonArray {
            for gridSquare in row {
                if gridSquare.square.isBomb {
                    gridSquare.setImage(UIImage(named: "mine"), forState: .Normal)
                }
            }
        }
        
        // Configure and display the winLoseLabel
        winLoseLabel.backgroundColor = UIColor.redColor()
        winLoseLabel.alpha = 1
        winLoseLabel.text = "You Lose"
        
        // Disable the board and the timer
        disableBoard()
        gameActive = false
        oneSecondTimer?.invalidate()
    }

    // Open a square, called by squareTapped or recursively by itself
    func openSquare(theSquare: SquareButton) {
        theSquare.square.isOpen = true
        theSquare.setImage(UIImage(named: String(theSquare.square.description))!, forState: .Normal)
        theSquare.userInteractionEnabled = false
        theBoard.countOpenedSquares++
        
       if theSquare.square.bombsAdjacent == 0 && !theSquare.square.isBomb {
            // Recursively run openSquares on adjacent open squares if there are no bombs adjacent
            for index in theSquare.square.squaresAdjacent {
                if !buttonArray[theSquare.row!+index.0][theSquare.col!+index.1].square.isOpen {
                    openSquare(buttonArray[theSquare.row!+index.0][theSquare.col!+index.1])
                }
            }
        }
    }
    
    // When the player wins, flag all the bombs, disable the board, stop the timer and display a notification
    func youWin() {
        oneSecondTimer?.invalidate()
        
        // Disable all the board squares and flag all unflagged mines
        for row in buttonArray {
            for gridSquare in row {
                gridSquare.userInteractionEnabled = false
                if gridSquare.square.isBomb {
                    gridSquare.setImage(UIImage(named: "flagged"), forState: .Normal)
                }
            }
        }
        
        // Set color for win/lose label, unhide it and set the game to inactive
        winLoseLabel.backgroundColor = UIColor.greenColor()
        winLoseLabel.alpha = 1
        winLoseLabel.text = "You Win!"
        gameActive = false
    }
    
    // Triggered when a user taps a grid square
    func squareTapped(sender: SquareButton) {
        if !sender.square.isFlagged && !sender.square.isOpen {
            countMoves++
            openSquare(sender)
        }
        
        // After the move is processed, check if the player wins or loses
        if sender.square.isBomb {
            gameOver(sender)
        } else if theBoard.checkWin() {
            youWin()
        }
    }
    
    // Function that sets userInteractionEnabled to false for all squares
    func disableBoard() {
        for row in buttonArray {
            for gridSquare in row {
                gridSquare.userInteractionEnabled = false
            }
        }
    }
    
    // Triggered when the a gesture ends while the flag centerpoint is inside a grid square
    func flagSquare(sender: SquareButton) {
        if !sender.square.isFlagged && !sender.square.isOpen {
            sender.square.isFlagged = true
            sender.setImage(UIImage(named: "flagged")!, forState: .Normal)
            countFlags++
        }
    }
    
    // Triggered by a long tap on a square
    func removeFlag(gestureReconizer: UILongPressGestureRecognizer) {
        for row in buttonArray {
            for button in row {
                if button.square.isFlagged && button.frame == gestureReconizer.view!.frame {
                    button.setImage(UIImage(named: "unopened")!, forState: .Normal)
                    button.square.isFlagged = false
                    countFlags--
                }
            }
        }
    }
    
    // Increment the second counter every second
    func oneSecond() {
        countSeconds++
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}