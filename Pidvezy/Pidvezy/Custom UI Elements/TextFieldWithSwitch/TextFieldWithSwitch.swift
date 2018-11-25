

import UIKit

class TextFieldWithSwitch: TextFieldWithIcon {

    @IBOutlet weak var choiceSwitch: UISwitch!
    
    @IBInspectable var switchEnabled: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.choiceSwitch.isOn = switchEnabled
    }
    
}
