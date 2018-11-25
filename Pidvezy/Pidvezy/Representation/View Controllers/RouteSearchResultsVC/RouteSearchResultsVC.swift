

import UIKit

class RouteSearchResultsVC: BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchResultTV: UITableView!
    
    var routes: [Route] = []
    
    private let imageProvider: ImageProvider = {
        let imageProvider = ImageProvider()
        imageProvider.placeholder = UIImage(named: "avatarPlaceholder")
        imageProvider.prepareType = .round(84.0)
        
        return imageProvider
    }()
    
    //MARK: Init
    convenience init(routes rModels: [Route]) {
        self.init()
        self.routes = rModels
    }

    //MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    //MARK: Private Methods
    fileprivate func setupUI() {
        self.title = "Search Results".localized
        
        let routeInfoCellNib = UINib.init(nibName: String(describing: RouteInfoCell.self), bundle: nil)
        self.searchResultTV.register(routeInfoCellNib, forCellReuseIdentifier: kRouteInfoCellID)
    }
    
    //MARK: UITableView Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRouteInfoCellID, for: indexPath) as! RouteInfoCell
        
        let route = self.routes[indexPath.row]
        cell.route = route
        
        if let userFBID = route.creator?.userFbId, let imageURL = URL(string: "https://graph.facebook.com/\(userFBID)/picture?type=large") {
            let cachedImage = imageProvider.loadImage(url: imageURL) { (image) in
                cell.avatarImage = image
            }
            
            if let image = cachedImage {
                cell.avatarImage = image
            }
        }
        
        return cell
    }
    
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routeMapVC = RouteMapVC(route: self.routes[indexPath.row])
        self.navigationController?.pushViewController(routeMapVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
