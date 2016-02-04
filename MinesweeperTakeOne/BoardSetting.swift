//
//  BoardSetting.swift
//  MinesweeperTakeOne
//
//  Created by Vincent Polidoro on 2/4/16.
//  Copyright © 2016 Vincent Polidoro. All rights reserved.
//

import Foundation


struct BoardSetting: CustomStringConvertible {
    var boardName: String
    var boardWidth: Int
    var boardHeight: Int
    var bombCount: Int
    
    init(name: String, width: Int, height: Int, bombs: Int) {
        boardName = name
        boardWidth = width
        boardHeight = height
        bombCount = bombs
    }
    
    var description: String {
        return "\(boardName) - Width: \(boardWidth), Height: \(boardHeight), Bombs: \(bombCount)"
    }
}
