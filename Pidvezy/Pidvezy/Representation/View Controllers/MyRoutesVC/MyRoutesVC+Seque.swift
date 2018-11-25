

import Foundation
import UIKit
import SCLAlertView

extension MyRoutesVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueID = segue.identifier {
            switch segueID {
            case kSearchRouteSegueID:
                let routeManaginVC = segue.destination as! RouteManagingVC
                routeManaginVC.action = .search()
            case kCreateRouteSegueID:
                let routeManaginVC = segue.destination as! RouteManagingVC
                routeManaginVC.action = .create()
                routeManaginVC.successHandler = { (routeModel) in
                    _ = SCLAlertView().showSuccess("", subTitle: kRouteHasBeenCreated.localized)
                    self.routes.append(routeModel)
                    self.myRoutesTV.reloadData()
                }
            default:
                break
            }
        }
    }
}
