import Foundation
import RegexBuilder

struct Validator {
  static func validateEmail(_ email: String) -> Bool {
    let emailValidator = /[\w\-\.]+@+[\w]+\.+[a-z]{2,4}/
    guard let _ = try? emailValidator.wholeMatch(in: email) else { return false }
    return true
  }
  
  static func validateEmailWithRegexBuilder(_ email: String) -> Bool {
    let suffixReference = Reference(Substring.self)
    let emailValidator = Regex {
      OneOrMore(/[\w\-\.]/)
      One(Character("@"))
      OneOrMore(/[\w]/)
      One(Character("."))
      Capture(as: suffixReference) { OneOrMore(/[a-z]/) }
    }
    guard let match = try? emailValidator.wholeMatch(in: email) else { return false }
    return match[suffixReference].count >= 2 && match[suffixReference].count <= 4
  }
}

Validator.validateEmailWithRegexBuilder("dsadjskl@djsaklds.com")
Validator.validateEmailWithRegexBuilder("ds.ad.jskl@djsaklds.com")
Validator.validateEmailWithRegexBuilder("ds-ad-jskl@djsaklds.com")
Validator.validateEmailWithRegexBuilder("dsa&#@djsaklds.com")
Validator.validateEmailWithRegexBuilder("dsad@jskl@djsaklds.com")
Validator.validateEmailWithRegexBuilder("dsadjskl@djsaklds.m")
Validator.validateEmailWithRegexBuilder("dsadjskl@djsaklds.comidd")

fileprivate let entryOne = "05/12/2023    John Appleseed    $43,231.54    237-3218-32891823"
fileprivate let entryTwo = "2023-05-12    John Appleseed    CAD43,231.54    237-3218-32891823"

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
      One(.localizedDouble(locale: Locale(identifier: "en_US")))
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
                     strategy: Date.ParseStrategy.date(.numeric, locale: Locale(identifier: "en"), timeZone: .gmt))
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

try parseEntry(entryOne)
try parseEntry(entryTwo)
fileprivate let invalidEntryAccount = "2023-05-12    John Appleseed    CAD43,231.54    2321832891823"
fileprivate let invalidEntryDate = "20230512    John Appleseed    CAD43,231.54    237-3218-32891823"
fileprivate let invalidEntryMissing = "20230512   CAD43,231.54    237-3218-32891823"
try parseEntry(invalidEntryAccount)
try parseEntry(invalidEntryDate)
try parseEntry(invalidEntryMissing)
