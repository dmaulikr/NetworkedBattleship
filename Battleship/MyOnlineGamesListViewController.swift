//
//  GamesListViewController.swift
//  Battleship
//
//  Created by Jordan Davis on 4/4/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//controlls the collection of games. displays game information. allows add/delete games.
class MyOnlineGamesListViewController: UITableViewController {
    
    private var alertMessage: UIAlertView = UIAlertView()
    
    
    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance
    
    override func loadView() {
        view = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Online Games"

        
        self.view.backgroundColor = .lightGrayColor()
        let newGame = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(GamesListViewController.createNewGame))
        self.navigationItem.setRightBarButtonItems([newGame], animated: true)
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
        _collection.NetworkRequestGameList()
        tableView.reloadData()
    }
    
    //number of cells needed
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _collection.myOnlineGameIDs.count
    }
    
    //modifies cell contents with game information
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle , reuseIdentifier: nil)
        var gameNumber: Int = indexPath.row

        //set valuable cell info. (game status)
        let game = _collection.NetworkRequestGameDetail(_collection.myOnlineGameIDs[gameNumber])
        var count: Int = 0
        for gg in _collection.onlineGameSummary{
            if(gg.id == game["id"] as! String){
                gameNumber = count
            }
            count += 1
        }
        
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

        cell.contentView.backgroundColor = .whiteColor()
        return cell
    }
    
    //allows user to open a previous game
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var gameNumber = indexPath.row
        let stats = _collection.NetworkRequestGameDetail(_collection.myOnlineGameIDs[gameNumber])
        var count: Int = 0
        for gg in _collection.onlineGameSummary{
            if(gg.id == stats["id"] as! String){
                gameNumber = count
            }
            count += 1
        }
        
        let game = _collection.NetworkRequestGameDetail(_collection.onlineGameSummary[gameNumber].id)
        
        if(_collection.onlineGameSummary[gameNumber].state != "DONE" &&  _collection.myOnlineGameIDs.contains( _collection.onlineGameSummary[gameNumber].id)){
            _collection.NetworkIsPlayersTurn(_collection.onlineGameSummary[gameNumber].id, playerId: _collection.allMyOnlineGameInfo[_collection.onlineGameSummary[gameNumber].id]!)
            _collection.NetworkRequestPlayersBoard(_collection.onlineGameSummary[gameNumber].id, playerId: _collection.myOnlinePlayerIDs[indexPath.row])
            _collection.currentOnlineGameIndex = gameNumber
            _collection.currentOnlineGameId = _collection.onlineGameSummary[gameNumber].id
            _collection.currentOnlinePlayerId = _collection.myOnlinePlayerIDs[indexPath.row]
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

        
        
        self.tableView.reloadData()
        
    }
    
    
    //MARK: - ACTIONS
    //when user presses the '+' button, create a fresh game
    func createNewGame() {
        tableView.reloadData()

        _collection.currentOnlineGameIndex = _collection.onlineGameSummary.count
            navigationController?.pushViewController(NewOnlineGameViewController(), animated: true)
        
        self.tableView.reloadData()
    }
    
    func returnToMenu() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
