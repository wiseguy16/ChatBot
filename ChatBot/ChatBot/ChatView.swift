//
//  ChatView.swift
//  MFAScraps
//
//  Created by GWE48A on 12/10/22.
//

import SwiftUI

struct ChatView: View {
  @State private var question = ""
  @State private var answer = ""
  @State private var isProcessing = false
  @State private var botUsing = "text-davinci-003"
  var bots = ["text-davinci-003", "text-curie-001"]
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 8) {
          
          VStack {
            Picker("What model would you like to use?", selection: $botUsing) {
              ForEach(bots, id: \.self) {
                Text($0)
              }
            }
            .pickerStyle(.segmented)
            
            Text("Using: \(botUsing)")
          }
          .padding(12)
          
          Text("Ask me anything!").padding(.horizontal).padding(.top)
          TextField("Ask me anything!", text: $question, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
          
          HStack {
            Button(action: {
              isProcessing = false
              question = ""
              answer = ""
            }, label: {
              Text("Reset")
            }).buttonStyle(.borderedProminent)
      
            Spacer()
            Button(action: {
              UIApplication.shared.endEditing()
              submitQuestion()
              isProcessing = true
            }, label: {
              Text("Submit")
            }).buttonStyle(.borderedProminent)
          }.padding()
          HStack {
            Spacer()
            if isProcessing {
              ProgressView()
            }
            Spacer()
          }
          
          Text("AI response:").padding(.horizontal)
          Text(answer).padding(.horizontal)
        }
      }
      .background(Color(.lightGray).opacity(0.2))
      .navigationTitle("ChatBot")
      .onAppear {
        
      }
    }
  }
  
  func submitQuestion() {
    let ask = self.question
    askBot(q: ask)
  }
  
  func askBot(q: String) {
    Task {
      do {
        let ans = try await QuestionMaker.askChatBot(question: q, model: botUsing)
        await MainActor.run {
          
          for c in ans.choices {
            answer = c.text
            isProcessing = false
          }
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
}

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
}
