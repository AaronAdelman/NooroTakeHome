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
    @State private var searchIsActive = false
    
    var body: some View {
        NavigationStack {
            if settings.location == nil {
                NoContentSelectedView()
            } else {
                WeatherView()
            }
        }
        .environmentObject(settings)
        .searchable(text: $searchText, isPresented: $searchIsActive, prompt: "Search Location")
        .onChange(of: searchText) { oldValue, newValue in
            if !newValue.isEmpty {
                searchIsActive = true
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
