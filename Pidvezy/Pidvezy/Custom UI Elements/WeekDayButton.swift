
import UIKit
import QuartzCore

class WeekDayButton: IBDesignableButton {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = greenColor
                self.setTitleColor(UIColor.white, for: .normal)
            } else {
                self.backgroundColor = UIColor.white
                self.setTitleColor(greenColor, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = 0.5
        self.titleLabel?.lineBreakMode = .byClipping
    }

}
