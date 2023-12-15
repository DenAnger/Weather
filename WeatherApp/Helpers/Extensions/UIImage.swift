//
//  UIImage.swift
//  WeatherApp
//
//  Created by Denis Abramov on 02.12.2023.
//

import UIKit

//extension UIImage {
//    convenience init?(url: URL?) {
//        
//        guard let remoteUrl = url else { return nil }
//        
//        do {
//            self.init(data: try Data(contentsOf: remoteUrl))
//        } catch {
//            print("Cannot load image from url: \(remoteUrl) with error: \(error)")
//            return nil
//        }
//    }
//}


extension UIImageView {
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
        
            guard let data = data, let image = UIImage(data: data) else {
                print("Cannot load image from URL: \(url.absoluteString), error: \(error?.localizedDescription ?? "")")
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}


extension UIImage {
    convenience init?(url: URL) {
        do {
            let imageData = try Data(contentsOf: url)
            self.init(data: imageData)
        } catch {
            print("Cannot load image from URL: \(url), error: \(error)")
            return nil
        }
    }
}
