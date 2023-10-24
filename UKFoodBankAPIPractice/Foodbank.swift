//
//  Foodbank.swift
//  UKFoodBankAPIPractice
//
//  Created by Kimberly Brewer on 10/17/23.
//
import CoreLocation
import Foundation

struct Foodbank: Codable, Identifiable {
    // 1** note the distance (we're doing the same thing for items)
    enum CodingKeys: String, CodingKey {
        // these are the coding keys we care about
        case name, slug, phone, email, address, distance = "distance_m",
             items = "needs", alternativeItems = "need", locations, location = "lat_lng"
    }
    var id: String { slug }
    var name: String
    // btw you can skip items you don't want from the API call
    var slug: String // this is the unique identifier
    var phone: String
    var email: String
    var address: String
    // this property does not exist in the JSON
    // to make it work we need to tell swift how to map JSON name to our name (see note above 1**)
    var distance: Int?
    var items: Items?
    var alternativeItems: Items?
    var location: String
    var locations: [Location]?
    // this is so we can take the distance provided to us by the API
    // and convert it to something based on the user's preferences
    // (btw it comes to us from the API in meters)
    var distanceFormatted: String {
        // this was added because we had to make distance an optional above
        guard let distance else {
            return "Unknown distance from you"
        }
        let measurement = Measurement(value: Double(distance), unit: UnitLength.meters)
        // .wide means spell the whole word out (ie 'mile')
        let measurementString = measurement.formatted(.measurement(width: .wide))
        return "\(measurementString) from you)"
    }
    var actualItems: Items {
        items ?? alternativeItems ?? Items(id: "None", needs: "None")
    }
    // take the needs from the Item object, break it up by line breaks, then remove duplicates and sort results
    var neededItems: [String] {
        let baseList = actualItems.needs.components(separatedBy: .newlines)
        return Set(baseList).sorted()
    }
    var coordinate: CLLocationCoordinate2D? {
        let components = location.split(separator: ",").compactMap(Double.init)
        // if they are giving us not 2 coordinates something must be wrong
        guard components.count == 2 else { return nil }
        // if we're here we got back the 2 coordinates
        return CLLocationCoordinate2D(latitude: components[0], longitude: components[1])
    }
    static let example = Foodbank(name: "Ex Nam e", slug: "Ex Slug",
                                  phone: "555-5555", email: "no@no.com",
                                  address: "Ex Address", distance: 100, items: .example, location: "0,0")
}
// we're doing this work in an extension to 'hide it away neatly'
extension Foodbank {
    struct Items: Codable, Identifiable {
        var id: String
        var needs: String
        var excess: String?
        static let example = Items(id: "Example ID", needs: "Example Needed Item\nAnd Another One", excess: "")
    }
}
struct Location: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case name, slug, address, location = "lat_lng"
    }
    var id: String { slug }
    var name: String
    var slug: String
    var address: String
    var location: String
    
    var coordinate: CLLocationCoordinate2D? {
        let components = location.split(separator: ",").compactMap(Double.init)
        // if they are giving us not 2 coordinates something must be wrong
        guard components.count == 2 else { return nil }
        // if we're here we got back the 2 coordinates
        return CLLocationCoordinate2D(latitude: components[0], longitude: components[1])
    }
}
