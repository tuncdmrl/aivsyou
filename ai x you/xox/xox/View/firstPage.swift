import SwiftUI

struct FirstPage: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("You vs AI")
                        .bold()
                        .padding()
                        .font(.system(size: 25))

                    Spacer()

                    Text("Games")
                        .font(.title)
                        .bold()

                    VStack {
                        
                        HStack {
                            NavigationLink(destination: xoxcode()) { 
                                VStack{
                                    Image("xoxwal")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(30)
                                    Text("XOX")
                                }                }
                            NavigationLink(destination: cardMatch()) {
                                VStack{
                                    Image("matchgame")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(30)
                                    Text("Card Maching")
                                }
                            }
                        }
                        .padding()

                        
                        HStack {
                            NavigationLink(destination: renkTahmin()) {
                                VStack{
                                Image("color") // Renk tahmin oyunu
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(30)
                                    Text("Color Guess")
                                }
                            }
                                

                            NavigationLink(destination: kartOyun()) {
                                VStack{
                                    Image("kart")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(30)
                                    Text("Card Battles")
                                }
                            }
                        }
                        .padding()

                        
                       
                        
                    }

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    FirstPage()
}
