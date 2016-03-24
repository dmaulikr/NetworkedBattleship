//
//  BattleshipGame.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//all the info you need for a single game of battleship
class BattleshipGame{

    var _firstPlayer: Player = Player()
    var _secondPlayer: Player = Player()
    var _gameOver: Bool = false
    var winner: String = "N/A"
    var currentPlayersTurn: String = ""
    
    //initializer
    init(firstPlayerName: String, secondPlayerName: String) {
        _firstPlayer.name = firstPlayerName
        _secondPlayer.name = secondPlayerName
        
        switchPlayerTurns()
        
        _firstPlayer.board.randomize()
        _secondPlayer.board.randomize()
    }
    
    //helper method to play a move
    func playMoveAtLocation(row: Int, column:Int, value:Int) {
        if(_firstPlayer.isPlayersTurn && !_secondPlayer.isPlayersTurn){
            _secondPlayer.board._map.updateLocation(column, row: row, value: value)
        }
        else if (!_firstPlayer.isPlayersTurn && _secondPlayer.isPlayersTurn){
            _firstPlayer.board._map.updateLocation(column, row: row, value: value)
        }
        else{
            _secondPlayer.board._map.updateLocation(column, row: row, value: value)
        }
    }
    
    //helper method to alternate player turns
    func switchPlayerTurns(){
        if(_firstPlayer.shots <= _secondPlayer.shots) {
            _firstPlayer.isPlayersTurn = true
            _secondPlayer.isPlayersTurn = false
            currentPlayersTurn = _firstPlayer.name
        }
        else if _firstPlayer.isPlayersTurn {
            _firstPlayer.isPlayersTurn = false
            _secondPlayer.isPlayersTurn = true
            currentPlayersTurn = _secondPlayer.name
        }
    }
}