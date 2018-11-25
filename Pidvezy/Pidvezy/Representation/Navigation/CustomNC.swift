

import UIKit

class CustomNC: UINavigationController {

    //MARK: Overriden Mehtods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationUI()
    }
    
    //MARK: Private Methods
    fileprivate func setupNavigationUI() {
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
        self.navigationBar.barTintColor = greenColor
        self.navigationBar.isTranslucent = false
        
        //self.navigationItem.hidesBackButton = true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
