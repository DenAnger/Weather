//
//  System.swift
//  WeatherApp
//
//  Created by Denis Abramov on 28.11.2023.
//

import Foundation

struct System: Codable, Hashable {
    var id: Int?
    var type: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise)
        sunset = try values.decodeIfPresent(Int.self, forKey: .sunset)
    }
    
    static func == (lhs: System, rhs: System) -> Bool {
        return lhs.id == rhs.id
    }
}
