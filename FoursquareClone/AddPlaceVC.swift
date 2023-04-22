//
//  AddPlaceVC.swift
//  FoursquareClone
//
//  Created by Italo Stuardo on 18/4/23.
//

import UIKit

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var atmosphereText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchImage))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func searchImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
    }

    @IBAction func next(_ sender: Any) {
        if nameText.text != "", typeText.text != "", atmosphereText.text != "" {
            if let image = imageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = nameText.text!
                placeModel.placeType = typeText.text!
                placeModel.placeAtmosphere = atmosphereText.text!
                placeModel.placeImage = image
                performSegue(withIdentifier: "toMapVC", sender: nil)
            }
        } else {
            AlertModel.shared.alert(title: "Empty fields", message: "Please complete all the fields", view: self)
        }
    }
}
