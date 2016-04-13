//
//  NewOnlineGameView.swift
//  Battleship
//
//  Created by Jordan Davis on 4/1/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//view used to gather player name and sets up a new game
class NewOnlineGameView: UIView {
    
    var _createGameButton: UIButton = UIButton()
    var _firstPlayerLabel: UILabel = UILabel()
    var _gameTitleLabel: UILabel = UILabel()
    var _playerOneTextBox: UITextField! =  UITextField()
    var _gameNameTextBox: UITextField! = UITextField()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //allow user to touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        
        self.backgroundColor = UIColor.lightGrayColor()
        
        //first player label
        _firstPlayerLabel.text = "Your Name :"
        _firstPlayerLabel.textColor = .whiteColor()
        addSubview(_firstPlayerLabel)
        
        //first players text box
        _playerOneTextBox.placeholder = "Player1"
        _playerOneTextBox.backgroundColor = .whiteColor()
        _playerOneTextBox.layer.borderWidth = 3
        _playerOneTextBox.layer.cornerRadius = 5
        _playerOneTextBox.textAlignment = .Center
        _playerOneTextBox.clearButtonMode = .Always
        addSubview(_playerOneTextBox)
        
        //second player label
        _gameTitleLabel.text = "Game Title :"
        _gameTitleLabel.textColor = .whiteColor()
        addSubview(_gameTitleLabel)
        
        //second players text box
        _gameNameTextBox.placeholder = "Battleship"
        _gameNameTextBox.backgroundColor = .whiteColor()
        _gameNameTextBox.layer.borderWidth = 3
        _gameNameTextBox.layer.cornerRadius = 5
        _gameNameTextBox.textAlignment = .Center
        _gameNameTextBox.clearButtonMode = .Always
        addSubview(_gameNameTextBox)
        
        //start button
        _createGameButton.setTitle("Create Game", forState: UIControlState.Normal)
        _createGameButton.backgroundColor = .redColor()
        _createGameButton.layer.cornerRadius = 10
        addSubview(_createGameButton)
        
    }
    
    //keep game looking good for all orientations
    override func layoutSubviews() {
        if(bounds.height > bounds.width) {
            _firstPlayerLabel.frame = CGRectMake(self.bounds.width / 2 - 100, 90, 200, 20)
            _playerOneTextBox.frame = CGRectMake(self.bounds.width / 2 - 100, 120, 200, 50)
            _gameTitleLabel.frame = CGRectMake(self.bounds.width / 2 - 100, 190, 200, 20)
            _gameNameTextBox.frame = CGRectMake(self.bounds.width / 2 - 100, 220, 200, 50)
            _createGameButton.frame = CGRectMake(self.bounds.width / 2 - 100, 350, 200, 60)
        }
        else {
            _firstPlayerLabel.frame = CGRectMake(self.bounds.width / 2 - 100, 15, 200, 20)
            _playerOneTextBox.frame = CGRectMake(self.bounds.width / 2 - 100, 40, 200, 50)
            _gameTitleLabel.frame = CGRectMake(self.bounds.width / 2 - 100, 100, 200, 20)
            _gameNameTextBox.frame = CGRectMake(self.bounds.width / 2 - 100, 125, 200, 50)
            _createGameButton.frame = CGRectMake(self.bounds.width / 2 - 100, 200, 200, 60)
        }
    }
    
    var start: UIButton {
        return _createGameButton
    }
    
}
