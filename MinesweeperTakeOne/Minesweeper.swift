//
//  Minesweeper.swift
//  MinesweeperTakeOne
//
//  Created by Vincent Polidoro on 12/27/15.
//  Copyright © 2015 Vincent Polidoro. All rights reserved.
//

import Darwin

struct Square {
    var bombsAdjacent: Int
    var displayString: String
    var isOpen: Bool
    var isBomb: Bool
    var isFlagged: Bool
    var squaresAdjacent: [(Int, Int)]
    
    init(adjacentSquares: Int) {
        isOpen = false
        isFlagged = false
        isBomb = false
        displayString = "unopened"
        bombsAdjacent = Int()
        squaresAdjacent = []
    }
    
    // Return the character representation of the square
    var description: String {
        if isOpen && isBomb{
            return "mine"
        } else if isFlagged {
            return "flagged"
        } else if isOpen {
            return String(bombsAdjacent)
        } else {
            return("unopened")
        }
    }
}

class Board {
    var board: [[Square]]
    var flaggedBombs: Int
    let boardHeight: Int
    let boardWidth: Int
    let bombCount: Int
    var countOpenedSquares = 0
    
    init(width: Int, height: Int, bombs: Int) {
        // Need to save these properties to validate coordinates and set win condition
        boardHeight = height
        boardWidth = width
        bombCount = bombs
        flaggedBombs = 0
        
        // Each row is an array of squares
        // The board is an array of rows
        let squareTemplate = Square(adjacentSquares: 0)
        let rowTemplate = [Square](count: width, repeatedValue: squareTemplate)
        board = [[Square]](count: height, repeatedValue: rowTemplate)
        
        // Randomly place the bombs, then set the count for each square
        placeBombs()
        setBombCounts()
    }
    
    // Populate the board with bombs
    func placeBombs() {
        var bombsToPlace = UInt32(self.bombCount)
        var totalSquares = UInt32((self.boardWidth) * (self.boardHeight))
        
        // Decide if there should be a bomb on the square
        for row in 0..<boardHeight {
            for col in 0..<boardWidth {
                let bombRandomizer = arc4random_uniform(UInt32(totalSquares))+1
                if bombRandomizer <= bombsToPlace {
                    board[row][col].isBomb = true
                    bombsToPlace--
                }
                totalSquares--
            }
        }
    }
    
    func checkWin() -> Bool {
        return (countOpenedSquares == boardHeight * boardWidth - bombCount)
    }
    
    // Check an array of squares and return the number of mines
    func countBombs(adjacentSquares: [Square]) -> Int {
        var count = 0
        
        for adjacentSquare in adjacentSquares {
            if adjacentSquare.isBomb {
                count += 1
            }
        }
        
        return count
    }
    
    func setBombCounts() {
        
        // Cycle through each square to count the adjacent mines
        for row in 0..<boardHeight {
            for col in 0..<boardWidth {
                
                // Create an array of adjacent squares to be checked for bombs
                var adjacentSquares: [Square] = []
                
                // Conditionals to avoid out of bounds errors
                // Also store valid adjacent square index deltas for later use
                // TODO: Find more Swifty or concise way to handle
                if row > 0 && col > 0 {
                    adjacentSquares.append(board[row-1][col-1])
                    board[row][col].squaresAdjacent.append((-1,-1))
                }
                
                if row > 0 {
                    adjacentSquares.append(board[row-1][col])
                    board[row][col].squaresAdjacent.append((-1,0))
                }
                
                if row > 0 && col < (boardWidth - 1) {
                    adjacentSquares.append(board[row-1][col+1])
                    board[row][col].squaresAdjacent.append((-1,+1))
                }
                
                if col > 0 {
                    adjacentSquares.append(board[row][col-1])
                    board[row][col].squaresAdjacent.append((0,-1))
                }
                
                if col < (boardWidth - 1) {
                    adjacentSquares.append(board[row][col+1])
                    board[row][col].squaresAdjacent.append((0,+1))
                }
                
                if row < (boardHeight - 1) && col > 0 {
                    adjacentSquares.append(board[row+1][col-1])
                    board[row][col].squaresAdjacent.append((+1,-1))
                }
                
                if row < (boardHeight - 1) {
                    adjacentSquares.append(board[row+1][col])
                    board[row][col].squaresAdjacent.append((+1,0))
                }
                
                if row < (boardHeight - 1) && col < (boardWidth - 1) {
                    adjacentSquares.append(board[row+1][col+1])
                    board[row][col].squaresAdjacent.append((+1,+1))
                }
                
                board[row][col].bombsAdjacent = countBombs(adjacentSquares)
            }
        }
    }
}