//
//  ImageUploader.swift
//  Qwiker-Driver
//
//  Created by Богдан Зыков on 01.11.2022.
//


import UIKit
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(withImage image: UIImage, completion: @escaping(String)-> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.85) else { return }
        let ref = Storage.storage().reference(withPath: "/profile_images/\(NSUUID().uuidString)")
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
