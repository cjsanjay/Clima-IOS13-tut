//
//  WeatherManager.swift
//  Clima
//
//  Created by Sanjay Singh on 04/07/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherApiRootUrl = "https://api.openweathermap.org/data/2.5/weather?appid=8788ebd9bf66a13babf3abc7ffaea7e6&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchTheApiData(cityName: String) {
        performRequest(urlString: "\(weatherApiRootUrl)&q=\(cityName)")
    }
    
    func fetchTheApiDataByLatLong(lat: String, long: String) {
        performRequest(urlString: "\(weatherApiRootUrl)&lat=\(lat)&lon=\(long)")
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) -> Void in
                if error != nil {
                    print (error!)
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let wm = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: wm)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(name: decodedData.name, code: decodedData.weather[0].id, temp: decodedData.main.temp, description: decodedData.weather[0].description)
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
