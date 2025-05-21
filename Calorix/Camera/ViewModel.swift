//
//  ViewModel.swift
//  Calorix
//
//  Created by Kai Zheng on 5/13/25.
//

import Foundation
import CoreImage
import AVFoundation
import UIKit

// create a new viewmodel for each time you want to take a picture
// in cameraview, have viewmodel in the environment, and also have a binding for the nutrition form fill out data
@Observable
class ViewModel {
    let cameraManager = CameraManager()
    var currentFrame: CGImage?
    var currentPhoto: AVCapturePhoto?
    var imageData: Data?
    var nutritionData: NutritionData?
    
    
    init() {
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }

    }
    
    func handleCameraPreviews() async {
        for await image in cameraManager.previewStream {
            Task { @MainActor in
                currentFrame = image
            }
        }
    }
    
    func handleCameraPhotos() async {
        
        for await avPhoto in cameraManager.photoStream {
            Task { @MainActor in
                currentPhoto = avPhoto
                imageData = avPhoto.fileDataRepresentation()
                guard let imageData = imageData else { return }
                nutritionData = await getNutritionData(from: UIImage(data: imageData)?.jpegData(compressionQuality:0.5) ?? imageData)
                
                print(nutritionData)
            }
        }
    }
}
