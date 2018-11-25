
import UIKit

class WeekDaysDisplayView: IBDesignableView {
    
    @IBOutlet var weekdays: [WeekDayButton] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.borderWidth = 1
        self.cornerRadius = 5
        self.borderColor = greenColor
    }
    
    //MARK: Public Methods
    func setActiveDays(days: [Int]?) {
        if days != nil {
            for button in weekdays {
                button.isSelected = days!.contains(button.tag)
            }
        }
    }
    
    func setFontSize(size: CGFloat) {
        for day in weekdays {
            day.titleLabel?.font = UIFont.systemFont(ofSize: size)
        }
    }
}
