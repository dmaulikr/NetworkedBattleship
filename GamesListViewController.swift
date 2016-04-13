//
//  GamesListViewController.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//controlls the collection of games. displays game information. allows add/delete games.
class GamesListViewController: UITableViewController {

    private var alertMessage: UIAlertView = UIAlertView()

    
    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance
    
    override func loadView() {
        view = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if(_collection.online){
            self.title = "Online Lobby"
        } else {
            self.title = "Local Lobby"
        }
        
        self.view.backgroundColor = .lightGrayColor()
        let newGame = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(GamesListViewController.createNewGame))
        if(!_collection.online){
            self.navigationItem.setRightBarButtonItems([newGame, editButtonItem()], animated: true)
        } else {
            self.navigationItem.setRightBarButtonItems([newGame], animated: true)
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: #selector(GamesListViewController.returnToMenu))
        self.alertMessage.addButtonWithTitle("Afirmative")

        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = .SingleLine
        
        self.tableView.reloadData()
    }
    
    //MARK: - OVERRIDES
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //makes sure the view refreshes
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        if(_collection.online){
            _collection.NetworkRequestGameList()
        }
        tableView.reloadData()
    }

    //number of cells needed
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!_collection.online){
            return _collection.totalGames
        } else {
            _collection.NetworkRequestGameList()
            return _collection.onlineGameSummary.count
        }
    }
    
    //modifies cell contents with game information
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle , reuseIdentifier: nil)
        let gameNumber: Int = indexPath.row

        if(!_collection.online) { //LOCAL
            
            //set valuable cell info. (game status)
            if(_collection.games[gameNumber]._gameOver) {
                cell.textLabel?.text = "Game Over: " + _collection.games[gameNumber].winner + " Won"
            }
            else {
                cell.textLabel?.text = "Game In-Progress: " + (_collection.games[gameNumber].currentPlayersTurn) + "'s Turn "
            }
            //add game statistics
            cell.detailTextLabel?.text = _collection.games[gameNumber]._firstPlayer.name + "'s Hits: " + _collection.games[gameNumber]._firstPlayer.hitCount.description + "     " + _collection.games[gameNumber]._secondPlayer.name + "'s Hits: " + _collection.games[gameNumber]._secondPlayer.hitCount.description
        }
        else { //ONLINE
            //set valuable cell info. (game status)
            let stats = _collection.NetworkRequestGameDetail(_collection.onlineGameSummary[gameNumber].id)
            if(_collection.onlineGameSummary[gameNumber].state == "DONE") {
                cell.textLabel?.text = "Game Over: \(stats["winner"] as! String) is Victorious"
                //TODO, get winners name
            }
            else if (_collection.onlineGameSummary[gameNumber].state == "PLAYING"){
                cell.textLabel?.text = "In Progress: \(_collection.onlineGameSummary[gameNumber].name)"
            } else {
                cell.textLabel?.text = "Waiting: \(_collection.onlineGameSummary[gameNumber].name)"
            }
            //add game statistics
            if(stats["player2"] as! String == ""){
                cell.detailTextLabel?.text = "\(stats["player1"] as! String) is waiting for an opponent"
            } else {
                cell.detailTextLabel?.text = "\(stats["player1"] as! String) vs. \(stats["player2"] as! String)"
            }

        }

        cell.contentView.backgroundColor = .whiteColor()
        return cell
    }

    //allows user to open a previous game
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let gameNumber = indexPath.row
        if(!_collection.online){
            if(!_collection.games[gameNumber]._gameOver){
                _collection.resumeGame(gameNumber)
                navigationController?.pushViewController(GameViewController(), animated: true)
            }

        } else {
            let game = _collection.NetworkRequestGameDetail(_collection.onlineGameSummary[gameNumber].id)

            if(_collection.onlineGameSummary[gameNumber].state == "WAITING"){
                //JOIN
                _collection.currentOnlineGameIndex = gameNumber
                _collection.currentOnlineGameId = _collection.onlineGameSummary[gameNumber].id
                _collection.currentOnlineGameDetail.id = game["id"] as! String
                _collection.currentOnlineGameDetail.name = game["name"] as! String
                _collection.currentOnlineGameDetail.player1 = game["player1"] as! String
                navigationController?.pushViewController(JoinOnlineGameViewController(), animated: true)
                
            } else if(_collection.onlineGameSummary[gameNumber].state == "PLAYING" && _collection.myOnlineGameIDs.contains( _collection.onlineGameSummary[gameNumber].id)){
                _collection.NetworkIsPlayersTurn(_collection.onlineGameSummary[gameNumber].id, playerId: _collection.allMyOnlineGameInfo[_collection.onlineGameSummary[gameNumber].id]!)
                _collection.NetworkRequestPlayersBoard(_collection.onlineGameSummary[gameNumber].id, playerId: _collection.allMyOnlineGameInfo[_collection.onlineGameSummary[gameNumber].id]!)
                _collection.currentOnlineGameIndex = gameNumber
                _collection.currentOnlineGameId = _collection.onlineGameSummary[gameNumber].id
                _collection.currentOnlinePlayerId = _collection.allMyOnlineGameInfo[_collection.onlineGameSummary[gameNumber].id]!
                _collection.currentOnlineGameDetail.id = game["id"] as! String
                _collection.currentOnlineGameDetail.name = game["name"] as! String
                _collection.currentOnlineGameDetail.player1 = game["player1"] as! String
                _collection.currentOnlineGameDetail.player2 = game["player2"] as! String
                _collection.currentOnlineGameDetail.winner = game["winner"] as! String
                _collection.currentOnlineGameDetail.missilesLaunched = game["missilesLaunched"] as! Int
                _collection._continueOldGame = true

                navigationController?.pushViewController(GameViewController(), animated: true)
                
            } else {
                if(game["winner"] as! String == "IN PROGRESS"){
                    alertMessage.title = "\(game["name"] as! String) is In Progress. \(game["missilesLaunched"] as! Int) missiles have been launched"
                    alertMessage.show()
                } else {
                    alertMessage.title = "\(game["winner"] as! String) is victorious! \(game["missilesLaunched"] as! Int) missiles were launched"
                    alertMessage.show()
                }
            }
        }
        
        self.tableView.reloadData()

    }
    
    //allows user to delete games from the collection
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            if(!_collection.online){
                _collection.removeGameAtIndex(indexPath.row)
            } else {
                //TODO: delete online game
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        tableView.reloadData()
    }
    
    //change label for "delete" button
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
    }
    
    //MARK: - ACTIONS
    //when user presses the '+' button, create a fresh game
    func createNewGame() {
        tableView.reloadData()
        if(!_collection.online){
            navigationController?.pushViewController(NewGameViewController(), animated: true)
        } else {
            _collection.currentOnlineGameIndex = _collection.onlineGameSummary.count
            navigationController?.pushViewController(NewOnlineGameViewController(), animated: true)
        }
        self.tableView.reloadData()
    }
    
    func returnToMenu() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
