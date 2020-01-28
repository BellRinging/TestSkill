import SwiftUI

struct Page  {

    let title : String
    let massage : String
    let image : Image
    
    
    init(title: String, image : Image,massage:String) {
        self.title = title
        self.massage = massage
        self.image = image
        
    }
}
