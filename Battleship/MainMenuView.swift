//
//  MainMenuView.swift
//  Battleship
//
//  Created by Jordan Davis on 4/2/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//view used to gather player name and sets up a new game
class GameTypeView: UIView {
    
    private var _localGameButton: UIButton = UIButton()
    private var _onlineGameButton: UIButton = UIButton()
    private var _myOnlineGameButton: UIButton = UIButton()


    
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
        
        //local button
        _localGameButton.setTitle("Local Lobby", forState: UIControlState.Normal)
        _localGameButton.backgroundColor = .redColor()
        _localGameButton.layer.cornerRadius = 10
        addSubview(_localGameButton)
        
        //online button
        _onlineGameButton.setTitle("Online Lobby", forState: UIControlState.Normal)
        _onlineGameButton.backgroundColor = .redColor()
        _onlineGameButton.layer.cornerRadius = 10
        addSubview(_onlineGameButton)
        
        //online button
        _myOnlineGameButton.setTitle("My Online Games", forState: UIControlState.Normal)
        _myOnlineGameButton.backgroundColor = .redColor()
        _myOnlineGameButton.layer.cornerRadius = 10
        addSubview(_myOnlineGameButton)
        
    }
    
    //keep game looking good for all orientations
    override func layoutSubviews() {
        if(bounds.height > bounds.width) {
            _localGameButton.frame = CGRectMake(self.bounds.width / 2 - 100, (self.bounds.height / 3) - 30, 200, 60)
            _onlineGameButton.frame = CGRectMake(self.bounds.width / 2 - 100, (self.bounds.height / 2 ) - 30, 200, 60)
            _myOnlineGameButton.frame = CGRectMake(self.bounds.width / 2 - 100, (self.bounds.height / 1.5) - 30, 200, 60)
        }
        else {
            _localGameButton.frame = CGRectMake(self.bounds.width / 2 - 100, 30, 200, 60)
            _onlineGameButton.frame = CGRectMake(self.bounds.width / 2 - 100, (self.bounds.height / 2 ) - 30, 200, 60)
            _myOnlineGameButton.frame = CGRectMake(self.bounds.width / 2 - 100, (self.bounds.height) - 90, 200, 60)
        }
    }
    
    var startLocal: UIButton {
        return _localGameButton
    }
    
    var startOnline: UIButton {
        return _onlineGameButton
    }
    
    var startMyOnline: UIButton {
        return _myOnlineGameButton
    }

}
