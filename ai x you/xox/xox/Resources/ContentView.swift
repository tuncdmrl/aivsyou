import SwiftUI
struct ContentView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            if isActive {
                FirstPage()
            } else {
                VStack {
                    Text("You vs AI")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                }
                .onAppear {
                   
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isActive = true
                    }
                }
            }
        }
    }
}




#Preview {
    ContentView()
}
