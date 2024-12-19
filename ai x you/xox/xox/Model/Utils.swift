//
//  Utils.swift
//  xox
//
//  Created by tunc on 18.10.2024.
//

import Foundation

func checkWinner(list: [String], letter: String) -> Bool {
    let winningSequences = [
        [0, 1, 2], [3, 4, 5],[6, 7, 8],
        [0, 4, 8],[2, 4, 6],
        [0, 3, 6],[1, 4, 7],[2, 5, 8]
    ]
    
    for sequence in winningSequences {
        var score = 0
        
        for match in winningSequences{
            var score = 0
            
            for match in sequence{
                if list[match] == letter {
                    score += 1
                    
                    if score == 3 {
                        return true
                    }
                }
            }
        }
    }
    
    return false
}
