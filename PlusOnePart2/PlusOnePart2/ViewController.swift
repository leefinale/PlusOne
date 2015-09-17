//
//  ViewController.swift
//  PlusOnePart2
//
//  Created by Elex Lee on 9/12/15.
//  Copyright (c) 2015 Elex Lee. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var switchUsersButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var dockHeight: NSLayoutConstraint!
    
    var messagesArray: [String] = [String]()
    var userList: [User] = [User]()
    var currentUser: String?
    var otherUser: String?
    var whoSentArray: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        
        self.messageField.delegate = self
        
        self.chatTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
//        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillMove:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        createUsers()
        grabMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Table view methods and related functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.chatTableView.dequeueReusableCellWithIdentifier("Message", forIndexPath: indexPath)
        cell.textLabel?.text = messagesArray[indexPath.row]
        cell.textLabel?.sizeToFit()
        if whoSentArray.count != 0 {
            if whoSentArray[indexPath.row] == currentUser {
                cell.textLabel?.textAlignment = .Right
            } else {
                cell.textLabel?.textAlignment = .Left
            }
        }
        return cell
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        let delay = 0.05 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            let numberOfSections = self.chatTableView.numberOfSections
            let numberOfRows = self.chatTableView.numberOfRowsInSection(numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
        })
    }
    
    //MARK: Keyboard methods
    func keyboardWillHide(notification: NSNotification) {
        print("keyboard hide")
        print(notification.userInfo!)
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        self.view.setNeedsLayout()
        self.dockHeight.constant = 45
        self.view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in print("")
        })
    }
    
    func keyboardWillMove(notification: NSNotification) {
        print("keyboard shows")
        print(notification.userInfo!)
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        var constraint = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let frameValue = constraint.CGRectValue()
        print(frameValue)
        self.view.setNeedsLayout()
        self.dockHeight.constant = frameValue.height + 45
        self.view.setNeedsUpdateConstraints()
        self.tableViewScrollToBottom(true)
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in print("")
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("keyboard shows")
        print(notification.userInfo!)
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        self.view.setNeedsLayout()
        self.dockHeight.constant = 260
        self.view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in print("")
        })
    }
    
    //MARK: Makes the program run
    func createUsers() {
        var firstUser: User = User(username: "steveRogers", mainUser: true)
        userList.append(firstUser)
        var secondUser: User = User(username: "tonyStark", mainUser: false)
        userList.append(secondUser)
        currentUser = firstUser.username
        otherUser = secondUser.username
    }
    
    func grabMessages() {
        var query = PFQuery(className: "ChatHistory")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                self.whoSentArray = [String]()
                self.messagesArray = [String]()
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        let message = object.objectForKey("messages") as? String
                        if message != nil {
                            self.messagesArray.append(message!)
                        }
                        let whoSent = object.objectForKey("WhoSent") as? String
                        if whoSent != nil {
                            self.whoSentArray.append(whoSent!)
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.chatTableView.reloadData()
                }
                self.tableViewScrollToBottom(true)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    func switchUser(action: UIAlertAction!) {
        otherUser = currentUser
        currentUser = action.title
        grabMessages()
    }

    @IBAction func sendButtonTapped(sender: UIButton) {
        if messageField.text != "" {
            let testObject = PFObject(className: "ChatHistory")
            testObject.setObject(messageField.text, forKey: "messages")
            testObject.setObject(self.currentUser!, forKey: "WhoSent")
            testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                self.grabMessages()
            }
            self.messageField.text = ""
        }
    }
    
    @IBAction func switchUsers(sender: UIButton) {
        let ac = UIAlertController(title: "Switch User", message: nil, preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: otherUser!, style: .Default, handler: switchUser))
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
}

