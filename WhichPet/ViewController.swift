//
//  ViewController.swift
//  WhichPet
//
//  Created by Emre Çolak on 20.12.2021.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        // Do any additional setup after loading the view.
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            
            guard let ciImage = CIImage(image: pickedImage) else {
                fatalError("Can not convert UIImage to CIImage")
            }
            
            detect(petImage: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(petImage: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: PetImageClassifier().model) else {
            fatalError("Can not fetch model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Can not fetch result error")
            }
            
            if let firstResult = result.first {
                
                if firstResult.identifier.contains("Dog") {
                    self.navigationItem.title = "Dog"
                } else if firstResult.identifier.contains("Cat") {
                    self.navigationItem.title = "Cat"
                } else if firstResult.identifier.contains("Rabbit") {
                    self.navigationItem.title = "Rabbit"
                }
                
            }
            print(result)
            
        }
        
        let handler = VNImageRequestHandler(ciImage: petImage)

        
        do {
           try handler.perform([request])
        } catch {
           print(error)
        }
        
        
        
    }

    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

