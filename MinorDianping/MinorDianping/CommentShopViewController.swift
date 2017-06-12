//
//  CommentShopViewController.swift
//  MinorDianping
//
//  Created by Apple on 17/5/23.
//  Copyright © 2017年 NJU.EE. All rights reserved.
//

import UIKit
import os.log

class CommentShopViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var restaurant: Restaurant?
    //var shop: Shop?
    let user = CurrentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.delegate = self
        
        navigationItem.title = restaurant?.name
        shopNameLabel.text = restaurant?.name
        
        updateSaveButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITextField
    //move keyboard to avoid covering textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 250), animated: true)
        
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        
        updateSaveButtonState()
    }
    
    //hide keyboard when pressing somewhere outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //hide keyboard when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        commentTextField.resignFirstResponder()
        return true
    }

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        commentTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The CommentShopViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        // change evaluation, evaluationNum
        let dbEvaluationNum = Double((restaurant?.evaluationNum)!)
        let dbRating = Double(ratingControl.rating)
        restaurant?.evaluation = ((restaurant?.evaluation)! * dbEvaluationNum + dbRating) / (dbEvaluationNum + 1)
        restaurant?.evaluationNum = (restaurant?.evaluationNum)! + 1
        
        // comments
        if (restaurant?.comments) != nil {
            restaurant?.comments = (restaurant?.comments)! + commentTextField.text! + "<n>" + user.getUserName() + "<c>"
        } else {
            restaurant?.comments = commentTextField.text! + "<n>" + user.getUserName() + "<c>"
        }
        
        /////
        print(user.getUserName())
        /////
        
        //save comment, evaluation, evaluationNum in core data
        let restaurantDBC = RestaurantDatabaseController()
        //restaurantDBC.addEvaluation(resName: (restaurant?.name!)!, evaluation: Double(ratingControl.rating))
        
        // modify comments, evaluation, evaluationNum
        restaurantDBC.modifyAttribute(des: &restaurant!.comments, src: restaurant?.comments)
        restaurantDBC.modifyAttribute(des: &restaurant!.evaluation, src: (restaurant?.evaluation)!)
        restaurantDBC.modifyAttribute(des: &restaurant!.evaluationNum, src: restaurant!.evaluationNum)
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the comment field is empty and rating is empty.
        if commentTextField.text != "" {
            saveButton.isEnabled = true
        }else {
            saveButton.isEnabled = false
        }
    }
}
