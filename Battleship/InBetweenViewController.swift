//
//  InBetweenViewController.swift
//  Battleship
//
//  Created by Jordan Davis on 3/11/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit

//Conroller used to inform a player to had device to his opponent
class InBetweenMovesController: UIViewController
{
    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance
    private var _switchButton: UIButton?
    private var _playerLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = .lightGrayColor()
        
        //main button
        _switchButton = UIButton()
        _switchButton!.setTitle("Ready", forState: UIControlState.Normal)
        _switchButton!.addTarget(self, action: "swapPlayers", forControlEvents: UIControlEvents.TouchUpInside)
        _switchButton!.backgroundColor = .redColor()
        _switchButton!.layer.cornerRadius = 10
        view.addSubview(_switchButton!)
        
        //label telling you what to do
        _playerLabel = UILabel()
        _playerLabel!.text = "Pass device to \(_collection.getCurrentGame().currentPlayersTurn)"
        _playerLabel!.textColor = .whiteColor()
        view.addSubview(_playerLabel!)
    }
    

    //keeps the button looking good in the center
    override func viewWillLayoutSubviews()
    {
        _switchButton!.frame = CGRect(x: view.bounds.width / 2 - 100 , y: view.bounds.height / 2 - 25, width: 200, height: 50)
        _playerLabel!.frame = CGRect(x: view.bounds.width / 2 - 100 , y: view.bounds.height / 2 - 50, width: 300, height: 20)
    }
    
    //presents the screen telling user to pass the device
    func swapPlayers()
    {
        presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
    }
}
