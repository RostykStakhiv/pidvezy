

import UIKit

class TextFieldWithIcon: TextFieldView {
    
    @IBOutlet weak var leftIconIV: UIImageView!
    @IBInspectable var leftIconName: String = "" {
        didSet {
            self.leftIconIV.image = UIImage(named: leftIconName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if leftIconName.characters.count > 0 {
            self.leftIconIV.image = UIImage(named: leftIconName)
        }
    }

}
