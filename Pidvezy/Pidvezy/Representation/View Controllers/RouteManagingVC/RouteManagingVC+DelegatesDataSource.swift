

import Foundation
import UIKit

//MARK: UITableView Datasource
extension RouteManagingVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routesTV.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kInputAddressCellReuseID, for: indexPath) as! AddressInputCell
        
        if(indexPath.row == 0) {
            cell.cellType = .pickupCell()
        }
        
        let routeDisplayModel = self.routesTV.models[indexPath.row]
        cell.model = routeDisplayModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let endIndex = self.routesTV.models.endIndex
        if indexPath.row != self.routesTV.models.startIndex && indexPath.row != endIndex - 1 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let editedTV = tableView as? RoutesTV {
                editedTV.models.remove(at: indexPath.row)
                
                editedTV.beginUpdates()
                editedTV.deleteRows(at: [indexPath], with: .automatic)
                editedTV.endUpdates()
            }
        }
    }
}

//MARK: UITableViewDelegate
extension RouteManagingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = self.routesTV.dequeueReusableHeaderFooterView(withIdentifier: kRoutesTVFooterReuseID) as! RoutesTVFooterView
        footer.delegate = self
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return kRoutesTVFooterHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kRoutesTVCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.selectedRow = Int(indexPath.row)
        
        let addressInputVC = AddressInputVC(addressModel: nil)
        addressInputVC.delegate = self
        self.navigationController?.pushViewController(addressInputVC, animated: true)
    }
}

//MARK: AddressInputVC Delegate
extension RouteManagingVC: AddressInputVCDelegate {
    func inputViewSectedAddressModel(_ model: GoogleAddressModel) {
        self.routesTV.models[selectedRow] = model
        self.routesTV.reloadData()
    }
}

//MARK: UITextFieldDelegate
extension RouteManagingVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.depatrureTimeTF.textfield {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.depatrureTimeTF.textfield.text = dateFormatter.string(from: self.departureTimeDatePicker.date)
            self.routeInfoModel.departureTime = self.depatrureTimeTF.textfield.text
        } else if(textField == self.departureDateTF.textfield) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            textField.text = dateFormatter.string(from: self.departureDatePicker.date)
            self.routeInfoModel.routeDate = textField.text
        }
    }
}

//MARK: RoutesTVFooterDelegate
extension RouteManagingVC: RoutesTVFooterDelegate {
    func footerHasBeenTapped() {
        if self.routesTV.models.count < 10 {
            let insertIndex = self.routesTV.models.endIndex - 1
            
            self.routesTV.models.insert(GoogleAddressModel(), at: insertIndex)
            
            self.routesTV.beginUpdates()
            self.routesTV.insertRows(at: [IndexPath(row: insertIndex, section: 0)], with: .right)
            self.routesTV.endUpdates()
        }
    }
}

//MARK: UserTypeSelectionControlDelegate
extension RouteManagingVC: UserTypeSelectionControlDelegate {
    func userTypeControlHasBeenSelected(control: UserTypeSelectionControl) {
        if control === self.driverControl {
            self.passengerControl.isSelected = false
        } else {
            self.driverControl.isSelected = false
        }
    }
}

//MARK: CZPickerViewDelegate, CZPickerViewDataSource
extension RouteManagingVC: CZPickerViewDelegate, CZPickerViewDataSource {
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return weekdays.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return weekdays[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        if let selectedRows = rows as? [Int] {
            let sortedRows = selectedRows.sorted()
            
            var weekDaysArray: [Int] = [Int]()
            
            for row in sortedRows {
                weekDaysArray.append(row + 1) //Add 1 because row indexes start from 0 and on backend weekday starts from 1
            }
            
            self.routeInfoModel.regularDays = weekDaysArray
            self.weekDaysView.setActiveDays(days: self.routeInfoModel.regularDays)
        }
    }
}
