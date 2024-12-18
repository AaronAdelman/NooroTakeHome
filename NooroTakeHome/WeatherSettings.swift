//
//  WeatherSettings.swift
//  NooroTakeHome
//
//  Created by אהרן שלמה אדלמן on 15/12/2024.
//

import Foundation
import SwiftUI

class WeatherSettings: ObservableObject, @unchecked Sendable {
    private let weatherLocationKey = "weatherLocation"
    
    @Published var locations: LocationRecords = []
    @Published var location: LocationRecord? {
        didSet {
            let json = try? JSONEncoder().encode(location)
            
            UserDefaults.standard.set(json, forKey: weatherLocationKey)
            locations = []
            weatherData = nil
            
            Task {
                await fetchWeatherRecord(latitude: location?.lat ?? 0.0, longitude: location?.lon ?? 0.0, completion: {result
                    in
                    
                    switch result {
                    case .success(let data):
//                        debugPrint(String(decoding: data, as: UTF8.self))
                        let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data)
//                        debugPrint("Weather Data:  ", weatherData as Any)
                        DispatchQueue.main.async {
                            self.weatherData = weatherData
                        }
                        
                    case .failure(let error):
                        debugPrint("Failure:  ", error)
                    }
                })
            }
        }
    }
    
    @Published var weatherData: WeatherData?
    
    @Published var searchIsActive = false
    
    init() {
        locations = []
        searchIsActive = false
        
        let json = UserDefaults.standard.object(forKey: "weatherLocation")
        if json != nil {
            location = try? JSONDecoder().decode(LocationRecord.self, from: json as! Data)
        }
    }
}

extension WeatherSettings {
    private static let apiKey = "32b913b7451b44608c6125401241512"
    
    func fetchLocationRecords(locationName: String) async {
        await fetchLocationRecords(locationName: locationName, completion: {result
            in
            
            switch result {
            case .success(let data):
                    let locationData = try? JSONDecoder().decode(LocationRecords.self, from: data)
                DispatchQueue.main.async {
                    self.locations = locationData ?? []
                }
                
            case .failure(let error):
                debugPrint("Failure:  ", error)
            }
            
        })
    }
    
    func fetchLocationRecords(locationName: String, completion: @escaping (Result<Data, Error>) -> Void) async {
        // Construct the URL string
        let urlString = "https://api.weatherapi.com/v1/search.json?key=\(WeatherSettings.apiKey)&q=\(locationName)"
//        debugPrint(urlString)
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: [NSLocalizedDescriptionKey: "The URL is invalid."])))
            return
        }

        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Handle request error
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // Handle invalid HTTP response
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                completion(.failure(NSError(domain: "HTTPError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response code: \(statusCode)"])))
                return
            }

            guard let data = data else {
                // Handle missing data
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from the server."])))
                return
            }

            // Return the data in the completion handler
            completion(.success(data))
        }

        // Start the network request
        task.resume()
    }
    
    func fetchWeatherRecord(latitude: Double, longitude: Double, completion: @escaping (Result<Data, Error>) -> Void) async {
        // Construct the URL string
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(WeatherSettings.apiKey)&q=\(latitude),\(longitude)&days=1&aqi=no&alerts=no"
        debugPrint(urlString)
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: [NSLocalizedDescriptionKey: "The URL is invalid."])))
            return
        }

        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Handle request error
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // Handle invalid HTTP response
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                completion(.failure(NSError(domain: "HTTPError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response code: \(statusCode)"])))
                return
            }

            guard let data = data else {
                // Handle missing data
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from the server."])))
                return
            }

            // Return the data in the completion handler
            completion(.success(data))
        }

        // Start the network request
        task.resume()
    }
    
}
