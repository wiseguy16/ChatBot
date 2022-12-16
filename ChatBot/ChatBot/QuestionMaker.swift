//
//  QuestionMaker.swift
//  
//
//  Created by GWE48A on 12/7/22.
//

import Foundation

class QuestionMaker {
  
  static func askChatBot(question: String, model: String) async throws -> ChatResponseModel {
    try await askChatBot(human: question, model: model)
  }
  
  private static func askChatBot(human: String, model: String) async throws -> ChatResponseModel {
    let token = "{your-API-key}"
    
    let url = "https://api.openai.com/v1/completions"
    guard let serviceUrl = URL(string: url) else { throw URLError(.badURL) }
    
    let params: [String: Any] = [
      "prompt": "Human: \(human)",
      "model": model,
      "temperature": 0.9,
      "max_tokens": 250,
      "top_p": 1,
      "frequency_penalty": 0,
      "presence_penalty": 0.6,
      "stop": [" Human:", " AI:"]
    ]
    
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Application/json", forHTTPHeaderField: "Accept")
    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
    guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
      throw URLError(.badServerResponse)
    }
    request.httpBody = httpBody
    let (d, r) = try await URLSession.shared.data(for: request)
    guard let response = r as? HTTPURLResponse, 200...299 ~= response.statusCode else {
      throw URLError(.badServerResponse)
    }
    do {
      let ans = try JSONDecoder().decode(ChatResponseModel.self, from: d)
      return ans
    } catch {
      debugPrint(error.localizedDescription)
      throw URLError(.badServerResponse)
    }

  }
}
