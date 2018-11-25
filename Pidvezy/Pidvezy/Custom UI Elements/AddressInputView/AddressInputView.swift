

import UIKit

let kBlueLocationIconName = "green_location_icon"
let kGreyLocationIconName = "grey_location_icon"

class AddressInputView: IBDesignableView {
    
    @IBOutlet var iconIV: UIImageView!
    @IBOutlet var addressLbl: UILabel!
    
    @IBInspectable var icon: String = kBlueLocationIconName
    @IBInspectable var placeholder: String?
    @IBInspectable var displayText: String?
    
    override func awakeFromNib() {
         super.awakeFromNib()
        
        self.iconIV.image = UIImage(named: icon)
        self.addressLbl.text = displayText
    }

}
