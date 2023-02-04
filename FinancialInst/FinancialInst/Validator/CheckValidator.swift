//
//  CheckValidator.swift
//  FinancialInst
//
//  Created by Tomas Trujillo on 2023-02-01.
//

import Foundation
import RegexBuilder

struct CheckValidator {
  func parseEntry(_ entry: String) throws -> (Date, String, Double, String)? {
    let dateReference = Reference(Substring.self)
    let nameReference = Reference(Substring.self)
    let currencySymbolReference = Reference(Substring.self)
    let amountReference = Reference(Double.self)
    let accountReference = Reference(Substring.self)
    let separator = /\s{4}/
    let parser = Regex {
      Capture(as: dateReference) {
        NegativeLookahead(separator)
        OneOrMore(CharacterClass.any)
      }
      separator
      
      Capture(as: nameReference) {
        NegativeLookahead(separator)
        OneOrMore(CharacterClass.any)
      }
      separator
      
      Capture(as: currencySymbolReference) {
        OneOrMore {
          NegativeLookahead(CharacterClass.digit)
          CharacterClass.any
        }
      }
      Capture(as: amountReference) {
        One(.localizedDouble(locale: Locale(identifier: "en")))
      }
      separator
      
      Capture(as: accountReference) {
        One(/\d{3}-\d{4}-\d{8}/)
      }
    }
    guard let match = try parser.wholeMatch(in: entry) else { return nil }
    let dateString = String(match[dateReference])
    var date: Date?
    let currency = String(match[currencySymbolReference])
    switch currency {
    case "$":
      date = try? Date(dateString,
                       strategy: Date.ParseStrategy.date(.numeric, locale: Locale(identifier: "en_US"), timeZone: .gmt))
    case "CAD":
      date = try? Date(dateString,
                       strategy: Date.ParseStrategy(
                        format: "\(year: .padded(4))-\(month: .twoDigits)-\(day: .twoDigits)",
                        locale: Locale(identifier: "en_CA"),
                        timeZone: .gmt))
    default:
      date = nil
    }
    guard let date else { return nil }
    return (date, String(match[nameReference]),
            match[amountReference], String(match[accountReference]))
  }
}
