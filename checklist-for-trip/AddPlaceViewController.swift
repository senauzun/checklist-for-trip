//
//  AddPlaceViewController.swift
//  checklist-for-trip
//
//  Created by Sena Uzun on 15.10.2022.
//

import UIKit
import Parse

class AddPlaceViewController: UIViewController ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

            imageView.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)

        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
    }
    
    @objc func chooseImage(){
        let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
                self.dismiss(animated: true, completion: nil)
    }

    @IBAction func chooseLocationButtonClicked(_ sender: Any) {

        if placeName.text != "" && category.text != "" {
            
            if let chosenImage = imageView.image {
                let placemodel = PlaceModel.sharedInstance
                placemodel.placeName = placeName.text!
                placemodel.placeCategory = category.text!
                placemodel.placeImage = chosenImage
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Place name or category incorrect", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
    }
    
    @objc func backButtonClicked(){
        self.dismiss(animated: true)
    }
    

}
