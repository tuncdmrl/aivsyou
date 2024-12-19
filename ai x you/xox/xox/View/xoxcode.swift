import SwiftUI

struct xoxcode: View {
    
    @State private var moves = ["", "", "", "", "", "", "", "", ""]
    @State private var endGameText = "TicTacToe"
    @State private var gameEnded = false
    private var ranges = [(0..<3), (3..<6), (6..<9)]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(endGameText)
                    .alert(endGameText, isPresented: $gameEnded) {
                        Button("Reset", role: .destructive, action: resetGame)
                    }
                
                Spacer()
                
                ForEach(ranges, id: \.self) { range in
                    HStack {
                        ForEach(range, id: \.self) { i in
                            XOButton(letter: $moves[i])
                                .simultaneousGesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            playerTap(index: i)
                                        }
                                )
                        }
                    }
                }
                Spacer() 
                
                Button("RESET", action: resetGame)
            }
        }
    }
    
    func playerTap(index: Int) {
        if moves[index] == "" {
            moves[index] = "X"
            if checkWinner(list: moves, letter: "X") {
                endGameText = "X has won"
                gameEnded = true
            } else {
                botMove()
            }
            checkDraw()
        }
    }
    
    func checkDraw() {
        if !moves.contains("") {
            endGameText = "It's a draw!"
            gameEnded = true
        }
    }
    
    func botMove() {
        // oncelik kazanma hamleleri
        if let winningMove = findWinningMove(for: "O") {
            moves[winningMove] = "O"
        } else if let blockingMove = findWinningMove(for: "X") {
            moves[blockingMove] = "O"
        } else {
            
            // randomly
            var availableMoves: [Int] = []
            var movesLeft = 0
            
            for move in moves {
                if move == "" {
                    availableMoves.append(movesLeft)
                }
                movesLeft += 1
            }
            
            if availableMoves.count != 0 {
                moves[availableMoves.randomElement()!] = "O"
            }
        }
        
        if checkWinner(list: moves, letter: "O") {
            endGameText = "AI has won"
            gameEnded = true
        }
        checkDraw()
    }
    
    func findWinningMove(for letter: String) -> Int? {
        let winningCombinations: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]            // Diagonals
        ]
        
        for combo in winningCombinations {
            let positions = combo.map { moves[$0] }
            if positions.filter({ $0 == letter }).count == 2 && positions.contains("") {
                return combo[positions.firstIndex(of: "")!]
            }
        }
        return nil
    }
    
    func checkWinner(list: [String], letter: String) -> Bool {
        let winningCombinations: [[Int]] = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]            // Diagonals
        ]
        
        for combo in winningCombinations {
            if list[combo[0]] == letter && list[combo[1]] == letter && list[combo[2]] == letter {
                return true
            }
        }
        return false
    }
    
    func resetGame() {
        endGameText = "TicTacToe"
        moves = ["", "", "", "", "", "", "", "", ""]
    }
    
    func minimax(board: [String], depth: Int, isMaximizing: Bool) -> Int {
        if checkWinner(list: board, letter: "O") {
            return 10 - depth
        }
        if checkWinner(list: board, letter: "X") {
            return depth - 10
        }
        if !board.contains("") {
            return 0
        }
        
        if isMaximizing {
            var bestScore = Int.min
            for i in 0..<board.count {
                if board[i] == "" {
                    var tempBoard = board
                    tempBoard[i] = "O"
                    let score = minimax(board: tempBoard, depth: depth + 1, isMaximizing: false)
                    bestScore = max(bestScore, score)
                }
            }
            return bestScore
        } else {
            var bestScore = Int.max
            for i in 0..<board.count {
                if board[i] == "" {
                    var tempBoard = board
                    tempBoard[i] = "X"
                    let score = minimax(board: tempBoard, depth: depth + 1, isMaximizing: true)
                    bestScore = min(bestScore, score)
                }
            }
            return bestScore
        }
    }
}



struct xoxcode_Previews: PreviewProvider {
    static var previews: some View {
        xoxcode()
    }
}
