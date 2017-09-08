import UIKit

var ImageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    
    var lastUrl : String = ""
    
    func loadImage(_ urlString: String ){
        
        if let cacheImage = ImageCache[urlString] {
            self.image = cacheImage
            return
        }
        
        lastUrl = urlString
        guard let url = URL(string: urlString) else {return}
//        print("load image \(url)")
        
        
        
        URLSession.shared.dataTask(with: url) { (data, respond, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            print(self.lastUrl)
            print(url.absoluteString)
            if self.lastUrl != url.absoluteString {
                return
            }
            
            guard let data = data else {return}
            let image = UIImage(data: data)
            ImageCache[url.absoluteString] = image
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
}
