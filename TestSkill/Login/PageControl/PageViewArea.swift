/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that shows a featured landmark.
*/

import SwiftUI




struct PageViewArea: View {
    var inputDO: Page
    
    var body: some View {
        inputDO.image
            .resizable()
            .aspectRatio(3/2, contentMode: .fit)
            .overlay(TextOverlay(inputDO:inputDO))
    }
}

struct TextOverlay: View {
    var inputDO: Page
    
    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [SwiftUI.Color.black.opacity(0.6), SwiftUI.Color.black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle().fill(gradient)
            VStack(alignment: .leading) {
                Text(inputDO.title)
                    .font(MainFont.condensedBold.size(32))
                Text(inputDO.massage)
                    .font(MainFont.medium.size(12))
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

struct PageViewArea_Previews: PreviewProvider {
    static var previews: some View {
        
        PageViewArea(inputDO: Page(title: "This is title", image: Image("player1"), massage: "This is message"))
    }
}
