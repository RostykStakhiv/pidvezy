
import UIKit

let kRoutesTVCellHeight: CGFloat = 50.0

class RoutesTV: UITableView {
    var models: [GoogleAddressModel] = [] {
        didSet {
            self.height?.constant = kRoutesTVFooterHeight + CGFloat(models.count) * kRoutesTVCellHeight
        }
    }
    
    @IBOutlet var height: NSLayoutConstraint?
}
