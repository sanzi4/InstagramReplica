//
//  UploadingPhotoViewController.swift
//  Instagram
//
//  Created by Sanzida Sultana on 10/22/20.
//

import UIKit
import Parse
//import AlmofireImage

class UploadingPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var userCaption: UITextView!
    @IBOutlet weak var userPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Post the user Image
    @IBAction func UploadingImage(_ sender: Any) {
        
        // New object
        let post = PFObject(className: "Posts")
        
        post["caption"] = userCaption.text!
        post["author"] = PFUser.current()!
        
        let imageData = userPhoto.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        // url to the posted image
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            
            // Able to save the uploaded photo in storage
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved successfully !!! :) ")
            } else {
                print("Error")
            }
        
        
        }
    }
    
    
    // Brings the Photo Album/ Camera
    @IBAction func onCameraButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // if we can use the camera
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        
            // if not use the photo libary
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    // load the user selected picture into the image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.editedImage] as! UIImage
        
        // if the our image needs to be scaled
        let size = CGSize(width: 300, height: 300)
        let scaledImage = selectedImage.af_imageAspectScaled(toFill: size)
        
        userPhoto.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }

}
