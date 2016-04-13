//
//  JoinOnlineGameView.swift
//  Battleship
//
//  Created by Jordan Davis on 4/2/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//view used to gather player name and sets up a new game
class JoinOnlineGameView: UIView {
    
    var _joinGameButton: UIButton = UIButton()
    var _firstPlayerLabel: UILabel = UILabel()
    var _playerOneTextBox: UITextField! =  UITextField()
    
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
        _playerOneTextBox.placeholder = "Player2"
        _playerOneTextBox.backgroundColor = .whiteColor()
        _playerOneTextBox.layer.borderWidth = 3
        _playerOneTextBox.layer.cornerRadius = 5
        _playerOneTextBox.textAlignment = .Center
        _playerOneTextBox.clearButtonMode = .Always
        addSubview(_playerOneTextBox)
        
        //start button
        _joinGameButton.setTitle("Join Game", forState: UIControlState.Normal)
        _joinGameButton.backgroundColor = .redColor()
        _joinGameButton.layer.cornerRadius = 10
        addSubview(_joinGameButton)
        
    }
    
    //keep game looking good for all orientations
    override func layoutSubviews() {
        if(bounds.height > bounds.width) {
            _firstPlayerLabel.frame = CGRectMake(self.bounds.width / 2 - 100, 90, 200, 20)
            _playerOneTextBox.frame = CGRectMake(self.bounds.width / 2 - 100, 120, 200, 50)
            _joinGameButton.frame = CGRectMake(self.bounds.width / 2 - 100, 350, 200, 60)
        }
        else {
            _firstPlayerLabel.frame = CGRectMake(self.bounds.width / 2 - 100, 15, 200, 20)
            _playerOneTextBox.frame = CGRectMake(self.bounds.width / 2 - 100, 40, 200, 50)
            _joinGameButton.frame = CGRectMake(self.bounds.width / 2 - 100, 200, 200, 60)
        }
    }
    
    var start: UIButton {
        return _joinGameButton
    }
    
}
