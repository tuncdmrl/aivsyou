import SwiftUI

struct renkTahmin: View {
    @State private var targetColor = Color.random()
    @State private var aiGuessColor = Color.white
    @State private var userGuessColor = Color.white
    @State private var aiScore = 0
    @State private var userScore = 0
    @State private var rounds = [(aiAccuracy: Double, userAccuracy: Double)]()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("AI vs You")
                    .font(.largeTitle)
                    .bold()
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(targetColor)
                    .frame(height: 200)
                    .overlay(Text("Target Color")
                        .foregroundColor(.white)
                        .bold())
                
                HStack {
                    VStack {
                        Text("AI Guess")
                            .font(.headline)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(aiGuessColor)
                            .frame(width: 50, height: 50)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Your Guess")
                            .font(.headline)
                        RoundedRectangle(cornerRadius: 5)
                            .fill(userGuessColor)
                            .frame(width: 50, height: 50)
                    }
                }
                .padding()
                
                ColorPicker("Select Your Color", selection: $userGuessColor, supportsOpacity: false)
                    .padding()
                    .labelsHidden()
                
                Button(action: {
                    calculateScores()
                    startNextRound()
                }) {
                    Text("VS")
                        .font(.title2)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                HStack {
                    VStack {
                        Text("AI Score: \(aiScore)")
                            .bold()
                        Text("Last AI Guess: \(lastAiAccuracy, specifier: "%.1f%%")")
                    }
                    Spacer()
                    VStack {
                        Text("Your Score: \(userScore)")
                            .bold()
                        Text("Last Your Guess: \(lastUserAccuracy, specifier: "%.1f%%")")
                    }
                }
                .padding()
                
                if let winner = winner {
                    Text("Winner: \(winner)")
                        .font(.title)
                        .foregroundColor(.red)
                }
                
                ScrollView {
                    ForEach(rounds.indices, id: \ .self) { index in
                        let round = rounds[index]
                        HStack {
                            Text("Round \(index + 1):")
                            Spacer()
                            Text("AI: \(round.aiAccuracy, specifier: "%.1f%%")")
                            Spacer()
                            Text("You: \(round.userAccuracy, specifier: "%.1f%%")")
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            aiGuessColor = Color.randomNear(targetColor)
        }
    }

    private func calculateScores() {
        let aiDistance = aiGuessColor.distance(to: targetColor)
        let userDistance = userGuessColor.distance(to: targetColor)

        let aiAccuracy = max(0, (1 - aiDistance) * 100)
        let userAccuracy = max(0, (1 - userDistance) * 100)

        if aiAccuracy > userAccuracy {
            aiScore += 1
        } else {
            userScore += 1
        }

        rounds.append((aiAccuracy: aiAccuracy, userAccuracy: userAccuracy))
    }

    private func startNextRound() {
        if winner == nil {
            targetColor = Color.random()
            aiGuessColor = Color.randomNear(targetColor) 
        }
    }

    private var lastAiAccuracy: Double {
        rounds.last?.aiAccuracy ?? 0
    }

    private var lastUserAccuracy: Double {
        rounds.last?.userAccuracy ?? 0
    }

    private var winner: String? {
        if aiScore >= 10 { return "AI" }
        if userScore >= 10 { return "You" }
        return nil
    }
}

extension Color {
    static func random() -> Color {
        Color(red: .random(in: 0...1),
              green: .random(in: 0...1),
              blue: .random(in: 0...1))
    }

    static func randomNear(_ target: Color, variation: CGFloat = 0.2) -> Color {
        guard let targetRGBA = target.toRGBA() else {
            return .random()
        }
        let randomize: (CGFloat) -> CGFloat = { value in
            max(0, min(1, value + .random(in: -variation...variation)))
        }
        return Color(red: randomize(targetRGBA.red),
                     green: randomize(targetRGBA.green),
                     blue: randomize(targetRGBA.blue))
    }

    func distance(to color: Color) -> CGFloat {
        guard let lhs = self.toRGBA(), let rhs = color.toRGBA() else {
            return 1.0
        }
        return sqrt(pow(lhs.red - rhs.red, 2) + pow(lhs.green - rhs.green, 2) + pow(lhs.blue - rhs.blue, 2))
    }

    func toRGBA() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        return (red, green, blue, alpha)
    }
}

extension UIColor {
    convenience init(_ color: Color) {
        self.init(cgColor: color.cgColor ?? UIColor.clear.cgColor)
    }
}

#Preview {
    renkTahmin()
}
