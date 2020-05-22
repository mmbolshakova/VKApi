//
//  WebImageView.swift
//  education_tableview
//
//  Created by OUT-Bolshakova-MM on 18.05.2020.
//  Copyright © 2020 OUT-Bolshakova-MM. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {

    func set(imgageURL: String) {
        guard let url = URL(string: imgageURL) else {
            self.image = nil
            return }
        
        if let cahedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cahedResponse.data)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.image = UIImage(data: data)
                    self?.handleLoadedImage(data: data, response: response)
                }
            }
        } 
        dataTask.resume()
    }

    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        
        let cahedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cahedResponse, for: URLRequest(url: responseURL ))
    }
}
