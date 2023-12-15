//
//  Wind.swift
//  WeatherApp
//
//  Created by Denis Abramov on 28.11.2023.
//

import Foundation

struct Wind: Codable, Hashable {
    let speed: Double?
    let degrees: Int?
    let uuid: String?

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case degrees = "deg"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        speed = try values.decodeIfPresent(Double.self, forKey: .speed)
        degrees = try values.decodeIfPresent(Int.self, forKey: .degrees)
        uuid = UUID().uuidString
    }
    
    static func == (lhs: Wind, rhs: Wind) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
