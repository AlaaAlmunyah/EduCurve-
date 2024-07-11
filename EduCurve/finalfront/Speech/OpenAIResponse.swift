//
//  OpenAIResponse.swift
//  finalfront
//
//  Created by Alaa A on 05/01/1446 AH.
//

import Foundation

struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}
