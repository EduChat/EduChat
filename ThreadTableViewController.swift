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
    
    
    override func viewDidAppear(animated: Bool) {
        
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
