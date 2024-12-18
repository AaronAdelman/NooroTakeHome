//
//  WeatherView.swift
//  NooroTakeHome
//
//  Created by אהרן שלמה אדלמן on 15/12/2024.
//

import SwiftUICore
import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var settings: WeatherSettings

    var body: some View {
        let iconString: String? = settings.weatherData?.current.condition.icon
        VStack {
            if iconString != nil {
                AsyncImage(url: URL(string: "https:" + iconString!))
            }

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
    
