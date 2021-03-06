//
//  NetworkDataFetcher.swift
//  education_tableview
//
//  Created by OUT-Bolshakova-MM on 14.05.2020.
//  Copyright © 2020 OUT-Bolshakova-MM. All rights reserved.
//

import Foundation

protocol DataFetcer {
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    func getLike(isLiked: Bool, postId: String, sourceId: String, response: @escaping (LikeResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcer {
    
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var params = ["filters": "post, photo"]
        params["start_from"] = nextBatchFrom
        networking.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print (error.localizedDescription)
                response(nil)
            }
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    func getLike(isLiked: Bool, postId: String, sourceId: String, response: @escaping (LikeResponse?) -> Void) {
        let type = isLiked == true ? API.likeAdd : API.likeDelete
        let params = ["type" : "post", "item_id" : postId, "owner_id" : sourceId]
        networking.request(path: type, params: params) { (data, error) in
            if let error = error {
                print (error.localizedDescription)
                response(nil)
            }
            let decoded = self.decodeJSON(type: LikeResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    private func decodeJSON <T: Decodable> (type: T.Type, from: Data?) -> T? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
}
