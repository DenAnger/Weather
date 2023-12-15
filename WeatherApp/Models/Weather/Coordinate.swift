//
//  Coordinate.swift
//  WeatherApp
//
//  Created by Denis Abramov on 28.11.2023.
//

import Foundation

struct Coordinate: Codable, Hashable {
    let latitude: Double?
    let longitude: Double?
    let uuid: String?

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        uuid = UUID().uuidString
    }
    
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
