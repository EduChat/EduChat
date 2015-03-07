//
//  ThreadTableViewController.swift
//  EduChat
//
//  Created by loaner on 3/7/15.
//  Copyright (c) 2015 Martin Developments. All rights reserved.
//

import UIKit

class ThreadTableViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var messageBox: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var originalCenter = CGPoint()
    
    func viewDidAppear() {
        
    }
    
    
    @IBAction func post(sender: UIButton) {
        var message : PFObject = PFObject(className: "Messages")
        message["content"] = messageBox.text
        message.saveInBackground()
        self.view.center = originalCenter
        messageBox.resignFirstResponder()
        messageBox.text = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalCenter = self.view.center
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func textViewDidBeginEditing(textView: UITextView) {
//        let keyHeight : CGFloat =
//        CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].height;
        self.view.center = CGPointMake(self.originalCenter.x, self.originalCenter.y-216)
        println("HEY")
    }
    func textViewDidEndEditing(textView: UITextView) {
        self.view.center = originalCenter
    }
    
}
