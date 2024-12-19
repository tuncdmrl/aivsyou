
import SwiftUI

struct aiChat: View {
    var body: some View {
        
        ZStack {
            
           
                LinearGradient(gradient: Gradient(colors: [Color.orange, Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

            
            Text("Coming Soon")
                .bold()
                .padding()
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
        }
    }
}

#Preview {
    aiChat()
}
