//
//  ContainerViewController.swift
//  PlusOnePart1
//
//  Created by Elex Lee on 9/12/15.
//  Copyright (c) 2015 Elex Lee. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var mainNavigationController: UINavigationController!
    var menuViewController: MenuViewController!
    var selectionViewController: SelectionViewController!
    var menuHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectionViewController = UIStoryboard.selectionViewController()
        selectionViewController.delegate = self
        selectionViewController.navigationItem.title = "CHAT"
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        mainNavigationController = UINavigationController(rootViewController: selectionViewController)
        view.addSubview(mainNavigationController.view)
        addChildViewController(mainNavigationController)
        
        mainNavigationController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func selectionViewController() -> SelectionViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("SelectionViewController") as? SelectionViewController
    }
    
    class func menuViewController() -> MenuViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MenuViewController") as? MenuViewController
    }
}

// MARK: SelectionViewController delegate

extension ContainerViewController: SelectionViewControllerDelegate, MenuViewControllerDelegate {
    
    func animateSelectionView() {
        if menuHidden == true{
            addMenuViewController()
        }
        animatePanel(shouldExpand: menuHidden)
    }
    
    func addMenuViewController() {
        if (menuViewController == nil) {
            menuViewController = UIStoryboard.menuViewController()
            menuViewController.delegate = self
            
            view.insertSubview(self.menuViewController.view, atIndex: 0)
            addChildViewController(self.menuViewController)
            menuViewController.didMoveToParentViewController(self)
        }
    }
    
    func showSelectedView(userSelection userSelection: String) {
        selectionViewController.navigationItem.title = userSelection
        animateSelectionView()
    }
    
    func animatePanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand) {
            menuHidden = false
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(mainNavigationController.view.frame) - 50)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.menuHidden = true
                self.menuViewController!.view.removeFromSuperview()
                self.menuViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.mainNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
}
