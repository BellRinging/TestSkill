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
    var image : UIImage?
    static var cache: ImageCacheType = ImageCache()

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        if let image = ImageLoader.cache.image(for: url){
            DispatchQueue.main.async {
                self.dataIsValid = true
                self.image = image
            }
        }else{
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                let image = UIImage(data: data) ?? UIImage()
                ImageLoader.cache.insertImage(image, for: url)
                DispatchQueue.main.async {
                    self.dataIsValid = true
                    self.image = image
                }
            }
            task.resume()
        }
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        HStack{
            Image(uiImage: imageLoader.dataIsValid ? imageLoader.image! : UIImage())
                .renderingMode(.original)
                .resizable()
                .clipShape(Circle())
        }
    }
}


extension View {
    
    func standardImageStyle() -> some View {
        return ModifiedContent(content: self, modifier: StandardSize(width: 40, height: 40))
    }
    
    func ImageStyle(size : CGFloat) -> some View {
          return ModifiedContent(content: self, modifier: StandardSize(width: size, height: size))
      }
}

struct StandardSize: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    
    func body(content: Content) -> some View {
        return content.frame(width: width, height: height)
    }
}

