//
//  BattleshipCollection.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import Foundation

//stores multiple games of battleship
class BattleshipCollection {
    private var _games = [BattleshipGame]()
    private var currentGameIndex: Int = 0;

    //creates a new game with given player names
    func startNewGame(playerOne: String, playerTwo: String) {
        let game = BattleshipGame(firstPlayerName: playerOne, secondPlayerName: playerTwo)
        _games.append(game)
        currentGameIndex = _games.count-1
        writeToFile()
    }
    
    //sets current game to selected game
    func resumeGame(index: Int){
        if(!_games[index]._gameOver){
            currentGameIndex = index
        }
    }
    
    //deletes a game
    func removeGameAtIndex(index: Int) {
        _games.removeAtIndex(index)
        writeToFile()
    }
    
    //returns a specified game
    func getGameAtIndex(index: Int) -> BattleshipGame{
        return _games[index]
    }
    
    //returns the current game being played
    func getCurrentGame() -> BattleshipGame {
        return _games[currentGameIndex]
    }
    
    //helper method to make a move
    func updateMove(row: Int, column:Int, value: Int){
        getCurrentGame().playMoveAtLocation(row,column: column,value: value)
        writeToFile()
    }
    
    //get all games
    var games: [BattleshipGame] {
        return _games
    }
    //total games
    var totalGames: Int {
        return _games.count
    }

    //given to us in assignment specs.
    func writeToFile(){
        let documentsDirectory: NSString? = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString?
        
        let filePath: String? = (documentsDirectory as NSString?)!.stringByAppendingPathComponent("file.txt")
        
        writeToFile(filePath!)
    }
    
    //save all info to file
    //puts each important data member into NS form then into a single dictionary for each game.
    //keeps the collection in an array
    func writeToFile(path: String) {
        let listOfGames: NSMutableArray = []
        
        for game in _games {
            
            let gameOver: Bool = game._gameOver
            let winner: NSString = game.winner
            let currentPlayersTurn: NSString = game.currentPlayersTurn
            let firstPlayer: NSString = game._firstPlayer.name
            let secondPlayer: NSString = game._secondPlayer.name
            let isFirstPlayersTurn: Bool = game._firstPlayer.isPlayersTurn
            let isSecondPlayersTurn: Bool = game._secondPlayer.isPlayersTurn
            let firstPlayersHits: NSArray = game._firstPlayer.hits
            let secondPlayersHits: NSArray = game._secondPlayer.hits
            let firstPlayersMisses: NSArray = game._firstPlayer.misses
            let secondPlayersMisses: NSArray = game._secondPlayer.misses
            let firstPlayersShots: Int = game._firstPlayer.shots
            let secondPlayersShots: Int = game._secondPlayer.shots
            let firstPlayersShipLocations: NSArray = NSArray(array: game._firstPlayer.board._shipLocations)
            let secondPlayersShipLocations: NSArray = NSArray(array: game._secondPlayer.board._shipLocations)
            
            var playerOneArrayOfRows: [[Int]] = []
            
            for column in game._firstPlayer.board._map.columns
            {
                let row: [Int] = column._rows
                playerOneArrayOfRows.append(row)
            }
            
            var playerTwoArrayOfRows: [[Int]] = []
            
            for column in game._secondPlayer.board._map.columns
            {
                let row: [Int] = column._rows
                playerTwoArrayOfRows.append(row)
            }
            
            let playerOneBoard: NSArray = NSArray(array: playerOneArrayOfRows)
            let playerTwoBoard: NSArray = NSArray(array: playerTwoArrayOfRows)

            let gameAsDictonary: NSDictionary = ["gameOver": gameOver, "winner": winner, "currentPlayersTurn": currentPlayersTurn, "firstPlayerName": firstPlayer, "secondPlayerName": secondPlayer, "isFirstPlayersTurn": isFirstPlayersTurn, "isSecondPlayersTurn": isSecondPlayersTurn, "firstPlayersShots": firstPlayersShots, "secondPlayersShots": secondPlayersShots, "firstPlayersHits" : firstPlayersHits, "secondPlayersHits": secondPlayersHits, "firstPlayersShipLocations" : firstPlayersShipLocations, "secondPlayersShipLocations" : secondPlayersShipLocations, "firstPlayersHits" : firstPlayersHits, "secondPlayersHits" : secondPlayersHits, "firstPlayersMisses" : firstPlayersMisses, "secondPlayersMisses" : secondPlayersMisses, "playerOneBoard" : playerOneBoard, "playerTwoBoard" : playerTwoBoard]
            
            listOfGames.addObject(gameAsDictonary)
        }
        
        listOfGames.writeToFile(path, atomically: true)
    }
    
    //creates a shared instance and loads the game info from file.
    class var sharedInstance: BattleshipCollection {
        struct Static {
            static var instance: BattleshipCollection?
        }
        if(Static.instance == nil){
            Static.instance = BattleshipCollection()
            
            let dir: NSString? = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString?
            
            let filePath: String? = (dir as NSString?)!.stringByAppendingPathComponent("file.txt")
            
            //make an NSArray from the file path
            let savedArray: NSArray? = NSArray(contentsOfFile: filePath!)
            
            if(savedArray != nil){
                let array = savedArray as! [NSDictionary]
                
                //setup all the battleship games in the collection
                for game in array
                {
                    let setUpGame: BattleshipGame = BattleshipGame(firstPlayerName: game.valueForKey("firstPlayerName")!.description, secondPlayerName: game.valueForKey("secondPlayerName")!.description)
                    
                    setUpGame._gameOver = game.valueForKey("gameOver")!.boolValue
                    setUpGame.winner = game.valueForKey("winner")!.description
                    
                    setUpGame._firstPlayer.shots = game.valueForKey("firstPlayersShots")!.integerValue
                    setUpGame._secondPlayer.shots = game.valueForKey("secondPlayersShots")!.integerValue
                    
                    setUpGame.currentPlayersTurn = game.valueForKey("currentPlayersTurn")!.description
                    setUpGame._firstPlayer.isPlayersTurn = game.valueForKey("isFirstPlayersTurn")!.boolValue
                    setUpGame._secondPlayer.isPlayersTurn = game.valueForKey("isSecondPlayersTurn")!.boolValue
                    
                    let playerOneShipLocationsArray: [String] = game.valueForKey("firstPlayersShipLocations") as! [String]
                    setUpGame._firstPlayer.board._shipLocations = playerOneShipLocationsArray
                    
                    let playerTwoShipLocationsArray: [String] = game.valueForKey("secondPlayersShipLocations") as! [String]
                    setUpGame._secondPlayer.board._shipLocations = playerTwoShipLocationsArray
                    
                    let playerOneHitLocationsArray: [String] = game.valueForKey("firstPlayersHits") as! [String]
                    setUpGame._firstPlayer.hits = playerOneHitLocationsArray
                    
                    let playerTwoHitLocationsArray: [String] = game.valueForKey("secondPlayersHits") as! [String]
                    setUpGame._secondPlayer.hits = playerTwoHitLocationsArray
                    
                    let playerOneMissLocationsArray: [String] = game.valueForKey("firstPlayersMisses") as! [String]
                    setUpGame._firstPlayer.misses = playerOneMissLocationsArray
                    
                    let playerTwoMissLocationsArray: [String] = game.valueForKey("secondPlayersMisses") as! [String]
                    setUpGame._secondPlayer.misses = playerTwoMissLocationsArray
                    
                    //set up each players game boards
                    for(var i = 0; i < 10; i++) {
                        var playerOneBoard: [[Int]] = game.valueForKey("playerOneBoard") as! [[Int]]
                        setUpGame._firstPlayer.board._map.columns[i]._rows = playerOneBoard[i]
                        
                        var playerTwoBoard: [[Int]] = game.valueForKey("playerTwoBoard") as! [[Int]]
                        setUpGame._secondPlayer.board._map.columns[i]._rows = playerTwoBoard[i]
                    }
                    
                    Static.instance?._games.append(setUpGame)
                }
            }
        }
        return Static.instance!
    }
}