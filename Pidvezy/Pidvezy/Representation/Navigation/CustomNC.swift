

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
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationBar.barTintColor = greenColor
        self.navigationBar.isTranslucent = false
        
        //self.navigationItem.hidesBackButton = true
    }
}
