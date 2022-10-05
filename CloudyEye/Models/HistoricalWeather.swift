//
//  HistoricalWeather.swift
//  CloudyEye
//
//  Created by Youssef Donadeo on 04/10/22.
//

import Foundation

struct ForecastWeatherRequest: Codable {
    let latitude: Float
    let longitude: Float
    let hourly: [String]?
    let daily: [String]?
    let current_weather: Bool?
    let temperature_unit: String?
    let windspeed_unit: String?
    let precipitation_unit: String?
    let timeformat: String?
    let timezone: String?
    let past_days: Int?
    let start_date: String?
    let end_date: String?
}


struct ForecastWeatherResponse: Codable {
    let latitude: Float
    let longitude: Float
    let elevation: Float
    let generationtime_ms: Float
    let utc_offset_seconds: Int
    let timezone: String
    let timezone_abbreviation: String
    let current_weather: CurrentWeather
    let hourly: HourlyWeather
    let hourly_units: HourlyUnitWeather
}

struct CurrentWeather: Codable {
    let time: String
    let temperature: Float
    let windspeed: Float
    let winddirection: Float
    let weathercode: Int
}

struct HourlyWeather: Codable {
    let time: [String]
    let temperature_2m: [Float]
    let weathercode: [Int]
}

struct HourlyUnitWeather: Codable {
    let temperature_2m: String
}
