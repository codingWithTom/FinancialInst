//
//  EmailValidator.swift
//  FinancialInst
//
//  Created by Tomas Trujillo on 2023-01-30.
//

import Foundation
import RegexBuilder

struct EmailValidator {
  static func validateEmail(_ email: String) -> Bool {
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
