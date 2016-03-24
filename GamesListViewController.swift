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

    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance
    
    override func loadView() {
        view = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Battleship"
        self.view.backgroundColor = .lightGrayColor()
        let newGame = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "createNewGame")
        self.navigationController?.navigationBar.translucent = false

        self.navigationItem.rightBarButtonItem = newGame
        self.navigationItem.leftBarButtonItem = editButtonItem()
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
        tableView.reloadData()
    }

    //number of cells needed
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _collection.totalGames
    }
    
    //modifies cell contents with game information
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let gameNumber: Int = indexPath.row
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle , reuseIdentifier: nil)
        
        //set valuable cell info. (game status)
        if(_collection.games[gameNumber]._gameOver) {
            cell.textLabel?.text = "Game Over: " + _collection.games[gameNumber].winner + " Won"
        }
        else {
            cell.textLabel?.text = "Game In-Progress: " + (_collection.games[gameNumber].currentPlayersTurn) + "'s Turn "
        }
        //add game statistics
        cell.detailTextLabel?.text = _collection.games[gameNumber]._firstPlayer.name + "'s Hits: " + _collection.games[gameNumber]._firstPlayer.hitCount.description + "     " + _collection.games[gameNumber]._secondPlayer.name + "'s Hits: " + _collection.games[gameNumber]._secondPlayer.hitCount.description
        cell.contentView.backgroundColor = .whiteColor()
        
        return cell
    }

    //allows user to open a previous game
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let gameNumber = indexPath.row
        if(!_collection.games[gameNumber]._gameOver){
            _collection.resumeGame(gameNumber)
            navigationController?.pushViewController(GameViewController(), animated: true)
            self.tableView.reloadData()
        }
    }
    
    //allows user to delete games from the collection
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            _collection.removeGameAtIndex(indexPath.row)
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
    func createNewGame(){
        tableView.reloadData()
        navigationController?.pushViewController(NewGameViewController(), animated: true)
        self.tableView.reloadData()
    }
    
}
