//
//  JoinOnlineGameViewController.swift
//  Battleship
//
//  Created by Jordan Davis on 4/3/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit


//controlls the new game view
class JoinOnlineGameViewController: UIViewController, UITextFieldDelegate {
    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance

    
    var newGameView: JoinOnlineGameView {
        return view as! JoinOnlineGameView
    }
    
    override func loadView() {
        view = JoinOnlineGameView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        newGameView.start.addTarget(self, action: #selector(JoinOnlineGameViewController.StartGame), forControlEvents: UIControlEvents.TouchDown)
        newGameView._playerOneTextBox.delegate = self
    }
    
    //starts a new game with given player names and go to game controller.
    func StartGame()
    {
        var playerTwo: String = newGameView._playerOneTextBox.text!
        
        //make sure names are valid, non empty, and not the same
        if(playerTwo == ""){
            playerTwo = "Player2"
        }

        
        _collection.NetworkJoinGame(_collection.currentOnlineGameDetail.id, playerName: playerTwo)
        _collection.currentOnlineGameDetail.player2 = playerTwo
        _collection.currentOnlineGameDetail.winner = "IN PROGRESS"
        navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
    //allows 'return' button to exit the textbox and submit
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        newGameView._playerOneTextBox.resignFirstResponder()
        return true
    }
    

}