//
//  NewGameViewController.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//controlls the new game view
class NewGameViewController: UIViewController, UITextFieldDelegate {
    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance
    
    var newGameView: NewGameView {
        return view as! NewGameView
    }
    
    override func loadView() {
        view = NewGameView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        newGameView.start.addTarget(self, action: "StartGame", forControlEvents: UIControlEvents.TouchDown)
        newGameView._playerOneTextBox.delegate = self
        newGameView._playerTwoTextBox.delegate = self
    }
    
    //starts a new game with given player names and go to game controller.
    func StartGame()
    {
        var playerOne: String = newGameView._playerOneTextBox.text!
        var playerTwo: String = newGameView._playerTwoTextBox.text!
        
        //make sure names are valid, non empty, and not the same
        if(playerOne == ""){
            playerOne = "Player1"
        }
        if(playerTwo == ""){
            playerTwo = "Player2"
        }
        if(playerOne == playerTwo){
            playerOne = playerOne + "1"
            playerTwo = playerTwo + "2"
        }

        _collection.startNewGame(playerOne, playerTwo: playerTwo)
        navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
    //allows 'return' button to exit the textbox and submit
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        newGameView._playerOneTextBox.resignFirstResponder()
        newGameView._playerTwoTextBox.resignFirstResponder()
        return true
    }
    
}