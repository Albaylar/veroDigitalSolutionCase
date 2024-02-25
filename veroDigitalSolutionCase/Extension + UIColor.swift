//
//  Extension + UIColor.swift
//  veroDigitalSolutionCase
//
//  Created by Furkan Deniz Albaylar on 23.02.2024.
//

import Foundation
import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
}
extension UIColor {
    func toHexString() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "#000000" 
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])

        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        return hexString
    }
}

