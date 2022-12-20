//
//  Image.swift
//  MusicPlr
//
//  Created by Denis Polishchuk on 23.09.2022.
//

import UIKit
import CoreImage

extension UIImage {
    static var nameSelectedImage: URL {
        let name = "selectedImage.png"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent(name)
        return path
    }
    
    func saveImageToFile() {
        let imageData = self.pngData()
        try? imageData?.write(to: UIImage.nameSelectedImage)
    }
}

extension UIImage {
    func addBlur(radious: Float) -> UIImage {
        let image = CIImage.init(image: self)
        let blurFilter = CIFilter.init(name: "CIGaussianBlur")
        blurFilter?.setValue(image, forKey: kCIInputImageKey)
        blurFilter?.setValue(radious, forKey: kCIInputRadiusKey)
        let outputImage = UIImage.init(ciImage: blurFilter!.outputImage!)
        return outputImage
    }
}
