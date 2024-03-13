//
//  WeatherManager.swift
//  Clima
//
//  Created by Raghavendra Mirajkar on 12/03/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,_ weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=de94c5bc8e7a8c85c15fad76d4edc095&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude : CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJson(safeData) {
                        self.delegate?.didUpdateWeather(self,weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJson(_ weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let getData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = getData.weather[0].id
            let temp = getData.main.temp
            let city = getData.name
            let weatherModel = WeatherModel(conditionId: id, temperature: temp, cityName: city)
            return weatherModel
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
