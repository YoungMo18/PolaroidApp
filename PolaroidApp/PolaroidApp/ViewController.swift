//
//  ViewController.swift
//  PolaroidApp
//
//  Created by Mo Young on 4/18/24.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func clearButton(_ sender: Any) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentPath = documentsURL.path
        
        do {
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            print(files)
            for file in files {
                try fileManager.removeItem(atPath: "\(documentPath)/\(file)")
            }
            counter = 0
        } catch {
            print("could not clear cache")
        }
    }
    
    @IBOutlet weak var frontImage: UIImageView!
    
//    @IBAction func buttonCamera(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera // Use .photoLibrary to select from gallery
//        picker.delegate = self
//        picker.allowsEditing = true
//        present(picker, animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
}
//
//extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        
//        picker.dismiss(animated: true, completion: nil)
//        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
//            return
//        }
//        let polaroidImage = applyPolaroidEffect(to: image)
//        frontImage.image = polaroidImage
//
//    }
//    
//    func applyPolaroidEffect(to image: UIImage) -> UIImage {
//        let context = CIContext(options: nil)
//        guard let filter = CIFilter(name: "CIPhotoEffectInstant") else { return image }
//        let beginImage = CIImage(image: image)
//        filter.setValue(beginImage, forKey: kCIInputImageKey)
//        guard let outputImage = filter.outputImage, let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
//        return UIImage(cgImage: cgImage)
//    }
//}

