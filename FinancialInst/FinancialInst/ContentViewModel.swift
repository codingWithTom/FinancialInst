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
  
  func validateEmail() {
    message = "Invalid email"
    checkInfo = nil
  }
  
  func payload1() {
    message = nil
    createCheckInfo(date: nil, name: nil, amount: nil, accountNumber: nil)
  }
  
  func payload2() {
    message = nil
    createCheckInfo(date: nil, name: nil, amount: nil, accountNumber: nil)
  }
  
  func invalidPayload() {
    message = nil
    createCheckInfo(date: nil, name: nil, amount: nil, accountNumber: nil)
  }
  
  func clear() {
    email = ""
    message = nil
    checkInfo = nil
  }
}

private extension ContentViewModel {
  func createCheckInfo(date: Date?, name: String?, amount: Double?, accountNumber: String?) {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    let currency = NumberFormatter()
    currency.locale = Locale(identifier: "en_us")
    checkInfo = .init(date: formatter.string(from: date ?? Date()),
                      name: name ?? "",
                      amount: currency.string(from: NSNumber(value: amount ?? 0.0)) ?? "$0.00",
                      accountNumber: accountNumber ?? "")
  }
}

struct CheckInformation {
  let date: String
  let name: String
  let amount: String
  let accountNumber: String
}

