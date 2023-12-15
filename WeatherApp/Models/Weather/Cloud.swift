//
//  Cloud.swift
//  WeatherApp
//
//  Created by Denis Abramov on 05.11.2023.
//

import Foundation

struct Cloud: Codable, Hashable {
    let all: Int?
    let uuid: String?

    enum CodingKeys: String, CodingKey {
        case all = "all"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        all = try values.decodeIfPresent(Int.self, forKey: .all)
        uuid = UUID().uuidString
    }
    
    static func == (lhs: Cloud, rhs: Cloud) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
