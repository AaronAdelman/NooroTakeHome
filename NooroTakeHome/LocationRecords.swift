//
//  LocationRecords.swift
//  NooroTakeHome
//
//  Created by אהרן שלמה אדלמן on 16/12/2024.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherLocationData = try? JSONDecoder().decode(LocationRecords.self, from: jsonData)

import Foundation

// MARK: - LocationRecord
struct LocationRecord: Codable, Identifiable {    
    let url: String
    let id: Int
    let lat: Double
    let name: String
    let lon: Double
    let country, region: String
}

typealias LocationRecords = [LocationRecord]
