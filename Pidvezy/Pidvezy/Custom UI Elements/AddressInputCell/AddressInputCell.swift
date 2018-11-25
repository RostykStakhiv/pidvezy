

import UIKit

let kInputAddressCellReuseID = "AddressInputCell"

let kDestinationText = "Where to?".localized
let kPickupText = "Where From?".localized

enum TextDisplayType {
    case addressSet(address: String)
    case addressNotSet()
}

enum AddressCellType {
    case pickupCell()
    case dropCell()
}

class AddressInputCell: UITableViewCell {
    
    @IBOutlet var addressView: AddressInputView!
    
    fileprivate var textDisplayType: TextDisplayType = .addressNotSet() {
        didSet {
            switch textDisplayType {
            case .addressNotSet():
                self.addressView.addressLbl.textColor = textPLaceholderColor
                self.setupUIAccordingToCellType()
            case .addressSet(let address):
                self.addressView.addressLbl.textColor = UIColor.black
                self.addressView.addressLbl.text = address
            }
        }
    }
    
    var cellType: AddressCellType = .dropCell() {
        didSet {
            self.setupUIAccordingToCellType()
        }
    }
    
    var model: GoogleAddressModel = GoogleAddressModel() {
        didSet {
            if let formattedAddress = model.formattedAddress {
                self.textDisplayType = .addressSet(address: formattedAddress)
            } else {
                self.textDisplayType = .addressNotSet()
            }
        }
    }
    
    //MARK: Private Methods
    fileprivate func setupUIAccordingToCellType() {
        self.addressView.iconIV.image = UIImage(named: kBlueLocationIconName)
        
        switch cellType {
        case .pickupCell():
            self.addressView.addressLbl.text = kPickupText
        case .dropCell():
            self.addressView.addressLbl.text = kDestinationText
        }
    }
    
}
