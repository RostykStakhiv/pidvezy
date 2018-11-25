
import UIKit

let kMyRouteTVCellReuseID = "MyRouteTVCell"

enum MyRouteCellAction {
    case edit
    case find
    case remove
}

protocol MyRouteTVCellDelegate: class {
    func actionBtnTappedWith(action act: MyRouteCellAction, forRow row: Int)
}

class MyRouteTVCell: UITableViewCell {
    
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var startAddressLbl: UILabel!
    @IBOutlet weak var endAddressLbl: UILabel!
    
    @IBOutlet weak var startTimeLbl: UILabel!
    
    @IBOutlet weak var weekDaysView: WeekDaysDisplayView!
    
    var route: Route? {
        didSet {
            guard let route = route else { return }
            
            typeLbl.text = route.type?.capitalized.localized
            startAddressLbl.text = route.routePoints?.first?.formattedAddress
            endAddressLbl.text = route.routePoints?.last?.formattedAddress
            //startTimeLbl.text = route.departureTime
            if startTimeLbl.text?.characters.count == 0 {
                startTimeLbl.text = "--"
            }
            
            weekDaysView.setActiveDays(days: route.regularDays)
        }
    }
    
    var row: Int = 0
    weak var delegate: MyRouteTVCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.weekDaysView.setFontSize(size: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: IBActions
    @IBAction func editBtnTapped(_ sender: Any) {
        self.delegate?.actionBtnTappedWith(action: .edit, forRow: self.row)
    }
    
    @IBAction func findBtnTapped(_ sender: Any) {
        self.delegate?.actionBtnTappedWith(action: .find, forRow: self.row)
    }
    
    @IBAction func removeBtnTapped(_ sender: Any) {
        self.delegate?.actionBtnTappedWith(action: .remove, forRow: self.row)
    }
}
