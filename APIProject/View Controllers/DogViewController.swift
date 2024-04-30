//
//  DogViewController.swift
//  APIProject
//
//  Created by Jordan Fraughton on 4/25/24.
//

import UIKit

class DogViewController: UIViewController {
    let dogController = DogController()
    
    @IBOutlet weak var dogImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        dogImageView.image = UIImage(systemName: "photo.on.rectangle")
        loadNewImage()
    }

    func updateUI(with dog: Dog) {
        Task {
            do {
                let image = try await dogController.fetchDogPhoto(from: dog.imageURL)
                dogImageView.image = image
            } catch {
                print(error)
            }
        }
    }
    
    func loadNewImage() {
        Task {
            do {
                let dog = try await dogController.fetchDogInfo()
                updateUI(with: dog)
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func newImageButtonTapped(_ sender: UIButton) {
        loadNewImage()
    }
}
