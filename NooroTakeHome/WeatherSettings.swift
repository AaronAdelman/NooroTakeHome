//
//  WeatherSettings.swift
//  NooroTakeHome
//
//  Created by אהרן שלמה אדלמן on 15/12/2024.
//

import Foundation

class WeatherSettings: ObservableObject {
    @Published var location: String?
}

extension WeatherSettings {
    private static let apiKey = "32b913b7451b44608c6125401241512"
    
    func fetchWeatherData(locationName: String) async {
        fetchWeatherData(locationName: locationName, completion: {result
            in
            
            switch result {
            case .success(let data):
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        print("Response JSON: \(json)")
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }

                
            case .failure(let error):
                debugPrint("Failure:  ", error)
            }
            
        })
    }
    
    func fetchWeatherData(locationName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        // Construct the URL string
        let urlString = "https://api.weatherapi.com/v1/search.json?key=\(WeatherSettings.apiKey)&q=\(locationName)"
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
