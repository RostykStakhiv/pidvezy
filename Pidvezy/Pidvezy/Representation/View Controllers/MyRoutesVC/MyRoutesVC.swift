

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
        case .edit:
            let routeManagingVC = InterfaceManager.sharedManager.mainFlowStoryboard.instantiateViewController(withIdentifier: kRouteManagingVCID) as! RouteManagingVC
            routeManagingVC.route = route
            routeManagingVC.action = .edit
            routeManagingVC.successHandler = { (routeModel) in
                
                _ = SCLAlertView().showSuccess("", subTitle: kRouteHasBeenSaved.localized)
                //self.routes[row] = routeModel
                self.myRoutesTV.reloadData()
            }
            
            self.navigationController?.pushViewController(routeManagingVC, animated: true)
        case .find:
        let routeDict = [
            "id": "58d7d9329e74fd2620a1a5b8",
            "fb_id": "911580392233202",
            "name": "Going Home",
            "addr_s": "вулиця Кам'янецька 1а, Львів, Львівська область, Україна",
            "addr_m": [],
            "addr_e": "готель Гетьман, вулиця Володимира Великого, Львів, Львівська область, Україна",
            "loc_s": [49.8093317, 24.038011299999994],
            "loc_m": [],
            "loc_e": [49.8116746, 23.99085809999997],
            "regularity": "regular",
            "regular_days": [1, 2, 3, 4, 5],
            "time": "1900-01-01T05:00:00",
            "type": "driver",
            "created_on": "2017-03-26T12:20:45.999000",
            "last_update": "2017-03-26T15:24:03.680000",
            "polyline_points": "ik_oHq|uqC??@@UxAEH[@o@IiAW{Ag@k@c@mE{C}CnMsCuBw@|CmDdPsAxGiChL_AzEcCjLm@zCXDlCVpCXpDT_@`ZEzGbAFtLh@nADxQ~@rBLOjIQrHMtC_@bEWtC}@fIeAhI}ApLUfCI~Bk@bZc@~Ic@rAIBEDS\\Gf@Dh@FTDFXzB[dGcArSWnFe@hJ}@SKvA??",
            "user_id": "55dd6be9ece39a6cf774d6df",
            "user": ["id": "55dd6be9ece39a6cf774d6df",
                     "name": "Rostyslav Stakhiv",
                     "fb_id": "911580392233202",
                     "email": "rost.stakhiv@gmail.com",
                     "phone": "+380637325386",
                     "locale": "uk_UA",
                     "description": "CTO в Підвезу!",
                     "gender": "male",
                     "registered_on": "2015-08-26T04:34:01",
                     "location": "Київ, місто Київ, Україна",
                     "city_addr": "Київ, місто Київ, Україна",
                     "city_coords": [50.4501, 30.5234],
                     "home_addr": "вул.Мельникова 42, Київ, місто Київ, Україна",
                     "home_coords": [50.12345, 30.12345],
                     "work_addr": "вул. Хрещатик 1, Київ, місто Київ, Україна",
                     "work_coords": [50.98765, 30.98765],
                     "routes": [
                        "58d7d9329e74fd2620a1a5b8"] as [String]
                ] as [String: Any]
            ] as [String: Any]
        
        if let parsedRoute = DataModel.shared.parseRoute(data: routeDict) {
            let searchResultVC = RouteSearchResultsVC(routes: [parsedRoute])
            self.navigationController?.pushViewController(searchResultVC, animated: true)
            }
//            _ = RequestManager.sharedManager.performRequest(RouteManagingRouter(endpoint: .searchRoutesWithModel(model: model)), showActiviti: true, hideActivitiOnFinish: true, withsuccessJSONhandler: { (response) in
//
//                if response != nil {
//                    let routeInfoModels = RoutesManager.parseRoutModelsResponse(response: response!)
//
//                    if routeInfoModels.count > 0 {
//                        let searchResultVC = RouteSearchResultsVC(routeInfoModels: routeInfoModels)
//                        self.navigationController?.pushViewController(searchResultVC, animated: true)
//                    } else {
//                        _ = SCLAlertView().showInfo("Info".localized, subTitle: "No routes have been found :(".localized)
//                    }
//                }
//            }, failureHandler: { (error) in
//
//            })
        case .remove:
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
        
        self.myRoutesTV.rowHeight = UITableView.automaticDimension
        self.myRoutesTV.estimatedRowHeight = 280
        
        let routeInfoCellNib = UINib.init(nibName: String(describing: MyRouteTVCell.self), bundle: nil)
        self.myRoutesTV.register(routeInfoCellNib, forCellReuseIdentifier: kMyRouteTVCellReuseID)
        
        
        let routeDict = [
            "id": "58d7d9329e74fd2620a1a5b8",
            "fb_id": "911580392233202",
            "name": "Going Home",
            "addr_s": "вулиця Кам'янецька 1а, Львів, Львівська область, Україна",
            "addr_m": [],
            "addr_e": "готель Гетьман, вулиця Володимира Великого, Львів, Львівська область, Україна",
            "loc_s": [49.8093317, 24.038011299999994],
            "loc_m": [],
            "loc_e": [49.8116746, 23.99085809999997],
            "regularity": "regular",
            "regular_days": [1, 2, 3, 4, 5],
            "time": "1900-01-01T05:00:00",
            "type": "driver",
            "created_on": "2017-03-26T12:20:45.999000",
            "last_update": "2017-03-26T15:24:03.680000",
            "polyline_points": "ik_oHq|uqC??@@UxAEH[@o@IiAW{Ag@k@c@mE{C}CnMsCuBw@|CmDdPsAxGiChL_AzEcCjLm@zCXDlCVpCXpDT_@`ZEzGbAFtLh@nADxQ~@rBLOjIQrHMtC_@bEWtC}@fIeAhI}ApLUfCI~Bk@bZc@~Ic@rAIBEDS\\Gf@Dh@FTDFXzB[dGcArSWnFe@hJ}@SKvA??",
            "user_id": "55dd6be9ece39a6cf774d6df",
            "user": ["id": "55dd6be9ece39a6cf774d6df",
                     "name": "Rostyslav Stakhiv",
                     "fb_id": "911580392233202",
                     "email": "rost.stakhiv@gmail.com",
                     "phone": "+380637325386",
                     "locale": "uk_UA",
                     "description": "CTO в Підвезу!",
                     "gender": "male",
                     "registered_on": "2015-08-26T04:34:01",
                     "location": "Київ, місто Київ, Україна",
                     "city_addr": "Київ, місто Київ, Україна",
                     "city_coords": [50.4501, 30.5234],
                     "home_addr": "вул.Мельникова 42, Київ, місто Київ, Україна",
                     "home_coords": [50.12345, 30.12345],
                     "work_addr": "вул. Хрещатик 1, Київ, місто Київ, Україна",
                     "work_coords": [50.98765, 30.98765],
                     "routes": [
                        "58d7d9329e74fd2620a1a5b8"] as [String]
                ] as [String: Any]
        ] as [String: Any]
        
        if let parsedRoute = DataModel.shared.parseRoute(data: routeDict) {
            self.routes = [parsedRoute]
            myRoutesTV.reloadData()
        }
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
