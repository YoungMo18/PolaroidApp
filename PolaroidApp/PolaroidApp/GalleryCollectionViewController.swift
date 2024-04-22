//
//  GalleryCollectionViewController.swift
//  PolaroidApp
//
//  Created by Mo Young on 4/18/24.
//

import UIKit
import CoreData

var images: [Image] = []
private let reuseIdentifier = "dataCell"
var indexCell = 0
class GalleryCollectionViewController:
    UICollectionViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func clearButton(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete all images permanently?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.clearImagesAndRefreshUI()
        }))
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImagesAndUpdateUI()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width/3) - 3, height: (view.frame.size.height/3) - 3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        fetchImagesAndUpdateUI()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImageView", let data = sender as? (IndexPath, UIImage), let ImageViewController = segue.destination as? ImageViewController {
            // Set the image to the destination's imageView
            ImageViewController.imgView = data.1
        }
        //        if segue.identifier == "toImageView", let indexPath = sender as? IndexPath {
        //            let selectedImage = images[indexPath.row]
        //            if let ImageViewController = segue.destination as? ImageViewController {
        //                print("INSIDE TRUE")
        //                //                ImageViewController.indexImage = 29
        //                let filePath = selectedImage.filePath
        //                if FileManager.default.fileExists(atPath: filePath!),
        //                   let image = UIImage(contentsOfFile: filePath!) {
        //                    print(image)
        //                    ImageViewController.imgView = image
        //                    print("hi: \(ImageViewController.imgView!)")
        //                    print("Image set for segue to ImageViewController")
        //                }
        //            }
        //        }
    }
    
    //    func fetchSegueData(from filePath: String) {
    //        DispatchQueue.global(qos: .userInitiated).async {
    //            if FileManager.default.fileExists(atPath: filePath!), let image = UIImage(contentsOfFile: filePath) {
    //                        DispatchQueue.main.async {
    //                            self.image = image
    //                            self.performSegue(withIdentifier: "showDetail", sender: self)
    //                        }
    //                    }
    //                }
    //    }
    
    
    func loadImageAsync(filePath: String) async -> UIImage? {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                if let image = UIImage(contentsOfFile: filePath) {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        // Assuming fetchCoreData() is adapted to store results in a property `images`
        if indexPath.row < images.count {
            let image = images[indexPath.row]
            if let filePath = image.filePath, FileManager.default.fileExists(atPath: filePath) {
                cell.polaroidImageView.image = UIImage(contentsOfFile: filePath)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Fetch image asynchronously and segue to ImageViewController
        if let filePath = images[indexPath.row].filePath, FileManager.default.fileExists(atPath: filePath) {
            Task {
                if let image = await loadImageAsync(filePath: filePath) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toImageView", sender: (indexPath, image))
                    }
                }
            }
        }
    }
    
    
    func clearImagesAndRefreshUI() {
        deleteAllImagesFromCoreData()  // This will handle Core Data deletion
        images = []  // Clear the array
        DispatchQueue.main.async {
            self.collectionView.reloadData()  // Reload the collection view to update the UI
        }
    }
    
    func deleteAllImagesFromCoreData() {
        let container = appDelegate.persistentContainer
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Image")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("All images deleted from Core Data.")
        } catch {
            print("Failed to delete images: \(error)")
        }
    }
    
    func fetchImagesAndUpdateUI() {
        Task {
            images = await fetchCoreData()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchCoreData() async -> [Image] {
        let container = appDelegate.persistentContainer
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<Image>(entityName: "Image")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch images: \(error)")
            return []
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displaye.d for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

