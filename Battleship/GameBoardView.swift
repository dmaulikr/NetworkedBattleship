//
//  GameBoardView.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//entire game board view with both player and opponent grids. as well as stats.
class GameBoardView: UIView {
    
    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance
    
    var playerShips: GridView!
    var opponentShips: GridView!
    var fireButton: UIButton!
    var shotsCountLabel: UILabel = UILabel()
    var shipsRemainingLabel: UILabel = UILabel()
    var hitCountLabel: UILabel = UILabel()
    var missCountLabel: UILabel = UILabel()
    private var _currentGrid: GameBoard?
    private var _opponentGrid: GameBoard?
    
    init(frame: CGRect, currentGrid: GameBoard, opponentGrid: GameBoard) {
        super.init(frame: CGRect())
        
        _currentGrid = currentGrid      //player ships show here
        _opponentGrid = opponentGrid    //ships are hidden here

        //player grid. not touchable but ships are visible.
        playerShips = GridView(frame: CGRectMake(10, 10, frame.width / 2, frame.width / 2), board: currentGrid, touchable: false)
        addSubview(playerShips)

        //opponent grid. touchable. but ships are NOT visible.
        opponentShips = GridView(frame: CGRectMake(10, (frame.width / 4) + 110 , frame.width - 20, frame.width - 20), board: opponentGrid, touchable: true)
        addSubview(opponentShips)
        
        //button for launching missle
        fireButton = UIButton()
        fireButton.addTarget(superview, action: "launchMissle:", forControlEvents: UIControlEvents.TouchDown)
        fireButton.backgroundColor = .redColor()
        fireButton.layer.cornerRadius = 10
        fireButton.setTitle("Launch", forState: UIControlState.Normal)
        fireButton.frame = CGRectMake(190, (frame.width / 2) - 30, frame.width / 3, 40)
        addSubview(fireButton)
        
        if(!_collection.online){
        //stats
        shipsRemainingLabel.text = "Enemy Lives: 17"
        shipsRemainingLabel.textColor = .whiteColor()
        shipsRemainingLabel.font = UIFont.systemFontOfSize(12.0)
        addSubview(shipsRemainingLabel)
        
        shotsCountLabel.text = "Shots Fired: 0"
        shotsCountLabel.textColor = .whiteColor()
        shotsCountLabel.font = UIFont.systemFontOfSize(12.0)
        addSubview(shotsCountLabel)
        
        hitCountLabel.text = "Hits: 0"
        hitCountLabel.textColor = .whiteColor()
        hitCountLabel.font = UIFont.systemFontOfSize(12.0)
        addSubview(hitCountLabel)
        
        missCountLabel.text = "Misses: 0"
        missCountLabel.textColor = .whiteColor()
        missCountLabel.font = UIFont.systemFontOfSize(12.0)
        addSubview(missCountLabel)
        } else if (!_collection._continueOldGame){
            shipsRemainingLabel.text = "Enemy Lives:"
            shipsRemainingLabel.textColor = .whiteColor()
            shipsRemainingLabel.font = UIFont.systemFontOfSize(18.0)
            addSubview(shipsRemainingLabel)
            
            shotsCountLabel.text = "17"
            shotsCountLabel.textColor = .whiteColor()
            shotsCountLabel.font = UIFont.systemFontOfSize(18.0)
            addSubview(shotsCountLabel)
        } else {
//            shipsRemainingLabel.text = "Missiles Launched:"
//            shipsRemainingLabel.textColor = .whiteColor()
//            shipsRemainingLabel.font = UIFont.systemFontOfSize(18.0)
//            addSubview(shipsRemainingLabel)
//            
//            shotsCountLabel.text = "0"
//            shotsCountLabel.textColor = .whiteColor()
//            shotsCountLabel.font = UIFont.systemFontOfSize(18.0)
//            addSubview(shotsCountLabel)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    //keep view looking good on the screen
    override func layoutSubviews() {
        if(bounds.height > bounds.width) {
            playerShips.removeFromSuperview()
            opponentShips.removeFromSuperview()
            
            playerShips = GridView(frame: CGRectMake(10, 10, frame.width / 2, frame.width / 2), board: _currentGrid!, touchable: false)
            
            opponentShips = GridView(frame: CGRectMake(10, (frame.width / 4) + 110 , frame.width - 20, frame.width - 20), board: _opponentGrid!, touchable: true)
            
            fireButton.frame = CGRectMake(190, (frame.width / 2) - 30, frame.width / 3, 40)
            
            if(!_collection.online){

            shipsRemainingLabel.frame = CGRectMake(190, 10, frame.width / 3 + 10, 15)
            shotsCountLabel.frame = CGRectMake(190, 40, frame.width / 3 + 10, 15)
            hitCountLabel.frame = CGRectMake(190, 70, frame.width / 3 + 10, 15)
            missCountLabel.frame = CGRectMake(190, 100, frame.width / 3 + 10, 15)
            } else {
                shipsRemainingLabel.frame = CGRectMake(190, 40, frame.width / 3 + 10, 15)
                shotsCountLabel.frame = CGRectMake(230, 70, frame.width / 3 + 10, 15)

            }
            addSubview(playerShips)
            addSubview(opponentShips)
        }
        else {
            playerShips.removeFromSuperview()
            opponentShips.removeFromSuperview()
            
            playerShips = GridView(frame: CGRectMake(20, 10, frame.height / 1.5, frame.height / 1.5), board: _currentGrid!, touchable: false)
            
            opponentShips = GridView(frame: CGRectMake(frame.width - frame.height, 10, frame.height - 20, frame.height - 20), board: _opponentGrid!, touchable: true)
            
            fireButton.frame = CGRectMake(20, (frame.height / 1.5) + 30, frame.height / 3, 40)
            if(!_collection.online){

            shipsRemainingLabel.frame = CGRectMake(30 + frame.height/3, (frame.height / 1.5) + 20, frame.height / 3 + 20, 15)
            shotsCountLabel.frame = CGRectMake(30 + frame.height/3, (frame.height / 1.5) + 35, frame.height / 3 + 20, 15)
            hitCountLabel.frame = CGRectMake(30 + frame.height/3, (frame.height / 1.5) + 50, frame.height / 3 + 20, 15)
            missCountLabel.frame = CGRectMake(30 + frame.height/3, (frame.height / 1.5) + 65, frame.height / 3 + 20, 15)
            } else {
                shipsRemainingLabel.frame = CGRectMake(30 + frame.height/3, (frame.height / 1.5) + 20, frame.height / 3 + 20, 15)
                shotsCountLabel.frame = CGRectMake(30 + frame.height/3 + 40, (frame.height / 1.5) + 50, frame.height / 3 + 20, 15)

            }
            addSubview(playerShips)
            addSubview(opponentShips)
        }
    }
}
