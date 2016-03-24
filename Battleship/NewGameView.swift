//
//  NewGameView.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//view used to gather player name and sets up a new game
class NewGameView: UIView {

    var _startButton: UIButton = UIButton()
    var _firstPlayerLabel: UILabel = UILabel()
    var _secondPlayerLabel: UILabel = UILabel()
    var _playerOneTextBox: UITextField! =  UITextField()
    var _playerTwoTextBox: UITextField! = UITextField()
    
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
        _firstPlayerLabel.text = "Player1 Name :"
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
        _secondPlayerLabel.text = "Player2 Name :"
        _secondPlayerLabel.textColor = .whiteColor()
        addSubview(_secondPlayerLabel)

        //second players text box
        _playerTwoTextBox.placeholder = "Player2"
        _playerTwoTextBox.backgroundColor = .whiteColor()
        _playerTwoTextBox.layer.borderWidth = 3
        _playerTwoTextBox.layer.cornerRadius = 5
        _playerTwoTextBox.textAlignment = .Center
        _playerTwoTextBox.clearButtonMode = .Always
        addSubview(_playerTwoTextBox)

        //start button
        _startButton.setTitle("Start Game", forState: UIControlState.Normal)
        _startButton.backgroundColor = .redColor()
        _startButton.layer.cornerRadius = 10
        addSubview(_startButton)

    }
    
    //keep game looking good for all orientations
    override func layoutSubviews() {
        if(bounds.height > bounds.width) {
            _firstPlayerLabel.frame = CGRectMake(self.bounds.width / 2 - 100, 90, 200, 20)
            _playerOneTextBox.frame = CGRectMake(self.bounds.width / 2 - 100, 120, 200, 50)
            _secondPlayerLabel.frame = CGRectMake(self.bounds.width / 2 - 100, 190, 200, 20)
            _playerTwoTextBox.frame = CGRectMake(self.bounds.width / 2 - 100, 220, 200, 50)
            _startButton.frame = CGRectMake(self.bounds.width / 2 - 100, 350, 200, 60)
        }
        else {
            _firstPlayerLabel.frame = CGRectMake(self.bounds.width / 2 - 100, 15, 200, 20)
            _playerOneTextBox.frame = CGRectMake(self.bounds.width / 2 - 100, 40, 200, 50)
            _secondPlayerLabel.frame = CGRectMake(self.bounds.width / 2 - 100, 100, 200, 20)
            _playerTwoTextBox.frame = CGRectMake(self.bounds.width / 2 - 100, 125, 200, 50)
            _startButton.frame = CGRectMake(self.bounds.width / 2 - 100, 200, 200, 60)
        }
    }
    
    var start: UIButton {
        return _startButton
    }
    
}
