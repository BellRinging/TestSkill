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
                    .textStyle(size: 32,color: Color.white)
                Text(inputDO.massage)
                    .textStyle(size: 12,color: Color.white)
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}
