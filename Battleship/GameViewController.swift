//
//  GameViewController.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//controlls gameplay. bulk of application.
class GameViewController: UIViewController, UIAlertViewDelegate {
    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance
    private var _playerOneView: GameBoardView?
    private var _playerTwoView: GameBoardView?
    private var _playerOneLastFire: (row: Int, column: Int) = (-1,-1)
    private var _playerTwoLastFire: (row: Int, column: Int) = (-1,-1)
    private var alertMessage: UIAlertView = UIAlertView()
    private var exit: Bool = false
    private var cycleCount: Int = 0
    private var onlineShotsFired = 0
    private var initbool = true
    private var timer = NSTimer()
    
    
    //MARK: -CONTROLLS
    var gameView: UIView {
        return view as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        let qexit: UIBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(GameViewController.returnToMenu))
        self.navigationItem.leftBarButtonItem = qexit
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.alertMessage.addButtonWithTitle("Afirmative")
        
        if(!_collection.online){ //setup local hot seat
            _playerOneView = GameBoardView(frame: view.bounds, currentGrid: _collection.getCurrentGame()._firstPlayer.board, opponentGrid: _collection.getCurrentGame()._secondPlayer.board)
            _playerTwoView = GameBoardView(frame: view.bounds, currentGrid: _collection.getCurrentGame()._secondPlayer.board, opponentGrid: _collection.getCurrentGame()._firstPlayer.board)
            selectView()

        } else { //setup online
            _playerOneView = GameBoardView(frame: view.bounds, currentGrid: _collection.OnlinePlayerGameBoard, opponentGrid:_collection.OnlineOpponentGameBoard)
            _playerTwoView = GameBoardView(frame: view.bounds, currentGrid: _collection.OnlineOpponentGameBoard, opponentGrid:_collection.OnlinePlayerGameBoard)
            view = (_playerOneView!)
            self.view.backgroundColor = .lightGrayColor()

            if(_collection._onlineCurrentGameWinner == "IN PROGRESS"){
                if(_collection._onlineIsMyTurn == 0){
                    self.title = "Waiting for Opponent"
                } else {
                    self.title = "Fire away!"
                }
            } else {
                self.title = "\(_collection._onlineCurrentGameWinner)"
            }
            selectView()

            _playerOneView?.layoutSubviews()
            _playerTwoView?.layoutSubviews()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameViewController.refresh), userInfo: nil, repeats: true)
            
        }
        
    }
    
    func refresh(){

        _collection.NetworkIsPlayersTurn(_collection.currentOnlineGameId, playerId: _collection.currentOnlinePlayerId)
        _collection.NetworkRequestPlayersBoard(_collection.currentOnlineGameId, playerId: _collection.currentOnlinePlayerId)
        
        _playerOneView?.setNeedsDisplay()
        if(_collection._onlineCurrentGameWinner == "IN PROGRESS"){
            if(_collection._onlineIsMyTurn == 0){
                self.title = "Waiting for Opponent"
                if (cycleCount >= 1){
                    _playerOneView?.layoutSubviews()
                    _playerTwoView?.layoutSubviews()
                }
                if(cycleCount > 2){
                    cycleCount = 0
                } else {
                    cycleCount++
                }
            } else {
                self.title = "Fire away!"
                if (cycleCount == 0){
                    _playerOneView?.layoutSubviews()
                    _playerTwoView?.layoutSubviews()
                }
                cycleCount += 1
            }
        } else {
            alertMessage.title = "\(_collection._onlineCurrentGameWinner) is Victorious"
            alertMessage.show()
            returnToMenu()
        }
        
        selectView()

        gameView.setNeedsDisplay()
        if(exit){
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    
    //makes sure game is updated and correct view is showing
    override func viewWillAppear(animated: Bool) {
        selectView()
        updateLabels()
        _playerOneView?.setNeedsDisplay()
        _playerTwoView?.setNeedsDisplay()
    }
    
    //determines which game view to show depending on who's turn it is.
    private func selectView() {
        if(!_collection.online){
            if(_collection.getCurrentGame()._firstPlayer.isPlayersTurn){
                view = (_playerOneView!)
            }
            else{
                view = (_playerTwoView!)
            }
            self.title = "\(_collection.getCurrentGame().currentPlayersTurn)'s Turn"
        }
        if(initbool){
            _playerOneView?.layoutSubviews()
            _playerTwoView?.layoutSubviews()
            initbool = false
        }

        updateLabels()
        self.view.backgroundColor = .lightGrayColor()
        _collection.writeToFile()
    }
    
    //menu button returns us to the collection view
    func returnToMenu(){
        if(_collection.online){
            exit = true
            timer.invalidate()
            _collection.NetworkRequestGameList()
            _collection.OnlinePlayerGameBoard = GameBoard()
            _collection.OnlineOpponentGameBoard = GameBoard()
        }

        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: - ACTIONS
    //gets location from the button selected, gets info from data model about location
    //determines if shot was a hit or miss and updates game accordingly.
    // 0 = miss, 1 = hit, 2 = water, 3 = ship 4 = highlighted
    func launchMissle(sender: UIButton){
        
        if(!_collection.online) { //LOCAL
            if(_collection.getCurrentGame()._firstPlayer.isPlayersTurn) {
                if !playerOneFiredMissle() {
                    return
                }
            } else {
                if !playerTwoFiredMissle() {
                    return
                }
            }
            
            self._playerTwoView?.setNeedsDisplay()
            self._playerOneView?.setNeedsDisplay()
            
            _collection.getCurrentGame().switchPlayerTurns()
            _collection.writeToFile()
            if(!_collection.getCurrentGame()._gameOver){
                presentViewController(InBetweenMovesController(), animated: false, completion: nil)
            }
        } else { //ONLINE
            if(_collection._onlineIsMyTurn == 1) {
                playerOneFiredMissle()
                onlineShotsFired += 1
            }
        }
        
    }
    
    //helper method specific to playerOne's view
    func playerOneFiredMissle() -> Bool{
        
        //make sure selected button is not nil
        if(_playerOneView?.opponentShips._highlightedButtonLocation == nil){
            return false
        }
        
        //get location information
        let location = _playerOneView?.opponentShips.buttonTouched
        let rowShotLocation: Int = location!.row
        let columnShotLocation: Int = location!.column
        
        //make sure button is not previous button
        if(rowShotLocation == _playerOneLastFire.row && columnShotLocation == _playerOneLastFire.column){
            return false
        }
        else{
            _playerOneLastFire = (rowShotLocation, columnShotLocation)
        }
        if(_collection.online){
            _collection.NetworkMakeAGuess(_collection.currentOnlineGameId, playerId: _collection.currentOnlinePlayerId, xPos: "\(columnShotLocation)", yPos: "\(rowShotLocation)" )
            
            self._playerOneView!.opponentShips.buttonTouched((row: rowShotLocation, column: columnShotLocation), with: _collection._lastMove)
            _collection.writeToFile()
            return true;
            
        } else {
        
        
            //get location value from data member
            let locationValue = _collection.getCurrentGame()._secondPlayer.board._map.getLocationInformation(columnShotLocation, row: rowShotLocation)
            
            if locationValue == 2 {
                //update view for a miss
                self._playerOneView!.opponentShips.buttonTouched((row: rowShotLocation, column: columnShotLocation), with: 0)
                self._playerOneView!.playerShips.buttonTouched((row: rowShotLocation, column: columnShotLocation), with: 0)
                
                //update model
                _collection.updateMove(rowShotLocation, column: columnShotLocation, value: 0)
                _collection.getCurrentGame()._firstPlayer.misses.append("\(columnShotLocation)\(rowShotLocation))")
                _collection.getCurrentGame()._firstPlayer.shots += 1
            }
            else if locationValue == 3 {
                //update view for a hit
                self._playerOneView!.opponentShips.buttonTouched((row: rowShotLocation, column: columnShotLocation), with: 1)
                self._playerOneView?.playerShips.buttonTouched((row: rowShotLocation, column: columnShotLocation), with: 1)
                
                //update model
                _collection.updateMove(rowShotLocation, column: columnShotLocation, value: 1)
                _collection.getCurrentGame()._firstPlayer.hits.append("\(columnShotLocation)\(rowShotLocation))")
                _collection.getCurrentGame()._firstPlayer.shots += 1
                
                //show hit message / show victory message
                if(_collection.getCurrentGame()._firstPlayer.hitCount == 17){
                    let name: String = _collection.getCurrentGame()._firstPlayer.name
                    alertMessage.title = "\(name) is victorious!"
                    alertMessage.show()
                    _collection.getCurrentGame().winner = name
                    _collection.getCurrentGame()._gameOver = true
                    _collection.writeToFile()
                    returnToMenu()
                }
                else{
                    alertMessage.title = "BANG"
                    alertMessage.show()
                }

        }else {
            print("Game board is not in valid state")
        }
        return true
        }

    }
    
    //helper method specific to playerTwo's view
    func playerTwoFiredMissle() -> Bool{
        //make sure button is not nil
        if(_playerTwoView?.opponentShips._highlightedButtonLocation == nil){
            return false
        }
        
        //get selected button info
        let location = _playerTwoView?.opponentShips.buttonTouched
        let rowShotLocation: Int = location!.row
        let columnShotLocation: Int = location!.column
        
        //make sure button is not the previous button.
        if(rowShotLocation == _playerTwoLastFire.row && columnShotLocation == _playerTwoLastFire.column){
            return false
        }
        else{
            _playerTwoLastFire = (rowShotLocation, columnShotLocation)
        }
        
        //get location value from data member
        let locationValue = _collection.getCurrentGame()._firstPlayer.board._map.getLocationInformation(columnShotLocation, row: rowShotLocation)
        
        if locationValue == 2 {
            //update view for a miss
            self._playerTwoView!.opponentShips.buttonTouched((row: rowShotLocation, column: columnShotLocation), with: 0)
            self._playerOneView!.playerShips.buttonTouched((row: rowShotLocation, column: columnShotLocation), with: 0)
            
            //update model
            _collection.updateMove(rowShotLocation, column: columnShotLocation, value: 0)
            _collection.getCurrentGame()._secondPlayer.misses.append("\(columnShotLocation)\(rowShotLocation))")
            _collection.getCurrentGame()._secondPlayer.shots += 1
        }
        else if locationValue == 3 {
            //update view for a hit
            self._playerTwoView!.opponentShips.buttonTouched((row: rowShotLocation, column: columnShotLocation), with: 1)
            self._playerOneView?.playerShips.buttonTouched((row: rowShotLocation, column: columnShotLocation), with: 1)
            
            //update model
            _collection.updateMove(rowShotLocation, column: columnShotLocation, value: 1)
            _collection.getCurrentGame()._secondPlayer.hits.append("\(columnShotLocation)\(rowShotLocation))")
            _collection.getCurrentGame()._secondPlayer.shots += 1
            
            //show hit message / show victory message
            if(_collection.getCurrentGame()._secondPlayer.hitCount == 17){
                let name: String = _collection.getCurrentGame()._secondPlayer.name
                alertMessage.title = "\(name) is victorious!"
                alertMessage.show()
                _collection.getCurrentGame().winner = name
                _collection.getCurrentGame()._gameOver = true
                _collection.writeToFile()
                returnToMenu()
            }
            else{
                alertMessage.title = "BANG"
                alertMessage.show()
            }
        }
        else {
            print("Game board is not in valid state")
        }
        return true
    }
    
    
    
    
    //helper that updates the game statistics displayed on the screen
    func updateLabels() {
        if(!_collection.online){
        //enemy lives remaining label
        _playerOneView?.shipsRemainingLabel.text = "Enemy Lives: \(17 - _collection.getCurrentGame()._firstPlayer.hitCount)"
        _playerTwoView?.shipsRemainingLabel.text = "Enemy Lives: \(17 - _collection.getCurrentGame()._secondPlayer.hitCount)"
        
        //shots fired label
        _playerOneView?.shotsCountLabel.text = "Shots Fired: \(_collection.getCurrentGame()._firstPlayer.shots)"
        _playerTwoView?.shotsCountLabel.text = "Shots Fired: \(_collection.getCurrentGame()._secondPlayer.shots)"
        
        //hits lable
        _playerOneView?.hitCountLabel.text = "Hits: \(_collection.getCurrentGame()._firstPlayer.hitCount)"
        _playerTwoView?.hitCountLabel.text = "Hits: \(_collection.getCurrentGame()._secondPlayer.hitCount)"

        //misses label
        _playerOneView?.missCountLabel.text = "Misses: \(_collection.getCurrentGame()._firstPlayer.missCount)"
        _playerTwoView?.missCountLabel.text = "Misses: \(_collection.getCurrentGame()._secondPlayer.missCount)"
        } else if(!_collection._continueOldGame){
            //enemy lives remaining label
            _playerOneView?.shotsCountLabel.text = "\(17 - _collection._shipSunk)"
            
        } else {
//            _playerOneView?.shotsCountLabel.text = "\(_collection.currentOnlineGameDetail.missilesLaunched)"
        }
    }
}
