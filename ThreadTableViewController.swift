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
                        println("Login failed")
                    }
                    
                    
                }
                
                
                
                
            }))
            
            loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: {
                alertAction in
                let textFields:NSArray = loginAlert.textFields as AnyObject! as NSArray
                let usernameTextfield:UITextField = textFields.objectAtIndex(0) as UITextField
                let passwordTextfield:UITextField = textFields.objectAtIndex(1) as UITextField
                
                var sweeter:PFUser = PFUser()
                sweeter.username = usernameTextfield.text
                sweeter.password = passwordTextfield.text
                
                sweeter.signUpInBackgroundWithBlock{
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
                    }
                    
                    //Reverse data so most reccent is first
                    let rArray : NSArray = self.discussionData.reverseObjectEnumerator().allObjects
                    self.discussionData = rArray as NSMutableArray
                    
                    self.discussionTableView.reloadData()
                    println(self.discussionData)
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
        message.saveInBackground()
        //save textfield value
        self.view.center = originalCenter
        //rreturn the view to regular view
        messageBox.resignFirstResponder()
        //close keyboard
        messageBox.text = ""
        //reset textfield
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalCenter = self.view.center
        self.discussionTableView.tableFooterView = UIView(frame: CGRectZero)
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
        
        cell.contentBox.text = post["content"] as String
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discussionData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
