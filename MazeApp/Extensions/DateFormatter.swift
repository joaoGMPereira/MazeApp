//
//  DateFormatter.swift
//  MazeApp
//
//  Created by Joao Gabriel Pereira on 13/06/22.
//

import Foundation
enum AppDateFormatter {
    static let formatter = DateFormatter()
    static func format(_ string: String) -> String {
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: string) {
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter.string(from: date)
        }
        return string
    }
}
