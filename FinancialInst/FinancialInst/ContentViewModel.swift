//
//  ContentViewModel.swift
//  FinancialInst
//
//  Created by Tomas Trujillo on 2023-01-30.
//

import Foundation
import SwiftUI

final class ContentViewModel: ObservableObject {
  @Published var email: String = ""
  @Published var message: String?
  @Published var checkInfo: CheckInformation?
  private lazy var checkValidator = CheckValidator()
  
  func validateEmail() {
    message = EmailValidator.validateEmail(email) ? "Valid Email!" : "Invalid email"
    checkInfo = nil
  }
  
  func payload1() {
    message = nil
    guard let match = try? checkValidator.parseEntry(entryOne) else {
      checkInfo = nil
      message = "Invalid Check Entry"
      return
    }
    createCheckInfo(date: match.0, name: match.1, amount: match.2, accountNumber: match.3)
  }
  
  func payload2() {
    message = nil
    guard let match = try? checkValidator.parseEntry(entryTwo) else {
      checkInfo = nil
      message = "Invalid Check Entry"
      return
    }
    createCheckInfo(date: match.0, name: match.1, amount: match.2, accountNumber: match.3)
  }
  
  func invalidPayload() {
    guard let match = try? checkValidator.parseEntry(invalidEntryDate) else {
      checkInfo = nil
      message = "Invalid Check Entry"
      return
    }
    createCheckInfo(date: match.0, name: match.1, amount: match.2, accountNumber: match.3)
  }
  
  func clear() {
    email = ""
    message = nil
    checkInfo = nil
  }
}

private extension ContentViewModel {
  func createCheckInfo(date: Date, name: String, amount: Double, accountNumber: String) {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    let currency = NumberFormatter()
    currency.locale = Locale(identifier: "en_us")
    checkInfo = .init(date: formatter.string(from: date),
                      name: name,
                      amount: currency.string(from: NSNumber(value: amount)) ?? "$0.00",
                      accountNumber: accountNumber)
  }
}

struct CheckInformation {
  let date: String
  let name: String
  let amount: String
  let accountNumber: String
}

fileprivate let entryOne = "05/12/2023    John Appleseed    $43,231.54    237-3218-32891823"
fileprivate let entryTwo = "2023-05-12    John Appleseed    CAD43,231.54    237-3218-32891823"
fileprivate let invalidEntryAccount = "2023-05-12    John Appleseed    CAD43,231.54    2321832891823"
fileprivate let invalidEntryDate = "20230512    John Appleseed    CAD43,231.54    2321832891823"
fileprivate let invalidEntryMissing = "20230512   CAD43,231.54    2321832891823"

