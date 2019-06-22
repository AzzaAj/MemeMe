//
//  ViewController.swift
//  Meme 1.0
//
//  Created by Azza on 4/15/19.
//  Copyright © 2019 Azza. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var top: UITextField!
    @IBOutlet weak var bottom: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //MARK Text style
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    //Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        shareButtonIsEnabled(value: false) }
    
    //MARK configure textField
    func configure(_ textField: UITextField, with defaultText: String) {
        textField.text = defaultText
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        
    }
    //Share Button enabled/disabled
    func shareButtonIsEnabled(value: Bool){
        shareButton.isEnabled = value
    }
    //MARK hide bars
    func configureBars(_ isHidden: Bool) {
        navBar.isHidden = isHidden
        toolBar.isHidden = isHidden
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(top, with: "TOP")
        configure(bottom, with: "BOTTOM")
        shareButtonIsEnabled(value: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        //MARK disable Camera if the device does not have one
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK pick an image function
    func pickAnImage(from source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
        shareButtonIsEnabled(value: true)
    }
    
    //MARK Function to Pick Image from Album
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(from: .photoLibrary)

    }
    //MARK Function to Pick Image from Camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(from: .camera)
    }
    
    //Function for share Button
    @IBAction func shareButton(_ sender: Any){
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {textField.text = ""}
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottom.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
    func generateMemedImage() -> UIImage {
        
        configureBars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
         configureBars(false)
        
        return memedImage
    }
    func save() {
        let meme = Meme(
            topText:top.text!,bottomText: bottom.text!,originalImage: self.imagePickerView.image!,memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    
    @IBAction func Share(_ sender: Any) {
        let sharedImage = generateMemedImage()
        // generate the meme
        let activityController = UIActivityViewController(activityItems:    [sharedImage], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.save()
               self.dismiss(animated: true, completion: nil)
            }
            
        }
       
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        imagePickerView.image = nil
        top.text = "TOP"
        bottom.text = "BOTTOM"
        shareButtonIsEnabled(value: false)
        self.dismiss(animated: true, completion: nil)

    }
    
}

