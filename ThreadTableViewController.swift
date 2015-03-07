//
//  ThreadTableViewController.swift
//  EduChat
//
//  Created by loaner on 3/7/15.
//  Copyright (c) 2015 Martin Developments. All rights reserved.
//

import UIKit

class ThreadTableViewController: UIViewController {

        
    @IBOutlet weak var messageBox: UITextView!
    
    func viewDidAppear() {
        
    }
    
    
    @IBAction func post(sender: UIButton) {
        var message : PFObject = PFObject(className: "Messages")
        message["content"] = messageBox.text
        message.saveInBackground()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}
