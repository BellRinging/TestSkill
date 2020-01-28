//
//  ImageView.swift
//  TestSkill
//
//  Created by Kwok Wai Yeung on 12/1/2020.
//  Copyright © 2020 Kwok Wai Yeung. All rights reserved.
//

import SwiftUI




class ImageLoader: ObservableObject {
    @Published var dataIsValid = false
    var data:Data?

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.dataIsValid = true
                self.data = data
            }
        }
        task.resume()
    }
}

func imageFromData(_ data:Data) -> UIImage {
    UIImage(data: data) ?? UIImage()
}

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        HStack{
            Image(uiImage: imageLoader.dataIsValid ? imageFromData(imageLoader.data!) : UIImage())
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .scaledToFit()
        }
    }
}


extension View {
    
    func standardImageStyle() -> some View {
        return ModifiedContent(content: self, modifier: StandardSize(width: 50, height: 50))
    }
}

struct StandardSize: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    
    func body(content: Content) -> some View {
        return content.frame(width: width, height: height)
    }
}

