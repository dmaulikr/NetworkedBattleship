//
//  GameBoard.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import Foundation

//unique game board for each player
class GameBoard {
    
    var _map: Grid = Grid()
    var _shipLocations: [String] = [String]()
    var _aircraftCarrierShip: Ship = Ship(name: "Aircraft carrier", size: 5)
    var _battleshipShip: Ship = Ship(name: "Battleship", size: 4)
    var _submarineShip: Ship = Ship(name: "Submarine", size: 3)
    var _cruiserShip: Ship = Ship(name: "Cruiser", size: 3)
    var _destroyerShip: Ship = Ship(name: "Destroyer", size: 2)
    
    //MARK: Gameboard HelperMethods
    
    /*
    *   Randomizes the map by placing each ship in a random location
    */
    func randomize() {
        placeShipAtRandomLocation(_aircraftCarrierShip)
        placeShipAtRandomLocation(_battleshipShip)
        placeShipAtRandomLocation(_submarineShip)
        placeShipAtRandomLocation(_cruiserShip)
        placeShipAtRandomLocation(_destroyerShip)
    }
    
    /*
    *   Helper method to place a ship randomly on the map
    */
    
    private func placeShipAtRandomLocation(ship: Ship){
        let orientation: Int = (Int)(arc4random_uniform(2))
        var shipPlacedCorrectly = false
        
        if(orientation == 0) {
            while(!shipPlacedCorrectly){
                shipPlacedCorrectly = placeShipHorizontallyAtLocation(ship._size)
            }
        }
        else {
            while(!shipPlacedCorrectly){
                shipPlacedCorrectly = placeShipVerticallyAtLocation(ship._size)
            }
        }
    }
    
    /*
    *   Helper method to place a ship horizontally on the map
    *   Will first find a random location, then check if enough open space is available
    *   If space is available, Ship will be placed in the random position.
    */
    
    func placeShipHorizontallyAtLocation(spaceSize: Int) -> Bool{

        var columnIndex: Int = (Int)(arc4random_uniform(10))
        var rowIndex: Int = (Int)(arc4random_uniform(10))
        
        while (columnIndex + spaceSize > 9) {
            columnIndex = (Int)(arc4random_uniform(10))
            rowIndex = (Int)(arc4random_uniform(10))
        }
        
        for(var index = 0 ; index < spaceSize; index++){
            if(_map.getLocationInformation(columnIndex + index, row: rowIndex) == 3){
                return false
            }
        }
        
        for(var index = 0; index < spaceSize; index++){
            _shipLocations.append("\(rowIndex),\(columnIndex + index)")
            _map.updateLocation(columnIndex + index, row: rowIndex, value: 3)
        }
        return true
    }
    
    /*
    *   Helper method to place a ship vertically on the map
    *   Will first find a random location, then check if enough open space is available
    *   If space is available, Ship will be placed in the random position.
    *   // 0 = miss, 1 = hit, 2 = water, 3 = ship
    */
    
    func placeShipVerticallyAtLocation(spaceSize: Int) -> Bool {
     
        var columnIndex: Int = (Int)(arc4random_uniform(10))
        var rowIndex: Int = (Int)(arc4random_uniform(10))
        
        while (rowIndex + spaceSize > 9) {
            columnIndex = (Int)(arc4random_uniform(10))
            rowIndex = (Int)(arc4random_uniform(10))
        }
        
        for(var index = 0 ; index < spaceSize; index++){
            if(_map.getLocationInformation(columnIndex, row: rowIndex + index) == 3){
                return false
            }
        }
        
        for(var index = 0; index < spaceSize; index++){
            _shipLocations.append("\(rowIndex + index),\(columnIndex)")
            _map.updateLocation(columnIndex, row: rowIndex + index, value: 3)
        }
        return true
    }
}

//MARK: - SHIP
class Ship {
    var _name : String = ""
    var _size : Int = 0
    var _alive: Bool = true
    
    init(name: String, size: Int){
        _name = name
        _size = size
        _alive = true;
    }
}
