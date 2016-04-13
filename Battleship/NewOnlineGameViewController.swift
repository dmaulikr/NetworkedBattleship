//
//  NewOnlineGameViewController.swift
//  Battleship
//
//  Created by Jordan Davis on 4/2/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//controlls the new game view
class NewOnlineGameViewController: UIViewController, UITextFieldDelegate {
    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance
    
    var newGameView: NewOnlineGameView {
        return view as! NewOnlineGameView
    }
    
    override func loadView() {
        view = NewOnlineGameView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        newGameView.start.addTarget(self, action: #selector(NewOnlineGameViewController.StartGame), forControlEvents: UIControlEvents.TouchDown)
        newGameView._playerOneTextBox.delegate = self
        newGameView._gameNameTextBox.delegate = self
    }
    
    //starts a new game with given player names and go to game controller.
    func StartGame()
    {
        var playerOne: String = newGameView._playerOneTextBox.text!
        var gameName: String = newGameView._gameNameTextBox.text!
        
        //make sure names are valid, non empty, and not the same
        if(playerOne == ""){
            playerOne = "Player1"
        }
        if(gameName == ""){
            gameName = "Battleship"
        }
        
        _collection.NetworkCreateNewGame(gameName, playerId: playerOne)
        _collection.currentOnlineGameDetail.name = gameName
        _collection.currentOnlineGameDetail.player1 = playerOne
        _collection.currentOnlineGameDetail.missilesLaunched = 0
        _collection.currentOnlineGameDetail.player2 = ""
        _collection.currentOnlineGameDetail.winner = "IN PROGRESS"        
        navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
    //allows 'return' button to exit the textbox and submit
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        newGameView._playerOneTextBox.resignFirstResponder()
        newGameView._gameNameTextBox.resignFirstResponder()
        return true
    }
    
}