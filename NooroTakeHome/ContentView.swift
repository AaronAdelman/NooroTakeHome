//
//  ContentView.swift
//  NooroTakeHome
//
//  Created by אהרן שלמה אדלמן on 15/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var settings = WeatherSettings()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            if !settings.weatherLocations.isEmpty && settings.searchIsActive {
                WeatherLocationsView()
            } else if settings.weatherLocation == nil {
                NoContentSelectedView()
            } else {
                WeatherView()
            }
        }
        .environmentObject(settings)
        .searchable(text: $searchText, isPresented: $settings.searchIsActive, prompt: "Search Location")
        .onChange(of: searchText) { oldValue, newValue in
            if !newValue.isEmpty {
                settings.searchIsActive = true
                Task {
                    await settings.fetchWeatherData(locationName: searchText)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
