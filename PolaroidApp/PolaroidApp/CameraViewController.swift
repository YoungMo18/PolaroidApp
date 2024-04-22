//
//  CameraViewController.swift
//  PolaroidApp
//
//  Created by Mo Young on 4/18/24.
//

import UIKit
import CoreData

var counter = 0
class CameraViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var polaroidImage: UIImageView!

    @IBOutlet weak var buttonCameraUI: UIButton!
    
    @IBAction func buttonCamera(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera // Use .photoLibrary to select from gallery
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    // Save imageData to filePath
    
    func getID() -> Int {
        return Int.random(in: 1..<100000)
    }
    
    func makeFilePath() -> URL {
        // Get access to shared instance of the file manager
        let id = getID()
        print(id)
        let fileManager = FileManager.default
        
        // Get the URL for the users home directory
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Get the document URL as a string
        let documentPath = documentsURL.path
        
        // Create filePath URL by appending final path component (name of image)
        let filePath = documentsURL.appendingPathComponent("\(String(id)).png")
        // Check for existing image data
        do {
            // Look through array of files in documentDirectory
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            
            for file in files {
                // If we find existing image filePath delete it to make way for new imageData
                if "\(documentPath)/\(file)" == filePath.path {
                    return makeFilePath()
                } else {
                    return filePath
                }
            }
        } catch {
            print("Could not add image from document directory: \(error)")
        }
        return filePath
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCameraUI.layer.cornerRadius = buttonCameraUI.frame.size.height/2
        buttonCameraUI.layer.borderWidth = 10
//        buttonCameraUI.layer.borderColor = UIColor.black.cgColor
        
        
        // Do any additional setup after loading the view.
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        let filterImage = applyPolaroidEffect(to: image)
        polaroidImage.image = filterImage
        
        // Save imageData to filePath
        let fp = makeFilePath()
        
        // Create imageData and write to filePath
        do {
            if let pngImageData = filterImage.pngData() {
                try pngImageData.write(to: fp, options: .atomic)
            }
        } catch {
            print("couldn't write image")
        }
        
        // Save filePath and imagePlacement to CoreData
        let container = appDelegate.persistentContainer
        let context = container.viewContext
        let entity = Image(context: context)
        entity.filePath = fp.path
        
        appDelegate.saveContext()
        
        
        
    }
    
    func applyPolaroidEffect(to image: UIImage) -> UIImage {
        let context = CIContext(options: nil)
        guard let filter = CIFilter(name: "CIPhotoEffectInstant") else { return image }
        let beginImage = CIImage(image: image)
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        return UIImage(cgImage: cgImage)
    }
}
