//
//  ChatResponseModel.swift
//  
//
//  Created by GWE48A on 12/10/22.
//

import Foundation

// MARK: - ChatResponseModel
struct ChatResponseModel: Codable {
  let id, object: String
  let created: Int
  let model: String
  let choices: [Choice]
  let usage: Usage
}

// MARK: - Choice
struct Choice: Codable {
  let text: String
  let index: Int
  let logprobs: String?
  let finishReason: String
  
  enum CodingKeys: String, CodingKey {
    case text, index, logprobs
    case finishReason = "finish_reason"
  }
}

// MARK: - Usage
struct Usage: Codable {
  let promptTokens, completionTokens, totalTokens: Int
  
  enum CodingKeys: String, CodingKey {
    case promptTokens = "prompt_tokens"
    case completionTokens = "completion_tokens"
    case totalTokens = "total_tokens"
  }
}
