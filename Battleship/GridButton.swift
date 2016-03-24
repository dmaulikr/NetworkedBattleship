//
//  GridButton.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

protocol GridButtonDelegate: class{
    func updateButton(row: Int, column: Int)
}

//a single grid space as a button
class GridButton: UIView {
    
    // 0 = miss, 1 = hit, 2 = water, 3 = ship, 4 = highlighted
    private var _buttonValue:Int = 2
    private var _finalState = false
    var _rowLocation: Int = 0
    var _columnLocation: Int = 0
    private var _buttonColor: UIColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
    weak var Delegate: GridButtonDelegate? = nil
    

    init(frame: CGRect, delegate: GridButtonDelegate) {
        super.init(frame: frame)
        Delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //allows user to select a button
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Delegate?.updateButton(_rowLocation, column: _columnLocation)
    }
    
    override func drawRect(rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()
        let x = bounds.origin.x + 1
        let y = bounds.origin.y + 1
        let width = bounds.size.width - 2
        let height = bounds.size.width - 2
        let button = CGRectMake(x, y, width, height)
        
        CGContextAddRect(context, button)
        CGContextSetFillColorWithColor(context, _buttonColor.CGColor)
        CGContextFillRect(context, button)
    }
    

    //modifies the button value, color and updates button
    var buttonValue: Int{
        get{ return _buttonValue }
        set{ if !_finalState {
                _buttonValue = newValue
                changeButtonColor()
                setNeedsDisplay()
            }
        }
    }
    
    //helper method to choose button color for given value
    private func changeButtonColor(){
        // 0 = miss, 1 = hit, 2 = water, 3 = ship 4 = highlighted
        switch _buttonValue {
        case 0:
            _buttonColor = .whiteColor()
            userInteractionEnabled = false
            _finalState = true
        case 1:
            _buttonColor = .redColor()
            userInteractionEnabled = false
            _finalState = true
        case 2:
            _buttonColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        case 3:
            _buttonColor = .darkGrayColor()
        case 4:
            _buttonColor = .yellowColor()
        default:
            _buttonColor = UIColor(red: 99/255, green: 184/255, blue: 255/255, alpha: 1)
        }
    }
}