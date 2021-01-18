//
//  WeatherData.swift
//  Clima
//
//  Created by Michael Chen on 12/25/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//weather data can decode itself from external representation (JSON)  ->Decodable
//if want weather data to encode itself to JSON  -> Encodable
//Codable is type alias for both
//this model is made base off of the json response, the json response has a field call name, etc

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}



//the json response has a field call main with a property of temp
struct Main: Codable {
    let temp: Double
}

//the json response has a field call weather that is a array of weather objects with a id property
struct Weather: Codable {
    let id: Int
}

