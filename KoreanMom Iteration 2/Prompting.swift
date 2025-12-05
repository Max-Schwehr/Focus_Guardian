//
//  Prompting.swift
//  KoreanMom Iteration 2
//
//  Created by Maximiliaen Schwehr on 11/8/25.
//

import FoundationModels
import Playgrounds





#Playground {
    
    let instructions = """
Your job: Compare the intent of the two texts and decide true/false accordingly. If Text 2 represents the same meaning as text 1, return true. If text 2 represents a different meaning then Text 1 return false.

Spelling, and punctuation do NOT matter at all in text 2, and you may return true if this is the case (even if one words turns into another via a spelling mistake.)
"""
    
    let prompt = """
Now evaluate:
Text 1: "I Max Schwehr, hereby silence my phone, and will resist the siren song of Instagram!"
Text 2: "I max schwehr herby silcne my phone and will resist the siren song of Instrgam!"
"""
    
    
    
    let session = LanguageModelSession(instructions: instructions)
    
    let response = try await session.respond(
        to: prompt,
        generating: ContractFeedBackOutput.self
    )
    
    print(response.content)

}

/*
The app helps users focus. If the prompt matches well enough return true, else return false. Here are the criteria for matching well enough.

** Matches Well Enough -> Return True **
- Spelling Errors, (In Words, and User Name)
- Punctuation error
- Forgot to Add space, or to Many Spaces
- Capitalization
- Use of Common Sense (If the user tried its fine, return true)

** Does Not Match Well Enough -> Return False **
- Is missing a full word
- Did not Finish the sentence
- Changed words to new meanings (If it might be a misspelling, then disregard this bullet point)
- User Is trying to joke around
 */

