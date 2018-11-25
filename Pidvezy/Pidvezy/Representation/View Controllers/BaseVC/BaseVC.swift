

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        self.navigationController?.navigationBar.isTranslucent = false;
    }
    
    init () {
        let className = NSStringFromClass(type(of: self)).components(separatedBy: ".").last
        super.init(nibName: className, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Private Methods
    fileprivate func createBarButtonItem(withImageNamed name: String, selector sel: Selector) -> UIBarButtonItem {
        let lButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        lButton.setImage(UIImage.init(named: name), for: .normal)
        lButton.addTarget(self, action: sel, for: .touchUpInside)
        return UIBarButtonItem(customView: lButton)
    }
}
