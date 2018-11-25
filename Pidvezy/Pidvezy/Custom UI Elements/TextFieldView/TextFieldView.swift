

import UIKit

class TextFieldView: IBDesignableView {
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBInspectable var placeholder: String?
    @IBInspectable var text: String? {
        didSet {
            self.textfield.text = text
        }
    }
    @IBInspectable var textColor: UIColor? {
        didSet {
            self.textfield.textColor = textColor
        }
    }
    
    @IBInspectable var editable: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textfield.placeholder = placeholder
        self.textfield.text = text
        
        self.textfield.isEnabled = editable
    }
}
