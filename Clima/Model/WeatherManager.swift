//
//  WeatherManager.swift
//  Clima
//
//  Created by Raghavendra Mirajkar on 12/03/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=de94c5bc8e7a8c85c15fad76d4edc095&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String){
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    parseJson(data: safeData)
                }
            }
            //4. Start the task
            task.resume()
        }
    
    }
    
    func parseJson(data : Data){
        let decoder = JSONDecoder()
        do {
            let getData = try decoder.decode(WeatherData.self, from: data)
            let id = getData.weather[0].id
            let temp = getData.main.temp
            let city = getData.name
            let weatherModel = WeatherModel(conditionId: id, temperature: temp, cityName: city)
            print(weatherModel)
            print(weatherModel.conditionName)
            print(weatherModel.temperatureString)
        } catch {
            print("error!")
        }
        
    }

    
}
