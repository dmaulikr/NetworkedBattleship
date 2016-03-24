//
//  GridView.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//creates a grid of buttons
class GridView: UIView, GridButtonDelegate {
    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance
    private var _map: (width: Int, height: Int) = (10,10)
    private var _visible: Bool = true
    var _highlightedButtonLocation: (row: Int, column: Int)?
    var _previousButtonLocation: (row: Int, column: Int)?
    
    init(frame: CGRect, board: GameBoard, touchable: Bool ) {
        super.init(frame: frame)
        _visible = touchable
        placeButtonsOnGrid(board, touchable: touchable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //formats the game board and places the buttons on grid with vlaue from data model
    private func placeButtonsOnGrid(grid: GameBoard, touchable: Bool){
        userInteractionEnabled = touchable
        for rowIndex in 0..<10 {
            for columnIndex in 0..<10{
                let buttonFrame = CGRectMake(CGFloat(rowIndex) * (bounds.size.width * 0.1), CGFloat(columnIndex) * (bounds.size.height * 0.1), bounds.size.width * 0.1, bounds.size.height * 0.1)
                let button = GridButton(frame: buttonFrame, delegate: self)
                let value = grid._map.getLocationInformation(columnIndex, row: rowIndex)
                if((touchable && value != 3) || !touchable) {
                    button.buttonValue = value
                }
                button._rowLocation = rowIndex
                button._columnLocation = columnIndex
                addSubview(button)
            }
        }
    }
    
    //gets the button location and updates the button
    func updateButton(row: Int, column: Int){
        buttonTouched = (row, column)
    }
    
    // 0 = miss, 1 = hit, 2 = water, 3 = ship, 4 = highlighted
    //highlights a button when selected so user can confirm his choice.
    var buttonTouched: (row: Int, column: Int) {
        get { return _highlightedButtonLocation! }
        set { _highlightedButtonLocation = newValue
            buttonTouched(newValue, with: 4)
            if !previousButton() {
                if(_previousButtonLocation != nil){
                    buttonTouched(_previousButtonLocation!, with: 2)
                }
                _previousButtonLocation = newValue
            }
        }
    }
    
    // 0 = miss, 1 = hit, 2 = water, 3 = ship, 4 = highlighted
    //allows buttons to get updated with specific value
    func buttonTouched(location: (row: Int, column: Int),with value: Int){
        (subviews[location.row * 10 + location.column] as! GridButton).buttonValue = value
    }
    
    //helper method to only highlight one button at a time
    private func previousButton() -> Bool{
        if(_previousButtonLocation == nil){
            return false
        }
        return (_highlightedButtonLocation!.row == _previousButtonLocation!.row && _highlightedButtonLocation!.column == _previousButtonLocation!.column)
    }
}