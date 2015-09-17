//
//  MenuViewController.swift
//  PlusOnePart1
//
//  Created by Elex Lee on 9/12/15.
//  Copyright (c) 2015 Elex Lee. All rights reserved.
//

import UIKit

@objc
protocol MenuViewControllerDelegate {
    optional func showSelectedView(userSelection userSelection: String)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var delegate: MenuViewControllerDelegate?
    
    var button: UIButton!
    var buttonCollection: [UIButton]!
    var buttonTitles: [String] = ["CHAT", "REEL", "CALENDAR", "MEMBER", "SETTINGS"]
    var horizontalLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonCollection = []
        createButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createButtons() {
        let buttonX: CGFloat = profileImageView.frame.origin.x
        var buttonY: CGFloat = profileImageView.frame.origin.y + 115.0
        
        for i in 0...buttonTitles.count - 1 {
            if i == 0 {
                horizontalLine = UIView(frame: CGRectMake(buttonX, buttonY, UIScreen.mainScreen().bounds.width * 0.9, 1.0))
                horizontalLine.backgroundColor = UIColor.grayColor()
                self.view.addSubview(horizontalLine)
            }
            button = UIButton(type: UIButtonType.System)
            button.tag = i
            button.frame = CGRectMake(buttonX, buttonY, UIScreen.mainScreen().bounds.width * 0.5, 50.0)
            button.setTitle(buttonTitles[i], forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.titleLabel!.font = UIFont.systemFontOfSize(28.0)
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            button.addTarget(self, action: "presentSelection:", forControlEvents: UIControlEvents.TouchUpInside)
            buttonCollection.append(button)
            buttonY = buttonY + 50
            
            horizontalLine = UIView(frame: CGRectMake(buttonX, buttonY, UIScreen.mainScreen().bounds.width * 0.9, 1.0))
            horizontalLine.backgroundColor = UIColor.grayColor()
            
            self.view.addSubview(horizontalLine)
            self.view.addSubview(button)
        }
    }
    
    func presentSelection(sender: UIButton!) {
        print(sender.tag)
        delegate?.showSelectedView?(userSelection: buttonTitles[sender.tag])
    }
}
