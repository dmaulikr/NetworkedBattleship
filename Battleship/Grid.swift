//
//  Grid.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//grid for the game board
class Grid {
    var columns: [Column] = [Column]()
    var numberOfColumns = 10
    
    //creates a grid
    init(){
        for(var count = 0; count < numberOfColumns; count++){
            columns.append(Column())
        }
    }
    
    //gets the value stored at a given location
    func getLocationInformation(column: Int, row: Int) -> Int{
        return columns[column].getMarkerFromLocationAtIndex(row);
    }
    
    //updates value at a specified location
    func updateLocation(column: Int, row: Int, value: Int){
        columns[column].setLocationAtIndex(row, value: value );
    }
    
    // 0 = miss, 1 = hit, 2 = water, 3 = ship
    class Column {
        var _rows: [Int] = []
        var rowCount: Int = 10
        
        //creates rows for each column with default water value
        init() {
            for (var index: Int = 0 ; index < rowCount ; index++) {
                _rows.append(2)
            }
        }
        
        //retreives the info for a specifit game square
        func getMarkerFromLocationAtIndex(index: Int) -> Int {
            return _rows[index]
        }
        
        //sets the grid square with game info
        func setLocationAtIndex(index: Int, value: Int){
            _rows[index] = value
        }
    }
}
