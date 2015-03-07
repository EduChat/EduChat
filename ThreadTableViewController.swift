//
//  ThreadTableViewController.swift
//  EduChat
//
//  Created by loaner on 3/7/15.
//  Copyright (c) 2015 Martin Developments. All rights reserved.
//

import UIKit

class ThreadTableViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var messageBox: UITextView!
    @IBOutlet weak var discussionTableView: UITableView!
    var originalCenter = CGPoint()
    var discussionData : NSMutableArray = NSMutableArray()
    
    override func viewDidAppear(animated: Bool) {
        self.fetchMessages()
        if PFUser.currentUser() == nil {
            var loginAlert:UIAlertController = UIAlertController(title: "Sign Up / Login", message: "Please sign up or login", preferredStyle: UIAlertControllerStyle.Alert)
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your username"
            })
            
            loginAlert.addTextFieldWithConfigurationHandler({
                textfield in
                textfield.placeholder = "Your password"
                textfield.secureTextEntry = true
            })
            
            loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields as AnyObject! as NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as UITextField
                
                PFUser.logInWithUsernameInBackground(usernameTextfield.text, password: passwordTextfield.text){
                    (user:PFUser!, error:NSError!)->Void in
                    if user != nil{
                        println("Login successfull")
                    }else{
                        loginAlert.message = "Username/Password combination incorrect"
                        self.presentViewController(loginAlert, animated: true, completion: nil)
                    }
                }
            }))
            
            loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields as AnyObject! as NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as UITextField
                
                var message:PFUser = PFUser()
                message.username = usernameTextfield.text
                message.password = passwordTextfield.text
                
                message.signUpInBackgroundWithBlock{
                    (success:Bool!, error:NSError!)->Void in
                    if error == nil{
                        println("Sign Up successfull")
                    }else{
                        let errorString = error.localizedDescription
                        println(errorString)
                    }
                    
                    
                }
                
                
                
            }))
            
            self.presentViewController(loginAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func Refresh(sender: AnyObject) {
        self.fetchMessages()
    }
    
    func fetchMessages() {
        println("hey")
        discussionData.removeAllObjects()
        
        var getDiscussionData : PFQuery = PFQuery(className: "Messages")
        
        getDiscussionData.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.discussionData.addObject(object)
                        println(self.discussionData)
                    }
                    
                    
                    self.discussionTableView.reloadData()
                    let ipath : NSIndexPath = NSIndexPath(forRow: self.discussionData.count-1, inSection: 0)
                    self.discussionTableView.scrollToRowAtIndexPath(ipath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                }
            } else {
                // Log details of the failure
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }
    
    
    @IBAction func post(sender: UIButton) {
        var message : PFObject = PFObject(className: "Messages")
        
        message["content"] = messageBox.text
        message["user"] = PFUser.currentUser()
        message.saveInBackground()
        //save textfield value
        self.view.center = originalCenter
        //rreturn the view to regular view
        messageBox.resignFirstResponder()
        //close keyboard
        messageBox.text = ""
        //reset textfield
        self.fetchMessages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalCenter = self.view.center
        self.discussionTableView.tableFooterView = UIView(frame: CGRectZero)
        let refreshTimer:NSTimer = NSTimer(timeInterval: 10, target: self, selector: Selector("fetchMessages"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(refreshTimer, forMode: NSDefaultRunLoopMode)
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
    }
    func textViewDidEndEditing(textView: UITextView) {
        self.view.center = originalCenter
    }
    
    //Tablview Datasource Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as PostTableViewCell
        
        //Configure the cell
        
        let post:PFObject = self.discussionData.objectAtIndex(indexPath.row) as PFObject
        
        cell.contentBox.alpha = 0
        cell.timestampLabel.alpha = 0
        cell.authorLabel.alpha = 0
        
        cell.contentBox.text = post["content"] as String
        
        
        var dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.timestampLabel.text = dataFormatter.stringFromDate(post.createdAt)
        
        var findAuthor:PFQuery = PFUser.query()
        //        findSweeter.whereKey("objectId", equalTo: sweet.objectForKey("sweeter").objectId)
        findAuthor.whereKey("objectId", equalTo: post.objectForKey("user").objectId)
        
        findAuthor.findObjectsInBackgroundWithBlock{
            (objects:[AnyObject]!, error:NSError!)->Void in
            if error == nil{
                let user:PFUser = (objects as NSArray).lastObject as PFUser
                cell.authorLabel.text = user.username
                
                UIView.animateWithDuration(0.5, animations: {
                    cell.contentBox.alpha = 1
                    cell.timestampLabel.alpha = 1
                    cell.authorLabel.alpha = 1
                })
            }
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discussionData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
