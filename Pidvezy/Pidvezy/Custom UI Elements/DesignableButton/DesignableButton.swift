

import UIKit

 @IBDesignable class DesignableButton: IBDesignableButton {
    
    @IBInspectable var color: UIColor = greenColor {
        didSet {
            self.layer.borderColor = color.cgColor
            self.setTitleColor(self.color, for: .normal)
        }
    }
    
    @IBInspectable var buttonBackground: UIColor = UIColor.white {
        didSet {
           self.layer.backgroundColor = buttonBackground.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }

}
