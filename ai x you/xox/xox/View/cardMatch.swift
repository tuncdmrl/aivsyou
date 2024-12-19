import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let emoji: String
    var isFlipped: Bool = false
    var isMatched: Bool = false
}

struct cardMatch: View {
    @State private var cards: [Card] = []
    @State private var flippedCards: [Int] = []
    @State private var scoreAI = 0
    @State private var scorePlayer = 0
    @State private var currentPlayer: String = "Player"
    @State private var isInteractionDisabled: Bool = false
    @State private var aiMemory: [Int: String] = [:] // AI's memory of cards

    let emojis = ["🍎", "🍎", "🍌", "🍌", "🍇", "🍇", "🍓", "🍓", "🍒", "🍒", "🍉", "🍉", "🥝", "🥝", "🍑", "🍑", "🍍", "🍍", "🥭", "🥭"].shuffled()
    
    init() {
        _cards = State(initialValue: emojis.map { Card(emoji: $0) })
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Memory Match")
                    .font(.largeTitle)
                    .padding()
                
                HStack {
                    Text("Player: \(scorePlayer)")
                    Spacer()
                    Text("AI: \(scoreAI)")
                }
                .padding()
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
                    ForEach(cards.indices, id: \..self) { index in
                        let card = cards[index]
                        CardView(card: card)
                            .onTapGesture {
                                if !isInteractionDisabled && currentPlayer == "Player" {
                                    handleTap(on: index)
                                }
                            }
                            .opacity(card.isMatched ? 0 : 1)
                    }
                }
                .padding()
                
                Button(action: resetGame) {
                    Text("Reset Game")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .onAppear(perform: aiTurn)
        }
    }
    func handleTap(on index: Int) {
        guard flippedCards.count < 2 else { return }
        guard !cards[index].isFlipped, !cards[index].isMatched else { return }

        cards[index].isFlipped.toggle()
        flippedCards.append(index)
        aiMemory[index] = cards[index].emoji // AI remembers the card

        if flippedCards.count == 2 {
            isInteractionDisabled = true
            checkMatch()
        }
    }

    func checkMatch() {
        let firstIndex = flippedCards[0]
        let secondIndex = flippedCards[1]

        if cards[firstIndex].emoji == cards[secondIndex].emoji {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                cards[firstIndex].isMatched = true
                cards[secondIndex].isMatched = true

                if currentPlayer == "Player" {
                    scorePlayer += 1
                } else {
                    scoreAI += 1
                }

                flippedCards.removeAll()
                isInteractionDisabled = false

                // Give extra turn if match is found
                if currentPlayer == "AI" {
                    aiTurn()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                cards[firstIndex].isFlipped = false
                cards[secondIndex].isFlipped = false
                flippedCards.removeAll()
                togglePlayer()
                isInteractionDisabled = false
            }
        }
    }

    func togglePlayer() {
        currentPlayer = (currentPlayer == "Player") ? "AI" : "Player"
        if currentPlayer == "AI" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                aiTurn()
            }
        }
    }

    func aiTurn() {
        guard currentPlayer == "AI" else { return }

        // AI logic: first check memory for matching cards
        let unmatchedCards = cards.indices.filter { !cards[$0].isMatched && !cards[$0].isFlipped }
        guard unmatchedCards.count >= 2 else { return }

        if let match = findMatchInMemory() {
            handleTap(on: match.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                handleTap(on: match.1)
            }
            return
        }

        // Otherwise, pick two random cards
        let firstPick = unmatchedCards.randomElement()!
        var secondPick = unmatchedCards.randomElement()!
        while firstPick == secondPick {
            secondPick = unmatchedCards.randomElement()!
        }

        handleTap(on: firstPick)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            handleTap(on: secondPick)
        }
    }

    func findMatchInMemory() -> (Int, Int)? {
        for (index1, emoji1) in aiMemory {
            for (index2, emoji2) in aiMemory where index1 != index2 && emoji1 == emoji2 {
                if !cards[index1].isMatched && !cards[index2].isMatched {
                    return (index1, index2)
                }
            }
        }
        return nil
    }

    func resetGame() {
        let newEmojis = ["🍎", "🍎", "🍌", "🍌", "🍇", "🍇", "🍓", "🍓", "🍒", "🍒", "🍉", "🍉", "🥝", "🥝", "🍑", "🍑", "🍍", "🍍", "🥭", "🥭"].shuffled()
        cards = newEmojis.map { Card(emoji: $0) }
        flippedCards.removeAll()
        scoreAI = 0
        scorePlayer = 0
        currentPlayer = "Player"
        isInteractionDisabled = false
        aiMemory.removeAll()
    }
}

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            if card.isFlipped {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                Text(card.emoji)
                    .font(.largeTitle)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
            }
        }
        .frame(width: 60, height: 80)
    }
}
#Preview {
    cardMatch()
}
