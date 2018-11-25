

import UIKit
import CoreLocation
import SCLAlertView

let weekdays = ["Monday".localized, "Tuesday".localized, "Wednesday".localized, "Thursday".localized, "Friday".localized, "Saturday".localized, "Sunday".localized]

enum RouteAction {
    case search()
    case create()
    case edit()
}

typealias RouteManagingSuccessHandler = ((_ route: Route) -> Void)

class RouteManagingVC: BaseVC {

    @IBOutlet weak var selectionTypeLbl: UILabel!
    @IBOutlet weak var routesTV: RoutesTV!
    @IBOutlet weak var actionButton: DesignableButton!
    
    @IBOutlet weak var depatrureTimeTF: TextFieldWithIcon!
    @IBOutlet weak var departureDateTF: TextFieldWithIcon!
    
    @IBOutlet weak var weekDaysView: WeekDaysDisplayView!
    
    @IBOutlet weak var driverControl: UIButton!
    @IBOutlet weak var passengerControl: UIButton!
    
    @IBOutlet weak var weekDaysViewHeight: NSLayoutConstraint!
    @IBOutlet weak var departureDateTFHeight: NSLayoutConstraint!
    @IBOutlet weak var regularitySwitchViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var regularitySwitch: UISwitch!
    
    internal var action: RouteAction = .search()
    var route: Route!
    
    internal var departureTimeDatePicker: UIDatePicker = UIDatePicker()
    internal var departureDatePicker: UIDatePicker = UIDatePicker()
    
    var selectedRow: Int = 0
    var successHandler: RouteManagingSuccessHandler? = nil
    
    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    //MARK: Init Methods
    override init() {
        self.action = .search()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.action = .search()
        super.init(coder: aDecoder)
    }
    
    //MARK: PrivateMethods
    internal func setTypeUIAccordingToTypeString(type: String) {
        if type == "driver" {
            self.driverControl.isSelected = true
        } else {
            self.passengerControl.isSelected = true
        }
    }
    
    internal func createInitialModelsArray() -> [GoogleAddressModel] {
        return [GoogleAddressModel(),
                GoogleAddressModel()]
    }
    
    internal func showWeekDaysPicker() {
        if let picker = CZPickerView(headerTitle: "Select Days On Which You Ride".localized, cancelButtonTitle: "Cancel".localized, confirmButtonTitle: "Confirm".localized) {
            picker.delegate = self
            picker.dataSource = self
            picker.needFooterView = false
            picker.allowMultipleSelection = true
            
            //Customization
            picker.headerBackgroundColor = greenColor
            picker.confirmButtonBackgroundColor = greenColor
            picker.show()
        }
    }
    
    internal func validateData() -> (Bool, String?) {
        guard (self.route!.type != nil) else {
            return (false, "Please select Driver or Passenger".localized)
        }
        
        self.route!.routePoints = []
        for addressModel in self.routesTV.models {
            if addressModel.formattedAddress != nil && addressModel.location != nil {
                self.route!.routePoints!.append(addressModel)
            }
        }
        
        guard self.route!.routePoints!.count > 1 else {
            return (false, "Please select at least two route points".localized)
        }
        
        if self.regularitySwitch.isOn == false {
            guard self.route!.routeDate != nil else {
                return (false, "Please select departure date".localized)
            }
        } else {
//            guard (self.route.regularDays.count > 0 && (self.action == .edit() || self.action == .create())) else {
//                return (false, "Please select travel days".localized)
//            }
        }
        
        return (true, nil)
    }
    
    //MARK: IBActions
    @IBAction func tripRegularitySwitchChanged(_ sender: UISwitch) {
        self.route!.regularity = (sender.isOn) ? "regular" : "once"
        
        if sender.isOn {
            self.weekDaysViewHeight.constant = 120
            self.departureDateTFHeight.constant = 0
        } else {
            self.weekDaysViewHeight.constant = 0
            self.departureDateTFHeight.constant = 40
        }
    }
    
    @IBAction func editRouteDaysTapped(_ sender: IBDesignableButton) {
        self.showWeekDaysPicker()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        
        let validationResult = self.validateData()
        if validationResult.0 {
            
            let model = self.route
            
            switch self.action {
            case .search():
                let findRoutesRequest = FindRoutesRequest(owner: ObjectIdentifier(self))
                findRoutesRequest.routeModel = model
                findRoutesRequest.completion = { request, error in
                    guard error == nil else { return }
                    
                    if let response = request.response as? FindRoutesRequest.FindRoutesResponse,
                        let routes = response.items as? [Route] {
                        
                        if routes.count > 0 {
                            let searchResultVC = RouteSearchResultsVC(routes: routes)
                            self.navigationController?.pushViewController(searchResultVC, animated: true)
                        } else {
                            _ = SCLAlertView().showInfo("Info".localized, subTitle: "No routes has been found :(".localized)
                        }
                    }
                }
            case .edit(): break
//                _ = RequestManager.sharedManager.performRequest(RouteManagingRouter(endpoint: .editRouteWithModel(model: model)), showActiviti: true, hideActivitiOnFinish: true, withsuccessJSONhandler: { (response) in
//
//                    if let successHandler = self.successHandler {
//
//                        let route = route(dictionary: response!)
//                        successHandler(route)
//                        _ = self.navigationController?.popViewController(animated: true)
//                    }
//
//                }, failureHandler:nil)
            case .create(): break
                
//                _ = RequestManager.sharedManager.performRequest(RouteManagingRouter(endpoint: .createRouteWithModel(model: model)), showActiviti: true, hideActivitiOnFinish: true, withsuccessJSONhandler: { (response) in
//                    if self.successHandler != nil {
//
//                        let route = route(dictionary: response!)
//                        self.successHandler!(route)
//                        _ = self.navigationController?.popViewController(animated: true)
//                    }
//                }, failureHandler: { (error) in
//
//                })
            }
            
        } else {
            _ = SCLAlertView().showInfo("Info".localized, subTitle: validationResult.1!)
        }
    }
    
    @IBAction func userTypeControlTapped(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            if sender === self.driverControl {
                self.route!.type = "driver"
                self.passengerControl.isSelected = false
            } else {
                self.route!.type = "passenger"
                self.driverControl.isSelected = false
            }
        }
    }
}
