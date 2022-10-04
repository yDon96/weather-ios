//
//  HistoricalWeather.swift
//  CloudyEye
//
//  Created by Youssef Donadeo on 04/10/22.
//

import Foundation

struct HistoricalWeatherRequest: Codable {
    var hour: String
    var weatherType: String
    var imageName: String
    var temperature: String
}


struct HistoricalWeatherResponse: Codable {
    var hour: String
    var weatherType: String
    var imageName: String
    var temperature: String
}

struct HistoricalWeather: Codable {
    let date: String
    let date_epoch: Double
    let astro: AstroInfo
    let mintemp: Int
    let maxtemp: Int
    let avgtemp: Int
    let totalsnow: Int
    let sunhour: Int
    let uv_index: Int
    let hourly: [HourWeather]
}

struct AstroInfo : Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moon_phase: String
    let moon_illumination: Int
}

struct CurrentWeather: Codable {
    let observation_time: String
    let temperature: Int
    let weather_code: Int
    let weather_icons: [String]
    let weather_descriptions: [String]
    let wind_speed: Int
    let wind_degree: Int
    let wind_dir: String
    let pressure: Int
    let precip: Int
    let humidity: Int
    let cloudcover: Int
    let feelslike: Int
    let uv_index: Int
    let visibility: Int
}

struct HourWeather: Codable {
    let time: String
    let temperature: Int
    let wind_speed: Int
    let wind_degree: Int
    let wind_dir: String
    let weather_code: Int
    let weather_icons: [String]
    let weather_descriptions: [String]
    let precip: Int
    let humidity: Int
    let visibility: Int
    let pressure: Int
    let cloudcover: Int
    let heatindex: Int
    let dewpoint: Int
    let windchill: Int
    let windgust: Int
    let feelslike: Int
    let chanceofrain: Int
    let chanceofremdry: Int
    let chanceofwindy: Int
    let chanceofovercast: Int
    let chanceofsunshine: Int
    let chanceoffrost: Int
    let chanceofhightemp: Int
    let chanceoffog: Int
    let chanceofsnow: Int
    let chanceofthunder: Int
    let uv_index: Int
}

struct WeatherLocation: Codable {
    let name: String
    let country: String
    let region: String
    let lat: String
    let lon: String
    let timezone_id: String
    let localtime: String
    let localtime_epoch: Double
    let utc_offset: String
}
