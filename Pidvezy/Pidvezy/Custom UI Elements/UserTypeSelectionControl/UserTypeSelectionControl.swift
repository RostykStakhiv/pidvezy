
import UIKit

let kUserTypeSelectedBackground = "user_type_selected_background"
let kUserTypeDeselectedBackground = "user_type_deselected_background"

protocol UserTypeSelectionControlDelegate: class {
    func userTypeControlHasBeenSelected(control: UserTypeSelectionControl)
}

class UserTypeSelectionControl: IBDesignableView {
    
    @IBOutlet weak var backdroundIV: UIImageView!
    @IBOutlet weak var typeLbl: UILabel!
    
    weak var delegate: UserTypeSelectionControlDelegate? = nil
    
    private var tapGesture: UITapGestureRecognizer? = nil
    
    @IBInspectable var shouldHandleTap: Bool = false {
        didSet {
            if self.shouldHandleTap == true {
                self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewHasBeenTapped))
                self.view.addGestureRecognizer(self.tapGesture!)
            }
        }
    }
    @IBInspectable var text: String = "" {
        didSet {
            self.typeLbl.text = text
        }
    }
    
        @IBInspectable var isSelected: Bool = false {
        didSet{
            if isSelected == true {
                self.backdroundIV.image = UIImage(named: kUserTypeSelectedBackground)
                self.typeLbl.textColor = UIColor.white
            } else {
                self.backdroundIV.image = UIImage(named: kUserTypeDeselectedBackground)
                self.typeLbl.textColor = greenColor
            }
        }
    }
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.typeLbl.text = text
    }
    
    //MARK: Custom Actions
    @objc private func viewHasBeenTapped() {
        if self.isSelected == false {
            self.isSelected = true
            self.delegate?.userTypeControlHasBeenSelected(control: self)
        }
    }
}
