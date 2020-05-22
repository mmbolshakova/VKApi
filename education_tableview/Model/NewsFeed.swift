//
//  NewsFeed.swift
//  education_tableview
//
//  Created by OUT-Bolshakova-MM on 15.05.2020.
//  Copyright © 2020 OUT-Bolshakova-MM. All rights reserved.
//

import Foundation

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var photoAttach: FeedSetPhotoViewModel?
        var getIconUrl: String
        var getName: String
        var getDate: String
        var getNewsText: String?
        var getLike: String?
        var getComment: String?
        var getShare: String?
        var getViews: String?
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttach: FeedSetPhotoViewModel {
        var photoUrl: String
        var photoHeight: Int
        var photoWidth: Int
    }
    var cells: [Cell]
}
