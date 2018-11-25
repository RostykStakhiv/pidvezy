

import UIKit
import IQKeyboardManager

class MyProfileVC: BaseVC, AddressInputVCDelegate, UITextFieldDelegate {
    
    fileprivate var addressModelType: GoogleAddressModelType = .homeAddress()
    fileprivate var userProfileModel: UserProfileModel = UserProfileModel()
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var emailTFView: TextFieldWithLeftRightIcons!
    @IBOutlet weak var phoneNumberTFView: TextFieldWithLeftRightIcons!
    
    @IBOutlet weak var homeLocationTFView: TextFieldWithLeftRightIcons!
    @IBOutlet weak var workLocationTFView: TextFieldWithLeftRightIcons!
    
    private let userProvider = UserProvider()
    
    private let imageProvider: ImageProvider = {
        let imageProvider = ImageProvider()
        imageProvider.placeholder = UIImage(named: "avatarPlaceholder")
        imageProvider.prepareType = .round(132.0)
        
        return imageProvider
    }()
    
    var user: User?
    
    //MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile".localized
        self.contentView.isHidden = true

        self.setupTextFields()
        userProvider.getCurrentUser { (loadedUser, error) in
            guard error == nil, let user = loadedUser else { return }
            self.user = user
            self.updateUIAccordingToUser()
        }
    }
    
    //MARK: Private Methods
    fileprivate func setupTextFields() {
        self.emailTFView.textfield.delegate = self
        self.phoneNumberTFView.textfield.delegate = self
        self.homeLocationTFView.textfield.delegate = self
        self.workLocationTFView.textfield.delegate = self
    }
    
    fileprivate func updateUIAccordingToUser() {
        guard let user = user else { return }
        
        self.nameLbl.text = user.name
        self.emailTFView.textfield.text = user.email
        self.phoneNumberTFView.textfield.text = user.phone
//        self.homeLocationTFView.textfield.text = self.userProfileModel.homeAddress?.formattedAddress
//        self.workLocationTFView.textfield.text = self.userProfileModel.workAddress?.formattedAddress
        
        if let userFBID = user.userFbId, let imageURL = URL(string: "https://graph.facebook.com/\(userFBID)/picture?type=large") {
            let cachedImage = imageProvider.loadImage(url: imageURL) { (image) in
                self.userAvatar.image = image
            }
            
            if let image = cachedImage {
                self.userAvatar.image = image
            }
        }
        
        self.contentView.isHidden = false
    }
    
    //MARK: IBActions
    @IBAction func saveBtnTapped(_ sender: Any) {
        let updateUserRequest = UpdateUserRequest(owner: ObjectIdentifier(self))
        updateUserRequest.user = userProfileModel
        updateUserRequest.completion = { request, error in
            guard error == nil else {
                return
            }
        }
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        AuthorizationManager.shared.logoutUser { (error) in
            guard error == nil else {
                return
            }
            
            InterfaceManager.sharedManager.redirectUserToLogin()
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === homeLocationTFView.textfield || textField === workLocationTFView.textfield {
            var inputAddressVC: AddressInputVC
            
            if textField === homeLocationTFView.textfield {
                self.addressModelType = .homeAddress()
                inputAddressVC = AddressInputVC(addressModel: userProfileModel.homeAddress)
            } else {
                self.addressModelType = .workAddress()
                inputAddressVC = AddressInputVC(addressModel: userProfileModel.workAddress)
            }
            
            inputAddressVC.delegate = self
            self.navigationController?.pushViewController(inputAddressVC, animated: true)
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailTFView.textfield {
            self.userProfileModel.email = textField.text
        } else if textField == self.phoneNumberTFView.textfield {
            self.userProfileModel.phoneNumber = textField.text
        }
    }
    
    
    //MARK: AddressInputVC Delegate
    func inputViewSectedAddressModel(_ model: GoogleAddressModel) {
        switch self.addressModelType {
        case .homeAddress():
            self.homeLocationTFView.textfield.text = model.formattedAddress
            self.userProfileModel.homeAddress = model
        case .workAddress():
            self.workLocationTFView.textfield.text = model.formattedAddress
            self.userProfileModel.workAddress = model
        }
    }
}

