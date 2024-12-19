import SwiftUI

struct kartOyun: View {
    @State private var userCard: String = ""
    @State private var aiCard: String = ""
    @State private var userScore: Int = 0
    @State private var aiScore: Int = 0
    @State private var message: String = "Press Deal to start!"
    
    let allCards = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    let suit = "Kupa"
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                
              
                Text("Card Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                
                HStack {
                    VStack {
                        Text("Your Card")
                            .font(.headline)
                        if !userCard.isEmpty {
                            Image("\(suit)\(userCard)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        } else {
                            Rectangle()
                                .frame(width: 100, height: 150)
                                .foregroundColor(.gray)
                                .cornerRadius(10)
                        }
                    }
                    Spacer()
                    VStack {
                        Text("AI Card")
                            .font(.headline)
                        if !aiCard.isEmpty {
                            Image("\(suit)\(aiCard)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        } else {
                            Rectangle()
                                .frame(width: 100, height: 150)
                                .foregroundColor(.gray)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                
               
                Text(message)
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                
                HStack {
                    VStack {
                        Text("Your Score")
                        Text("\(userScore)")
                            .font(.title)
                            .bold()
                    }
                    Spacer()
                    VStack {
                        Text("AI Score")
                        Text("\(aiScore)")
                            .font(.title)
                            .bold()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
               
                HStack {
                   
                    Button(action: dealCards) {
                        Text("Deal")
                            .font(.title2)
                            .bold()
                            .frame(width: 120, height: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    Spacer()
                    
                    
                    Button(action: resetGame) {
                        Text("Reset")
                            .font(.title2)
                            .bold()
                            .frame(width: 120, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
    
   
    func dealCards() {
        userCard = allCards.randomElement() ?? ""
        aiCard = allCards.randomElement() ?? ""

        if cardValue(userCard) > cardValue(aiCard) {
            userScore += 1
            message = "You win this round!"
        } else if cardValue(aiCard) > cardValue(userCard) {
            aiScore += 1
            message = "AI wins this round!"
        } else {
            message = "It's a tie!"
        }
    }
    
   
    func cardValue(_ card: String) -> Int {
        switch card {
        case "A": return 11
        case "J": return 10
        case "Q": return 10
        case "K": return 10
        default: return Int(card) ?? 0
        }
    }

   
    func resetGame() {
        userCard = ""
        aiCard = ""
        userScore = 0
        aiScore = 0
        message = "Press Deal to start!"
    }
}

struct kartOyun_Previews: PreviewProvider {
    static var previews: some View {
        kartOyun()
    }
}
