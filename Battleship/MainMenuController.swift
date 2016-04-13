//
//  MainMenuController.swift
//  Battleship
//
//  Created by Jordan Davis on 4/2/16.
//  Copyright © 2016 cs4962. All rights reserved.
//

import UIKit


class MainMenuController: UIViewController {
    
    private var _collection: BattleshipCollection = BattleshipCollection.sharedInstance
        
    var menuView: GameTypeView {
        return view as! GameTypeView
    }
    
    override func loadView() {
        view = GameTypeView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Battleship Main Menu"
        self.view.backgroundColor = .lightGrayColor()
        self.navigationController?.navigationBar.translucent = false        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        //setup buttons
        menuView.startLocal.addTarget(self, action: #selector(MainMenuController.local), forControlEvents: UIControlEvents.TouchDown)
        
        menuView.startOnline.addTarget(self, action: #selector(MainMenuController.online), forControlEvents: UIControlEvents.TouchDown)
        
        menuView.startMyOnline.addTarget(self, action: #selector(MainMenuController.myOnline), forControlEvents: UIControlEvents.TouchDown)
    }
    
    
    func local() {
        _collection.online = false
        navigationController?.pushViewController(GamesListViewController(), animated: true)
    }
    
    func online() {
        _collection.online = true
        _collection.NetworkRequestGameList()
        navigationController?.pushViewController(GamesListViewController(), animated: true)
    }
    
    func myOnline(){
        _collection.online = true
        _collection.NetworkRequestGameList()
        navigationController?.pushViewController(MyOnlineGamesListViewController(), animated: true)
    }
    
    
}
