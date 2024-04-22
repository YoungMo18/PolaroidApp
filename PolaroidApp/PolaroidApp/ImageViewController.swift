//
//  ImageViewController.swift
//  PolaroidApp
//
//  Created by Mo Young on 4/20/24.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView! {
        didSet {
            if isViewLoaded {
                updateImageView()
            }
        }
    }
    
    var imgView: UIImage?


    
    override func viewWillAppear(_ animated: Bool) {
        updateImageView()
        if (self.imageView.image != nil) {
            super.viewWillAppear(animated)
        }
        print("ImageViewController loaded.")
        
    }
    
    private func updateImageView() {
        Task {
            if (imgView != nil) {
                DispatchQueue.main.async { // Always update UI on the main thread
                    if let img = self.imgView {
                        self.imageView.image = img
                        print("🔥 Image successfully loaded.")
                    } else {
                        print("Image is nil.")
                    }
                }
                
            }
        }
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
