//
//  WeatherManager.swift
//  Clima
//
//  Created by Michael Chen on 12/24/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//                                             

import Foundation
import CoreLocation

//creating a protocal so any class that implement it need to have didUdateWea            ther method
//using this method to pass data back to view controller
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithError(error: Error)
}
        
struct WeatherManager {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=912a265861ecbf4f18dc14e26416e75d&units=imperial"
    
    //only something that have conformed to WeatherManagerDelegate can be assign to this
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String) {
        //1. Create a url
        
        if let url = URL(string: urlString){
            //2. Create a URLSession (like the browser)
            
            let session = URLSession(configuration: .default)
            
            //3. Give urlSession a task (fecthing data from source)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                //completion handler closure
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    //standard for encoding text in websites is ut8
                    //let dataString = String(data: safeData, encoding: .utf8)
                    
                    if let weather = parseJSON(safeData){
                        //whoever is the delegate of this weather manager in our case the weather view controller
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            //4. Start the task
            task.resume()
        }
    }
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        
        let decoder = JSONDecoder()
        
        do{
            //what type we want the data to be decoded into
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            print("weather id is \(decodedData.weather[0].id)")
            let id = decodedData.weather[0].id
            print("City temperature is \(decodedData.main.temp)")
            let temp = decodedData.main.temp
            print(decodedData.name)
            let name = decodedData.name
            
            let weather = WeatherModel(condtionId: id, cityName: name, temperature: temp)
            
            print("SF imaged used is \(weather.conditionName)")
            print(weather.temperatureString)
            
            return weather
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
    
    
    
    
    
    //completion handler method
    /*func handle(data: Data?, response: URLResponse?, error: Error?){
     
     if error != nil{
     print(error!.localizedDescription)
     return
     }
     
     if let safeData = data{
     //standard for encoding text in websites is ut8
     let dataString = String(data: safeData, encoding: .utf8)
     print(dataString)
     }
     
     }*/
    
}
