//
//  pictureViewController.swift
//  template
//
//  Created by Dav Sun on 4/2/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class pictureViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var done: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        println("yea")
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.hidesBackButton = true;
        self.profile.image = UIImage(named: "default_profile.jpg");
        self.profile.layer.cornerRadius = 60;
        self.profile.layer.borderWidth = 2;
        self.profile.layer.borderColor = UIColor.redColor().CGColor;
        self.profile.clipsToBounds = true;
        self.done.hidden = true;
    }
    
    @IBAction func add(sender: AnyObject) {
        println("here")
        var ActionSheet = UIActionSheet(title: "Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Take a picture")
        ActionSheet.addButtonWithTitle("Choose a picture")
        ActionSheet.delegate = self
        ActionSheet.showInView(self.view)
    }
    
    func actionSheet(myActionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int){
        println(buttonIndex);
        if buttonIndex == 1 {
            ShouldStartCamera(self, true)
        }
        if buttonIndex == 2 {
            ShouldStartPhotoLibrary(self, true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneLogic(sender: AnyObject) {
        self.performSegueWithIdentifier("dash", sender: self)
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.profile.image = image;
        var file = PFFile(name: "picture.jpeg", data: UIImageJPEGRepresentation(image, 0.6));
        PFUser.currentUser()["picture"] = file;
        PFUser.currentUser()["first"] = false;
        PFUser.currentUser().saveInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            ProgressHUD.showSuccess(nil)
            self.done.hidden = false;
            if error != nil {
                ProgressHUD.showError("Problem Connecting!")
            }
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func signout(sender: AnyObject) {
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
        ProgressHUD.showSuccess(nil)
    }
}

