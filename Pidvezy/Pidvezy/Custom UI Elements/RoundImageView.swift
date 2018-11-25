
import UIKit

class RoundImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
    }

}
