//
//  AlertHelper.swift
//
//  Created by Rostyslav Stakhiv
//  Copyright © 2018 Rostyslav Stakhiv. All rights reserved.
//

import UIKit

struct AlertConstants {
    
    struct Titles {
        static let InfoTitle = "alert_info_title".localized
        static let ErrorTitle = "alert_error_title".localized
        static let ChoosePictureFrom = "alert_choose_picture_from".localized
        static let ChooseVideoFrom = "alert_choose_video_from".localized
        static let ChooseMediaFrom = "alert_choose_media_from".localized
    }
    
    struct Messages {
        
        //MARK: Onboarding
        static let PleaseInputValidMail = "input_valid_email".localized
        static let PasswordsShouldMatch = "passwords_should_match".localized
        static let PleaseInputValidPassword = "input_valid_password".localized
        static let AccountCreated = "account_created".localized
        
        //MARK: General messages
        static let SomethingWentWrong = "something_went_wrong".localized
    }
    
    struct ButtonTitles {
        static let TryAgain = "try_again".localized
        static let Cancel = "cancel".localized
        static let OK = "ok".localized
        static let Delete = "delete".localized
        static let Edit = "edit".localized
    }
    
    struct Activity {
        static let PleaseWait = "please_wait".localized
    }
}

class AlertHelper { //TOOD: Make AlertPresenter
// TODO: add system alert configuration
    enum AlertType {
		case info(closeButtonTitle: String)
		case choice(acceptTitle: String, declineTitle: String)
		case multiple(acceptTitle: String, declineTitle: String, additionalTitle: String)
	}

    public typealias AlertActionCompletion = (_ action: UIAlertAction) -> Void
    
    //MARK: Standart looking alerts
    class func presentInfoAlert(onViewController presentVC: UIViewController, withTitle title: String, message: String, actionTitle: String = AlertConstants.ButtonTitles.OK, actionHandler: AlertActionCompletion?) {
        let action = UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
            actionHandler?(action)
        })
        let alert = AlertHelper.createSystemAlert(withTitle: title, message: message, actions: [action])
        DispatchQueue.main.async {
            presentVC.present(alert, animated: true, completion: nil)
        }
    }
    
    class func presentTextfieldAlert(onViewController presentVC: UIViewController, withTitle title: String, message: String, placeholder: String, submitActionTitle: String, otherActions: [UIAlertAction]?, completion: @escaping ((_ textInput: String?) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = placeholder
        }
        
        if let actions = otherActions {
            for action in actions {
                alert.addAction(action)
            }
        }

        alert.addAction(UIAlertAction(title: submitActionTitle, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            completion(textField.text)
        }))
        
        presentVC.present(alert, animated: true, completion: nil)
    }
    
    class func presentAlert(onViewController presentVC: UIViewController, withTitle title: String, message: String, actions: [UIAlertAction]) {
        let alert = AlertHelper.createSystemAlert(withTitle: title, message: message, actions: actions)
        DispatchQueue.main.async {
            presentVC.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Private Methods
    private class func createSystemAlert(withTitle title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        
        return alert
    }
}
