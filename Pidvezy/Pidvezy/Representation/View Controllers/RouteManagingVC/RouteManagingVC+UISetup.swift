

import Foundation
import UIKit

extension RouteManagingVC {
    internal func setupUI() {
        
        self.selectionTypeLbl.text = "I am a".localized
        
        switch self.action {
        case .search():
            self.selectionTypeLbl.text = "I am looking for".localized
            self.title = "Search Route".localized
            self.actionButton.setTitle("Search".localized, for: .normal)
            self.departureDateTFHeight.constant = 0
            self.weekDaysViewHeight.constant = 0
            self.regularitySwitchViewHeight.constant = 0
        case .edit():
            self.title = "Edit Route".localized
            self.actionButton.setTitle("Save".localized, for: .normal)
        case .create():
            self.title = "Create Route".localized
            self.actionButton.setTitle("Create".localized, for: .normal)
            self.routeInfoModel.regularity = "regular"
        }
        
        if let userType = self.routeInfoModel.type {
            self.setTypeUIAccordingToTypeString(type: userType)
        }
        
        if let depTime = self.routeInfoModel.departureTime {
            self.depatrureTimeTF.textfield.text = depTime
        }
        
        if self.routeInfoModel.regularDays.count > 0 {
            self.weekDaysView.setActiveDays(days: self.routeInfoModel.regularDays)
        }
        
        if self.routeInfoModel.routePoints.count < 2 {
            self.routeInfoModel.routePoints = self.createInitialModelsArray()
        }
        
        self.routesTV.models = self.routeInfoModel.routePoints
        
        let addressInputCellNib = UINib.init(nibName: String(describing: AddressInputCell.self), bundle: nil)
        self.routesTV.register(addressInputCellNib, forCellReuseIdentifier: kInputAddressCellReuseID)
        
        let routerTVFooterView = UINib(nibName: String(describing: RoutesTVFooterView.self), bundle: nil)
        self.routesTV.register(routerTVFooterView, forHeaderFooterViewReuseIdentifier: kRoutesTVFooterReuseID)
        
        self.departureTimeDatePicker.datePickerMode = .time
        self.departureTimeDatePicker.locale = Locale(identifier: "en_GB")
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        self.departureTimeDatePicker.setDate(calendar.date(from: components)!, animated: false)
        self.depatrureTimeTF.textfield.inputView = self.departureTimeDatePicker
        self.depatrureTimeTF.textfield.delegate = self
        
        self.departureDatePicker.datePickerMode = .date
        self.departureDateTF.textfield.inputView = self.departureDatePicker
        self.departureDateTF.textfield.delegate = self
    }
}
