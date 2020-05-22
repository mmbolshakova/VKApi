 //
//  FeedResponse.swift
//  education_tableview
//
//  Created by OUT-Bolshakova-MM on 14.05.2020.
//  Copyright © 2020 OUT-Bolshakova-MM. All rights reserved.
//

import Foundation

 protocol ProfileRepresentable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
 }
 struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
 }
 
 struct FeedResponse: Decodable {
    var items: [FeedItem]
    var profiles: [Profile]
    var groups: [Group]
    var nextFrom: String?
 }

 struct Profile: Decodable, ProfileRepresentable {
    var name: String { return firstName + " " + lastName}
    
    var photo: String { return photo100}
    
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
 }
 
 struct Group: Decodable, ProfileRepresentable {
    var photo: String { return photo100}
    
    let id: Int
    let name: String
    let photo100: String
 }
 
 struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attachment]?
 }
 
 struct Attachment: Decodable {
    let photo: Photo?
 }
 
 struct Photo: Decodable {
    let sizes: [PhotoSize]
    var height: Int {
        return getSize().height
    }
    var width: Int {
        return getSize().width
    }
    var srcBig: String {
        return getSize().url
    }
    
    
    private func getSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x"}) {
            return sizeX
        }
        else if let sizeZ = sizes.last {
            return sizeZ
        }
        else {
         return PhotoSize(type: "wrong img", url: "wrong url", height: 0, width: 0)
        }
    }
 }
 
 struct PhotoSize: Decodable {
    let type: String
    let url: String
    let height: Int
    let width: Int
 }
 
 struct CountableItem: Decodable {
    let count: Int
 }
