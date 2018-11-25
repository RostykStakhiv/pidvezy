

import UIKit

let kPredictionsKey = "predictions"
let kAutocompleteResultCellID = "autocompleteCell"

protocol AddressInputVCDelegate: class {
    func inputViewSectedAddressModel(_ model: GoogleAddressModel)
}

class AddressInputVC: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textFieldView: TextFieldView!
    @IBOutlet weak var resultsTV: UITableView!
    
    weak var delegate: AddressInputVCDelegate?
    let addressModel: GoogleAddressModel?
    var predictionsArray: [GooglePredictionModel] = []
    
    //MARK: Init Methods
    init(addressModel model: GoogleAddressModel?) {
        self.addressModel = model
        
        super.init()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        self.addressModel = nil
        
        super.init(coder: aDecoder)
    }

    //MARK: VIew Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    //MARK: Private Methods
    fileprivate func setupUI() {
        self.title = "Select Address".localized
        self.textFieldView.textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.resultsTV.delegate = self
        self.resultsTV.dataSource = self
    }
    
    //MARK: UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: kAutocompleteResultCellID)
        let lPredModel = predictionsArray[indexPath.row]
        
        cell.textLabel?.text = lPredModel.description
        
        return cell
    }
    
    //MARK: UITableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lPlaceID = self.predictionsArray[indexPath.row].placeID {
            GooglePlacesManager.sharedManager.getPlaceDetailsForPlaceID(lPlaceID) { (gAddressModel) in
                if let lGoogleAddressModel = gAddressModel {
                    self.delegate?.inputViewSectedAddressModel(lGoogleAddressModel)
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    //MARK: UITextField Event Handling Methids
    func textFieldDidChange(_ textField: UITextField) {
        GooglePlacesManager.sharedManager.autocompleteSearchFor(textField.text!, sucessHandler: { (result) in
            self.predictionsArray = result
            self.resultsTV.reloadData()
        }, failureHandler: nil)
    }
    
}
