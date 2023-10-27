//
//  Card.swift
//  Test2
//
//  Created by Robert Clowser on 10/27/23.
//

import Foundation

struct Card: Codable {
    var AddedAt:String
    var PublishedAt:String
    var channelId: String
    var filepath: String
    var id: String
    var json: String
    var length: String
    var watched: Int
    var youtuber: String
    var title: String?
}
