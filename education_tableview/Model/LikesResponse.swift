//
//  LikesResponse.swift
//  education_tableview
//
//  Created by OUT-Bolshakova-MM on 26.05.2020.
//  Copyright © 2020 OUT-Bolshakova-MM. All rights reserved.
//

import Foundation

struct LikeResponseWrapped: Decodable {
   let response: LikeResponse
}

struct LikeResponse: Decodable {
    let likes: Int?
}
