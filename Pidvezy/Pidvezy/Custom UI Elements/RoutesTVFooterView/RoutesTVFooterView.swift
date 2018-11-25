

import UIKit

let kRoutesTVFooterReuseID = "RoutesTVFooterView"
let kRoutesTVFooterHeight: CGFloat = 50.0

protocol RoutesTVFooterDelegate: class {
    func footerHasBeenTapped()
}

class RoutesTVFooterView: UITableViewHeaderFooterView {
    
    weak var delegate: RoutesTVFooterDelegate?
    
    //IBActions
    @IBAction func controlTapped(_ sender: Any) {
        self.delegate?.footerHasBeenTapped()
    }
}
