

import UIKit

class TextFieldWithLeftRightIcons: TextFieldWithIcon {
    
    @IBOutlet weak var rightIconIV: UIImageView!
    @IBOutlet weak var rightIconWidthConstraint: NSLayoutConstraint!
    
    @IBInspectable var rightIconName: String = "" {
        didSet {
             self.rightIconIV.image = UIImage(named: rightIconName)
        }
    }
    @IBInspectable var withRightIcon: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if withRightIcon {
            rightIconIV.image = UIImage(named: rightIconName)
        } else {
            rightIconWidthConstraint.constant = 0
        }
    }

}
