//
//  Localization.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 07.01.2021.
//

import Foundation

// Возвращает текущую дату в локализованном формате
func getDateLocaleFormat(_ date: Date) -> String {
    let template = "yMMMMd"
    let localeDateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.current)!
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = localeDateFormat
    //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return dateFormatter.string(from: date)
}
