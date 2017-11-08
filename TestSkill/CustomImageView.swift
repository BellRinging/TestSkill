import UIKit

var ImageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    
    var lastUrl : String?
    
    func loadImage(_ urlString: String ){
        lastUrl = urlString
        self.image = nil
        if let cacheImage = ImageCache[urlString] {
//            print("get from cache path \(urlString)")
            self.image = cacheImage
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        print("download from internet path \(urlString)")
        URLSession.shared.dataTask(with: url) { (data, respond, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if self.lastUrl != url.absoluteString {
//                print("not map return")
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
