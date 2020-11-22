//
//  NewPlaceTVC.swift
//  MyPlaces
//
//  Created by Павел Чернышев on 21.11.2020.
//

import UIKit

class NewPlaceTVC: UITableViewController {

    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var nameOfPlace: UITextField!
    @IBOutlet weak var locationOfPlace: UITextField!
    @IBOutlet weak var typeOfPlace: UITextField!
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    var isImageChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        saveBtn.isEnabled = false
        nameOfPlace.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
    }

    // MARK: Tavle view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let alertSheet = UIAlertController(title: nil,
                                               message: nil,
                                               preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _  in
                self?.imagePicker(sourceType: .camera)
            }
            let cameraIcon = UIImage(systemName: "camera")
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
                self?.imagePicker(sourceType: .photoLibrary)
            }
            let photoIcon = UIImage(systemName: "photo")
            photo.setValue(photoIcon, forKey: "Image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertSheet.addAction(camera)
            alertSheet.addAction(photo)
            alertSheet.addAction(cancel)
            
            present(alertSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
    
    func buildPlace() -> Place {
        if !isImageChanged {
            imageOfPlace.image = UIImage(named: "MyAssets/imagePlaceholder@2x.png")
        }
        return Place(name: nameOfPlace.text ?? "", location: locationOfPlace.text, type: typeOfPlace.text, image: imageOfPlace.image, imageName: nil)
    }
    
    @IBAction func cancleTaped(_ sender: Any) {
        dismiss(animated: true)
    }
}
// MARK: Text field delegate
extension NewPlaceTVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func nameChanged() {
        self.saveBtn.isEnabled = nameOfPlace.hasText
    }
}

// MARK: UIImagePicker
extension NewPlaceTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.isImageChanged = true
        self.imageOfPlace.image = info[.editedImage] as? UIImage
        self.imageOfPlace.contentMode = .scaleAspectFill
        self.imageOfPlace.clipsToBounds = true
        dismiss(animated: true)
    }
}