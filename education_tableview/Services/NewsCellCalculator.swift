//
//  NewsCellCalculator.swift
//  education_tableview
//
//  Created by OUT-Bolshakova-MM on 20.05.2020.
//  Copyright © 2020 OUT-Bolshakova-MM. All rights reserved.
//

import Foundation
import UIKit

struct Sizes: FeedCellSizes {
    var newsTextFrame: CGRect
    var attachmentFrame: CGRect
}

struct Constants {
    static let cardInsets = UIEdgeInsets(top: 0, left: 0, bottom: 12 , right: 0)
    static let profilePhotoHeight: CGFloat = 60
    static let newsTextInsets = UIEdgeInsets(top: 10 + Constants.profilePhotoHeight + 10 , left: 10, bottom: 10, right: 10)
    static let newsFont = UIFont.systemFont(ofSize: 16)
    static let bottomViewHeight: CGFloat = 45
}

protocol NewsCellCalculatorProtocol {
    func sizes(postText: String?,  photoAttach: FeedSetPhotoViewModel?) -> FeedCellSizes
}

final class NewsCellCalculator: NewsCellCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttach: FeedSetPhotoViewModel?) -> FeedCellSizes {
        
        let cardViewWidth = screenWidth
        
        // MARK: NewsTextFrame        
        var newsTextFrame = CGRect(origin: CGPoint(x: Constants.newsTextInsets.left, y: Constants.newsTextInsets.top),
                                   size: CGSize.zero)
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.newsTextInsets.left - Constants.newsTextInsets.right
            let height = text.height(width: width, font: Constants.newsFont)
            
            newsTextFrame.size =  CGSize(width: width, height: height)
        }
        
        
        //MARK: AttachmentFrame
        let attachmentTop = newsTextFrame.size == CGSize.zero ? Constants.newsTextInsets.top: newsTextFrame.maxY + Constants.newsTextInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)
        if let attachment = photoAttach {
            let ratio = Float(attachment.photoHeight) / Float(attachment.photoWidth)
            attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ratio))
        }
        
        
        return Sizes(newsTextFrame: newsTextFrame,
                     attachmentFrame: attachmentFrame)
    }
     
}
