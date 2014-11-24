//
//  ProfileViewController.swift
//  USavvy
//
//  Created by Max Harris on 11/24/14.
//  Copyright (c) 2014 Max Harris. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var user = PFUser.currentUser()
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var uploadPictureButton: UIButton!

    
    var picker:UIImagePickerController? = UIImagePickerController()
    var popover:UIPopoverController? = nil
    
    @IBAction func uploadProfilePhoto(sender: AnyObject) {
        picker?.delegate = self
        
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        var gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(uploadPictureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        println("finished picking image")
        picker .dismissViewControllerAnimated(true, completion: nil)
        
        self.profileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.profileImageView.contentMode = UIViewContentMode.ScaleAspectFit
        //sets the selected image to image view
        
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        println("picker cancel.")
    }
    
    func openCamera() {
        println("opened camera")
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        println("opened gallery")
        
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(uploadPictureButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    @IBAction func changeEmail(sender: AnyObject) {
    }
    @IBAction func saveChanges(sender: AnyObject) {
        user["firstName"] = self.firstNameField.text
        user["lastName"] = self.lastNameField.text
        user["personalDescription"] = self.descriptionTextView.text
        user.saveInBackgroundWithBlock(nil)
        
        let imageData = UIImagePNGRepresentation(self.profileImageView.image)
        let imageFile = PFFile(name:"image.png", data:imageData)
        
        var userPhoto = PFObject(className:"UserPhoto")
        userPhoto["imageName"] = "\(user.email)\'s profile\'s image"
        userPhoto["imageFile"] = imageFile
        userPhoto.saveInBackgroundWithBlock(nil)
        
        user["profilePicture"] = imageFile
        user.saveInBackgroundWithBlock(nil)
        
        let alert = UIAlertView()
        alert.title = "Saved"
        alert.message = "Profile successfully updated"
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    @IBAction func logOutUser(sender: AnyObject) {
        PFUser.logOut()
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.setUpRootViewController(false, animated: false, alert: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLabel.text = user.email
        // making API calls each time I think. Could be stored in a user object to make better
        
        if let firstName = user["firstName"] as? String{
            self.firstNameField.text = firstName
        }
        if let lastName = user["lastName"] as? String {
            self.lastNameField.text = lastName
        }
        
        if let personalDescription = user["personalDescription"] as? String {
            self.descriptionTextView.text = personalDescription
        }
        
        if let userImageFile = user["profilePicture"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData!, error: NSError!) -> Void in
                if error == nil {
                    let image = UIImage(data:imageData)
                    self.profileImageView.image = image
                    println("retrieved image successfully")
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
