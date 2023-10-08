//
//  WeatherData.swift
//  Clima
//
//  Created by Sanjay Singh on 04/07/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct Main: Decodable {
    var temp: Double
}

struct Weather: Decodable {
    var id: Int
    var description: String
}

struct WeatherData: Decodable {
    var name: String
    var weather: [Weather]
    var main: Main
}
