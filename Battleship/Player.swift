//
//  Player.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//player object. each player has these attributes
class Player {
    var name: String = ""
    var isPlayersTurn: Bool = false
    var hits: [String] = [String]()
    var misses: [String] = [String]()
    var shots: Int = 0
    var board: GameBoard = GameBoard()
    
    //calculates hitCount
    var hitCount: Int {
        return hits.count
    }
    
    //calculates missCount
    var missCount: Int {
        return misses.count
    }

}
