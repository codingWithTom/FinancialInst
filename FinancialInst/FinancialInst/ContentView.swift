//
//  ContentView.swift
//  FinancialInst
//
//  Created by Tomas Trujillo on 2023-01-30.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = ContentViewModel()
  @FocusState private var focused
  
  var body: some View {
    VStack {
      TextField("Enter email", text: $viewModel.email)
        .textFieldStyle(.roundedBorder)
        .padding(.top)
        .focused($focused)
        
      Spacer()
      
      if let message = viewModel.message {
        Text(message)
          .font(.headline)
      }
      
      if let checkInfo = viewModel.checkInfo {
        CheckInfoView(info: checkInfo)
      }
      
      Spacer()
      
      VStack(spacing: 8.0) {
        HStack {
          Button("Validate Email", action: viewModel.validateEmail)
          Spacer()
          Button("Payload 1", action: viewModel.payload1)
        }
        HStack {
          Button("Payload 2", action: viewModel.payload2)
          Spacer()
          Button("Invalid Payload", action: viewModel.invalidPayload)
        }
        Button("Clear", action: viewModel.clear)
          .foregroundColor(.red)
      }
    }
    .padding()
    .contentShape(Rectangle())
    .onTapGesture { focused = false }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

private struct CheckInfoView: View {
  let info: CheckInformation
  
  var body: some View {
    VStack {
      Text("Check information")
        .font(.title)
      HStack {
        Text("Date:")
          .font(.headline)
        Text(info.date)
          .font(.body)
      }
      HStack {
        Text("Name:")
          .font(.headline)
        Text(info.name)
          .font(.body)
      }
      HStack {
        Text("Amount:")
          .font(.headline)
        Text(info.amount)
          .font(.body)
      }
      HStack {
        Text("Account #:")
          .font(.headline)
        Text(info.accountNumber)
          .font(.body)
      }
    }
    
  }
}
