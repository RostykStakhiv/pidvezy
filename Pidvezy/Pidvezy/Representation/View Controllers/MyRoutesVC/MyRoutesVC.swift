

import UIKit
import SCLAlertView

let kPlusImageName = "nav_plus_icon"
let kSearchImageName = "nav_search_icon"

class MyRoutesVC: BaseVC, UITableViewDataSource, MyRouteTVCellDelegate {
    
    @IBOutlet weak var myRoutesTV: UITableView!
    
    var routes = [Route]()

    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMyRouteTVCellReuseID, for: indexPath) as! MyRouteTVCell
        
        let routeModel = self.routes[indexPath.row]
        cell.route = routeModel
        cell.row = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    //MARK: MyRouteTVCell Delegate
    func actionBtnTappedWith(action act: MyRouteCellAction, forRow row: Int) {
        let route = self.routes[row]
        
        switch act {
        case .edit():
            let routeManagingVC = InterfaceManager.sharedManager.mainFlowStoryboard.instantiateViewController(withIdentifier: kRouteManagingVCID) as! RouteManagingVC
            routeManagingVC.route = route
            routeManagingVC.action = .edit()
            routeManagingVC.successHandler = { (routeModel) in
                
                _ = SCLAlertView().showSuccess("", subTitle: kRouteHasBeenSaved.localized)
                //self.routes[row] = routeModel
                self.myRoutesTV.reloadData()
            }
            
            self.navigationController?.pushViewController(routeManagingVC, animated: true)
        case .find(): break
            
//            _ = RequestManager.sharedManager.performRequest(RouteManagingRouter(endpoint: .searchRoutesWithModel(model: model)), showActiviti: true, hideActivitiOnFinish: true, withsuccessJSONhandler: { (response) in
//
//                if response != nil {
//                    let routeInfoModels = RoutesManager.parseRoutModelsResponse(response: response!)
//
//                    if routeInfoModels.count > 0 {
//                        let searchResultVC = RouteSearchResultsVC(routeInfoModels: routeInfoModels)
//                        self.navigationController?.pushViewController(searchResultVC, animated: true)
//                    } else {
//                        _ = SCLAlertView().showInfo("Info".localized, subTitle: "No routes has been found :(".localized)
//                    }
//                }
//            }, failureHandler: { (error) in
//
//            })
        case .remove():
            guard let routeId = route.routeId else { return }
            
            let removeRouteRequest = RemoveRouteRequest(owner: ObjectIdentifier(self))
            removeRouteRequest.routeId = routeId
            removeRouteRequest.completion = { request, error in
                guard error == nil else {
                    _ = SCLAlertView().showError("", subTitle: error!.localizedDescription)
                    return
                }
                
                _ = SCLAlertView().showSuccess("", subTitle: kRouteHasBeenRemoved)
            }
        }
    }
    
    //MARK: Private Methods
    private func setupUI() {
        self.title = "My Routes".localized
        
        self.myRoutesTV.rowHeight = UITableViewAutomaticDimension
        self.myRoutesTV.estimatedRowHeight = 280
        
        let routeInfoCellNib = UINib.init(nibName: String(describing: MyRouteTVCell.self), bundle: nil)
        self.myRoutesTV.register(routeInfoCellNib, forCellReuseIdentifier: kMyRouteTVCellReuseID)
        
//        _ = RequestManager.sharedManager.performRequest(RouteManagingRouter(endpoint: .myRoutes), showActiviti: true, hideActivitiOnFinish: true, withsuccessJSONhandler: { (response) in
//
//            var routeInfoModels: [RouteInfoModel] = []
//
//            if let results = response![kSearchResultsKey] as? [AnyObject] {
//                for routeDict in results {
//                    let lRouteInfoModel = RouteInfoModel(dictionary: routeDict as! [String : AnyObject])
//                    routeInfoModels.append(lRouteInfoModel)
//                }
//            }
//
//            self.routeModels = routeInfoModels
//            self.myRoutesTV.reloadData()
//
//
//        }, failureHandler: { (error) in
//
//        })
    }
}
