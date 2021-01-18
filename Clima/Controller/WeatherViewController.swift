//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    //912a265861ecbf4f18dc14e26416e75d
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*locationManager will report/notify WeatherViewController of any changes
         NEED TO BE SET BEFORE THE LOCATION IS REQUESTED OR APP WILL CRASH!
         */
        locationManager.delegate = self
        
        //asking user for permission to use their location and requesting the location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //textField will report/notify WeatherViewController of any changes
        searchTextField.delegate = self
        
        //weatherManager will report/notify WeatherViewController of any changes
        weatherManager.delegate = self
    }
    
    
    //the result of request location is retrived in location Manager didUpdateLocations method at end of file
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    

    
}


//MARK: - UITextFieldDelegate

/*creating an extension for weatherViewController that has all things releated to textField so
actual view controller class above is more clean
 */
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        searchTextField.endEditing(true)    //dismiss the keyboard
        print(searchTextField.text!)
        
    }
    
    /*logic for what happens when the return/go key is pressed on keyboard,
     function is part of UITextFieldDelegate
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)      //dismiss the keyboard
        print(searchTextField.text!)
        return true
    }
    
    
    //what happen when a user deselect the text field/dismiss the keyboard, validation check of what user typed
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        else{
            textField.placeholder = "Type a place"
            return false        //don't allow user to dismiss the keyboard
        }
    }
    
    
    //user stopped editing/typing in the text field, trigger when searchTextField.endEditing(true) is called
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        //use searchField.text to get the weather for that city
        
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}


//MARK: - WeatherManagerDelegate

/*creating an extension for weatherViewController that has all things releated to weather data so
 actual view controller class above is more clean
 */
extension WeatherViewController: WeatherManagerDelegate {
    
    //identity of object that cause this deleagte method -> weatherManager
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        //need to get on main thread to update UI
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
}



//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
