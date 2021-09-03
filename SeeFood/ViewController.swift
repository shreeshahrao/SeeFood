//
//  ViewController.swift
//  SeeFood
//
//  Created by Shreesha on 03/09/21.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var ImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            ImageView.image  = userPickedImage
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Cannot Convert image")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    func detect(image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Failed")
        }
        let request = VNCoreMLRequest(model: model) { (request , error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "It's a HOTDOG!"
                } else if firstResult.identifier.contains("pizza"){
                    self.navigationItem.title = "It's a PIZZA"
                    
                }
                else {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion:  nil)
    }
    
}

