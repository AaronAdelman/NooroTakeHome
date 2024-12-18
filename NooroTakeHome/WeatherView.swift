//
//  WeatherView.swift
//  NooroTakeHome
//
//  Created by אהרן שלמה אדלמן on 15/12/2024.
//

import SwiftUICore

struct WeatherView: View {
    @EnvironmentObject var settings: WeatherSettings

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(settings.location?.name ?? "???")
                .padding()
            
            let tempC = settings.weatherData?.current.tempC
            if tempC != nil {
                HStack(alignment: .top) {
                    Text(String(format: "%.01f", tempC!))
                        .font(.largeTitle)
                    Text("°")
                }
                .padding()
            }
        }
    }
}
    
