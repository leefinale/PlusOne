//
//  SelectionViewController.swift
//  PlusOnePart1
//
//  Created by Elex Lee on 9/12/15.
//  Copyright (c) 2015 Elex Lee. All rights reserved.
//

import UIKit

@objc
protocol SelectionViewControllerDelegate {
    optional func animateSelectionView()
}

class SelectionViewController: UIViewController {

    var delegate: SelectionViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("showMenu:"))
        view.addGestureRecognizer(rightSwipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMenu(sender:UISwipeGestureRecognizer) {
        print(sender)
        delegate?.animateSelectionView?()
    }
}
