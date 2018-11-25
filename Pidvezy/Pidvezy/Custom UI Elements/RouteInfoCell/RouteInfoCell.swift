

import UIKit

let kRouteInfoCellID = "routeInfoCellID"

class RouteInfoCell: UITableViewCell {
    
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var typeLbl: UILabel!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var professionLbl: UILabel!
    @IBOutlet private weak var startAddressLbl: UILabel!
    @IBOutlet private weak var endAddressLbl: UILabel!
    
    @IBOutlet private weak var weekDaysView: WeekDaysDisplayView!
    @IBOutlet private weak var departureTimeLbl: UILabel!
    
    var route: Route? {
        didSet {
            guard let route = route else { return }
            
            self.nameLbl.text = route.creator?.name
            self.professionLbl.text = route.creator?.jobDescription
//            self.startAddressLbl.text = route.routePoints.first?.formattedAddress
//            self.endAddressLbl.text = route.routePoints.last?.formattedAddress
            self.typeLbl.text = route.type?.capitalized
//            self.departureTimeLbl.text = route.departureTime
            self.weekDaysView.setActiveDays(days: route.regularDays)
        }
    }
    
    var avatarImage: UIImage? {
        didSet {
            avatar.image = avatarImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.weekDaysView.setFontSize(size: 10)
    }
    
    //MARK: IBActions
    @IBAction func cellItemTapped(_ sender: Any) {
    }
}
