

import UIKit

let kDescriptionKey = "description"
let kPlaceIDKey = "place_id"

class GooglePredictionModel {

    let description: String?
    let placeID: String?
    
    init(desription desc: String, placeID id: String) {
        self.description = desc
        self.placeID = id
    }
    
    init(dictionary dict: [String: Any]) {
        self.description = dict[kDescriptionKey] as? String
        self.placeID = dict[kPlaceIDKey] as? String
    }
}
