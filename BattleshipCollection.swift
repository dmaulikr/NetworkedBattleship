//
//  BattleshipCollection.swift
//  Battleship
//
//  Created by Jordan Davis on 4/02/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import Foundation



//stores multiple games of battleship
class BattleshipCollection {
    //MARK: - LOCAL
    private var _games = [BattleshipGame]()
    private var currentGameIndex: Int = 0;
    
    
    
    //MARK: - LOCAL HELP

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
    
    //online mode
    var online: Bool {
        get{return _online}
        set{
            _online = newValue
        }
    }

    //given to us in assignment specs.
    func writeToFile(){
        let documentsDirectory: NSString? = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString?
        
        let filePath: String? = (documentsDirectory as NSString?)!.stringByAppendingPathComponent("file1.txt")
        
        writeToFile(filePath!)
    }
    
    //save all info to file
    //puts each important data member into NS form then into a single dictionary for each game.
    //keeps the collection in an array
    func writeToFile(path: String) {
        let listOfGames: NSMutableArray = []
        
        let onlinePlayerIds: NSArray  = NSArray(array: myOnlinePlayerIDs)
        let onlineGameIds: NSArray = NSArray(array: myOnlineGameIDs)
        let gameDict: NSDictionary = allMyOnlineGameInfo as NSDictionary
        
            let onlineGamesAsDictonary: NSDictionary = ["onlinePlayerIds": onlinePlayerIds, "onlineGameIds": onlineGameIds, "gameDict": gameDict]
        listOfGames.addObject(onlineGamesAsDictonary)
        
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
            
            let filePath: String? = (dir as NSString?)!.stringByAppendingPathComponent("file1.txt")
            
            //make an NSArray from the file path
            let savedArray: NSArray? = NSArray(contentsOfFile: filePath!)
            
            if(savedArray != nil){
                let array = savedArray as! [NSDictionary]
                
                var count: Int = 0
                
                //setup all the battleship games in the collection
                for game in array {
                    if(count > 0) {
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
                        for(var i = 0; i < 10; i += 1) {
                            var playerOneBoard: [[Int]] = game.valueForKey("playerOneBoard") as! [[Int]]
                            setUpGame._firstPlayer.board._map.columns[i]._rows = playerOneBoard[i]
                            
                            var playerTwoBoard: [[Int]] = game.valueForKey("playerTwoBoard") as! [[Int]]
                            setUpGame._secondPlayer.board._map.columns[i]._rows = playerTwoBoard[i]
                        }
                        
                        Static.instance?._games.append(setUpGame)
                    } else {
                        let onlineGameIds: [String] = game["onlineGameIds"] as! [String]
                        Static.instance?.myOnlineGameIDs = onlineGameIds
                        
                        let onlinePlayerIds: [String] = game["onlinePlayerIds"] as! [String]
                        Static.instance?.myOnlinePlayerIDs = onlinePlayerIds
                        
                        let dictOfGames: Dictionary<String, String> = game["gameDict"] as! Dictionary<String, String>
                        Static.instance?.allMyOnlineGameInfo = dictOfGames
                        
                        }
                    
                        count += 1
                    }
                }
            }
        return Static.instance!
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: - ONLINE
    //////////////////////////////////////////////////////////////////////////////////////////////////////

    private var _online: Bool = false
    private var _onlineGamesDetail: [GameDetail] = [GameDetail]()
    private var _onlineGameSummary: [GameSummary] = [GameSummary]()
    private var _currentOnlineGameIndex: Int = -1
    private var _currentOnlineGameDetail: GameDetail = GameDetail(id: "", name: "", player1: "", player2: "", winner: "", missilesLaunched: 0)
    private var _currentOnlineGameId: String = ""
    private var _currentOnlinePlayerId = "empty"
    
    private var _onlineOpponentGameBoard = GameBoard()
    private var _onlinePlayerGameBoard = GameBoard()
    var _onlineIsMyTurn = 0
    var _onlineCurrentGameWinner = "IN PROGRESS"
    var _lastMove = 0
    var _shipSunk = 0
    
    var allMyOnlineGameInfo: Dictionary<String, String> = Dictionary<String,String>()
    var myOnlinePlayerIDs: [String] = [String]()
    var myOnlineGameIDs: [String] = [String]()
    var _continueOldGame: Bool = false

    
    //MARK: - ONLINE HELP
    func setOnlineGameBoard(status: NSDictionary){
        let map = Grid()
        
        if(status.count <= 1){
            
        } else {
            let opp: NSArray = status.valueForKey("opponentBoard") as! NSArray
            let play: NSArray = status.valueForKey("playerBoard") as! NSArray
            
            for (var i = 0 ; i < opp.count ; i += 1){
                map.updateOnlineLocation(opp[i].valueForKey("xPos") as! Int, row: opp[i].valueForKey("yPos") as! Int, value: opp[i].valueForKey("status") as! String)
            }
            
            _onlineOpponentGameBoard._map = map
            setOnlinePlayerGameBoard(play)
        }
    }
    
    var OnlineOpponentGameBoard: GameBoard {
        get{return _onlineOpponentGameBoard}
        set{_onlineOpponentGameBoard = newValue}
    }
    
    func setOnlinePlayerGameBoard(player: NSArray){
        let map = Grid()
        
        for (var i = 0 ; i < player.count ; i += 1){
            map.updateOnlineLocation(player[i].valueForKey("xPos") as! Int, row: player[i].valueForKey("yPos") as! Int, value: player[i].valueForKey("status") as! String)
        }
        
        _onlinePlayerGameBoard._map = map
    }
    
    var OnlinePlayerGameBoard: GameBoard {
        get{return _onlinePlayerGameBoard}
        set{_onlinePlayerGameBoard = newValue}
    }
    
    func setOnlineGameListSummary(list: NSArray) {
        _onlineGameSummary = [GameSummary]()
        for game in list {
            let dictionary = game as! NSDictionary
            
            if(dictionary.count > 0){
                _onlineGameSummary.append(GameSummary(id: dictionary.valueForKey("id") as! String, name: dictionary.valueForKey("name") as! String, state: dictionary.valueForKey("status") as! String))
            }
        }
        writeToFile()
        
    }
    
    func newOnlineGame(game: NSDictionary){
        
        if(game.valueForKey("gameId") == nil || game.valueForKey("playerId") == nil) {
            return
        }
        myOnlineGameIDs.append(game.valueForKey("gameId") as! String)
        myOnlinePlayerIDs.append(game.valueForKey("playerId") as! String)
        allMyOnlineGameInfo[game.valueForKey("gameId") as! String] = (game.valueForKey("playerId") as! String)
        _currentOnlinePlayerId = game.valueForKey("playerId") as! String
        _currentOnlineGameId = game.valueForKey("gameId") as! String
        currentOnlineGameIndex = _onlineGameSummary.count
        writeToFile()
        self.NetworkRequestPlayersBoard(_currentOnlineGameId, playerId: _currentOnlinePlayerId)
        reInitGame()
    }
    
    func joinOnlineGame(game: NSDictionary){
        if(game["playerId"] != nil){
            myOnlinePlayerIDs.append(game.valueForKey("playerId") as! String)
            myOnlineGameIDs.append(_currentOnlineGameId)
            allMyOnlineGameInfo[currentOnlineGameDetail.id] = (game.valueForKey("playerId") as! String)
            currentOnlinePlayerId = game.valueForKey("playerId") as! String
            writeToFile()
        }
        self.NetworkRequestPlayersBoard(_currentOnlineGameId, playerId: _currentOnlinePlayerId)
        self.NetworkIsPlayersTurn(currentOnlineGameId, playerId: currentOnlinePlayerId)
        reInitGame()
    }
    
    func reInitGame(){
        self._onlineIsMyTurn = 0
        self._onlineCurrentGameWinner = "IN PROGRESS"
        self._lastMove = 0
        self._shipSunk = 0
    }
    
    var currentOnlinePlayerId: String{
        get{return _currentOnlinePlayerId}
        set { _currentOnlinePlayerId = newValue}
    }
    
    
    var onlineGameSummary: [GameSummary] {
        return _onlineGameSummary
    }
    
    var currentOnlineGameDetail: GameDetail{
        get {return _currentOnlineGameDetail}
        set {_currentOnlineGameDetail = newValue}
    }
    
    var currentOnlineGameIndex: Int {
        get {return _currentOnlineGameIndex}
        set {_currentOnlineGameIndex = newValue}
    }
    
    var currentOnlineGameId: String {
        get {return _currentOnlineGameId}
        set {_currentOnlineGameId = newValue}
    }
    

    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: - Network
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //MARK: - LOBBY
    
    //////
    func NetworkRequestGameList() -> NSArray {
        
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"http://battleship.pixio.com/api/games")!)
        let _q = NSOperationQueue()
        var summary: NSArray = NSArray()
        urlRequest.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: _q, completionHandler: { (response: NSURLResponse?, responseMessage: NSData?, error: NSError?) -> Void in NSOperationQueue.mainQueue().addOperationWithBlock(
            {
                if(responseMessage == nil)
                {
                    print("Unable To Get Data")
                }
                else
                {
                    summary = (try! NSJSONSerialization.JSONObjectWithData(responseMessage!, options: NSJSONReadingOptions())) as! NSArray
                    self.setOnlineGameListSummary(summary)
                }
        })
        })
        
        return summary
    }
    
    //////////////
    func NetworkRequestGameDetail(gameId: String) -> Dictionary<String,AnyObject> {
        
        var gameDetail: Dictionary<String, AnyObject> = [:]
        let url: NSURL = NSURL(string: "http://battleship.pixio.com/api/games/\(gameId)")!
        
        let darullo: NSData? = NSData(contentsOfURL: url)
        
        if(darullo == nil) {
            print("No data received from \(url)")
            return Dictionary<String, AnyObject>()
        }
        
        let dictOfGameInfo: NSDictionary? = (try? NSJSONSerialization.JSONObjectWithData(darullo!, options: [])) as! NSDictionary?
        
        if(dictOfGameInfo == nil){
            return Dictionary<String, AnyObject>()
        }
        
        gameDetail = dictOfGameInfo as! Dictionary<String, AnyObject>
        
        return gameDetail
    }
    
    /////
    func NetworkJoinGame(gameId: String, playerName: String) {
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"http://battleship.pixio.com/api/games/\(gameId)/join")!)
        do {
            urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(["playerName": playerName], options: [])
        } catch {
            urlRequest.HTTPBody = nil
        }
        
        urlRequest.HTTPMethod = "POST"
        urlRequest.allHTTPHeaderFields!["content-type"] = "application/json"
        
        let _q = NSOperationQueue()
        var summary: NSDictionary = NSDictionary()
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: _q, completionHandler: { (response: NSURLResponse?, responseMessage: NSData?, error: NSError?) -> Void in NSOperationQueue.mainQueue().addOperationWithBlock(
            {
                if(responseMessage == nil)
                {
                    print("Unable To Get Data")
                }
                else
                {
                    summary = (try! NSJSONSerialization.JSONObjectWithData(responseMessage!, options: NSJSONReadingOptions())) as! NSDictionary
                    self.joinOnlineGame(summary)
                }
        })
        })
    }

    /////////
    func NetworkCreateNewGame(gameName: String, playerId: String){
        //make a url for  the server
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"http://battleship.pixio.com/api/games")!)
        do {
            urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(["gameName": gameName, "playerName": playerId], options: [])
        } catch {
            urlRequest.HTTPBody = nil
        }
        
        urlRequest.HTTPMethod = "POST"
        urlRequest.allHTTPHeaderFields!["content-type"] = "application/json"
        
        let _q: NSOperationQueue = NSOperationQueue()
        var status: NSDictionary = NSDictionary()
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: _q, completionHandler: { (response: NSURLResponse?, responseMessage: NSData?, error: NSError?) -> Void in NSOperationQueue.mainQueue().addOperationWithBlock(
            {
                if(responseMessage == nil)
                {
                    print("Unable To Get Data")
                }
                else
                {
                    status = (try! NSJSONSerialization.JSONObjectWithData(responseMessage!, options: NSJSONReadingOptions())) as! NSDictionary
                    self.newOnlineGame(status)
                }
        })
        })
    }
    
    //MARK: - IN GAME
    func NetworkMakeAGuess(gameId: String, playerId: String, xPos: String, yPos: String) -> NSDictionary {
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"http://battleship.pixio.com/api/games/\(gameId)/guess")!)
        do {
            urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(["playerId": playerId, "xPos": xPos, "yPos": yPos], options: [])
        } catch {
            urlRequest.HTTPBody = nil
        }
        
        urlRequest.HTTPMethod = "POST"
        urlRequest.allHTTPHeaderFields!["content-type"] = "application/json"
        
        let _q: NSOperationQueue = NSOperationQueue()
        var status: NSDictionary = NSDictionary()
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: _q, completionHandler: { (response: NSURLResponse?, responseMessage: NSData?, error: NSError?) -> Void in NSOperationQueue.mainQueue().addOperationWithBlock(
            {
                if(responseMessage == nil)
                {
                    print("Unable To Get Data")
                }
                else
                {
                    status = (try! NSJSONSerialization.JSONObjectWithData(responseMessage!, options: NSJSONReadingOptions())) as! NSDictionary
                    self._lastMove = status.valueForKey("hit") as! Int
                    self._shipSunk += status.valueForKey("shipSunk") as! Int
                    
                }
        })
        })
        
        return status
    }
    
    ////////////////
    func NetworkIsPlayersTurn(gameId: String, playerId: String) -> NSDictionary {
        //make a url for  the server
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"http://battleship.pixio.com/api/games/\(gameId)/status")!)
        do {
            urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(["playerId": playerId], options: [])
        } catch {
            urlRequest.HTTPBody = nil
        }
        
        urlRequest.HTTPMethod = "POST"
        urlRequest.allHTTPHeaderFields!["content-type"] = "application/json"
        
        let _q: NSOperationQueue = NSOperationQueue()
        var status: NSDictionary = NSDictionary()
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: _q, completionHandler: { (response: NSURLResponse?, responseMessage: NSData?, error: NSError?) -> Void in NSOperationQueue.mainQueue().addOperationWithBlock(
            {
                if(responseMessage == nil)
                {
                    print("Unable To Get Data")
                }
                else
                {
                    status = (try! NSJSONSerialization.JSONObjectWithData(responseMessage!, options: NSJSONReadingOptions())) as! NSDictionary
                    self._onlineIsMyTurn = status.valueForKey("isYourTurn") as! Int
                    self._onlineCurrentGameWinner = status.valueForKey("winner") as! String
                }
        })
        })
        

        return status
    }
    
    func NetworkRequestPlayersBoard(gameId: String, playerId: String) {
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"http://battleship.pixio.com/api/games/\(gameId)/board")!)
        do {
            urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(["playerId": playerId], options: [])
        } catch {
            urlRequest.HTTPBody = nil
        }
        
        urlRequest.HTTPMethod = "POST"
        urlRequest.allHTTPHeaderFields!["content-type"] = "application/json"
        
        let _q: NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: _q, completionHandler: { (response: NSURLResponse?, responseMessage: NSData?, error: NSError?) -> Void in NSOperationQueue.mainQueue().addOperationWithBlock(
            {
                if(responseMessage == nil)
                {
                    print("Unable To Get Data")
                }
                else
                {
                    let status = (try! NSJSONSerialization.JSONObjectWithData(responseMessage!, options: NSJSONReadingOptions()))
                    self.setOnlineGameBoard(status as! NSDictionary)
                }
                
        })
        })
    }
    
    struct GameSummary {
        var id: String
        var name: String
        var state: String
    }
    
    struct GameDetail {
        var id: String
        var name: String
        var player1: String
        var player2: String
        var winner: String //winner: String
        var missilesLaunched: Int
    }
    

}





