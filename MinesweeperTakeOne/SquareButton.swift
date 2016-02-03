//
//  SquareButton.swift
//  MinesweeperTakeOne
//
//  Created by Vincent Polidoro on 12/28/15.
//  Copyright © 2015 Vincent Polidoro. All rights reserved.
//

import UIKit

class SquareButton: UIButton {
    let row: Int?
    let col: Int?
    var square: Square
    
    init(theSquare: Square, rect: CGRect, row: Int, col: Int) {
        self.square = theSquare
        self.col = col
        self.row = row
        
        super.init(frame: rect)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError(("init(coder:) has not been implemented"))
    }
}
