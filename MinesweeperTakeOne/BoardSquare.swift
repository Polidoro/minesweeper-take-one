//
//  BoardSquare.swift
//  MinesweeperTakeOne
//
//  Created by Vincent Polidoro on 12/28/15.
//  Copyright © 2015 Vincent Polidoro. All rights reserved.
//

import Foundation

class BoardSquare {
    let row: Int
    let col: Int
    let square: Square
    
    init(row: Int, col: Int, square: Square) {
        self.row = row
        self.col = col
        self.square = square
    }
}