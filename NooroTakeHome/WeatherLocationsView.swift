//
//  WeatherLocationsView.swift
//  NooroTakeHome
//
//  Created by אהרן שלמה אדלמן on 16/12/2024.
//

import SwiftUI

struct WeatherLocationsView: View {
    @EnvironmentObject var settings: WeatherSettings

    var body: some View {
        List(settings.weatherLocations) {location in
            VStack {
                Text(location.name)
                    .bold()
            }
            .padding(.all)
            .background(Color.gray.opacity(1.0 - 242/255))
            .cornerRadius(16.0)
            .onTapGesture {
                settings.weatherLocation = location
                settings.searchIsActive = false
            }
            
        } // List
    }
}

//#Preview {
//    WeatherLocationsView()
//}
