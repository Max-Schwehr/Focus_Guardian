//
//  ContractRetypeChecker.swift
//
//  Created by Maximiliaen Schwehr on 11/9/25.
//

import Foundation
import FoundationModels
import Swift

@Generable
struct ContractFeedBackOutput {
    @Guide(description: "This is the value I was telling you about in the prompt, if Text 1 and Text 2 are close matches return true, else false")
    var isValid : Bool
}


func isValidRetype(phraseToBeTyped: String, phraseTyped: String) async -> Bool {
    let instructions = """
Your job: Compare the intent of the two texts and decide true/false accordingly. If Text 2 represents the same meaning as text 1, return true. If text 2 represents a different meaning then Text 1 return false.

Spelling, and punctuation do NOT matter at all in text 2, and you may return true if this is the case (even if one words turns into another via a spelling mistake.)
"""
    
    let prompt = """
Now evaluate:
Text 1: "\(phraseToBeTyped)"
Text 2: "\(phraseTyped)"
"""
    let session = LanguageModelSession(instructions: instructions)
    
    do {
        let response = try await session.respond(
            to: prompt,
            generating: ContractFeedBackOutput.self
        )
        return response.content.isValid
    } catch {
        // If the AI model errors, treat as valid per request
        print("isValidRetype error: \(error). Defaulting to true.")
        return true
    }
}
