//
//  GeojsonProvider.swift
//  events-app-swiftui-uikit-lifecycle
//
//  Created by Gürhan Kuraş on 6/12/22.
//

import Foundation
import MapKit
import os

protocol GeoJsonProvider {
    func load(completion: (Result<[MKGeoJSONFeature], Error>) -> ())
}

enum GeoJsonError: Error {
    case fileNotFound(String)
    case wrongFormattedFile
    case couldntRead
}

class GeoJsonFileReader: GeoJsonProvider {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: GeoJsonFileReader.self))
    let address: (country: String, city: String)

    init(address: (country: String, city: String)) {
        self.address = address
    }
    
    func load(completion: (Result<[MKGeoJSONFeature], Error>) -> ()) {
        Self.logger.debug("Reading geojson file...")
        guard !address.city.isEmpty else {
            completion(.failure(GeoJsonError.fileNotFound("")))
            return
        }
        guard let geoJsonFileUrl = Bundle.main.url(forResource: address.city, withExtension: "geojson") else {
            completion(.failure(GeoJsonError.fileNotFound(address.city)))
            return
        }
        guard let geoJsonData = try? Data.init(contentsOf: geoJsonFileUrl) else {
            completion(.failure(GeoJsonError.couldntRead))
            return
        }
        guard let features = try? MKGeoJSONDecoder().decode(geoJsonData) as? [MKGeoJSONFeature] else {
            completion(.failure(GeoJsonError.wrongFormattedFile))
            return
        }
        completion(.success(features))
    }
}
