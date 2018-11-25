

import Foundation
import UIKit
import ObjectiveC

var ActionBlockKey: UInt8 = 0

// a type for our action block closure
typealias ButtonHandler = (_ sender: UIButton) -> Void

class ActionBlockWrapper : NSObject {
    var block : ButtonHandler
    init(block: @escaping ButtonHandler) {
        self.block = block
    }
}

extension UIButton {
    func setHandler(block: @escaping ButtonHandler) {
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: Selector(("block_handleAction:")), for: .touchUpInside)
    }
    
    internal func block_handleAction(sender: UIButton) {
        let wrapper = objc_getAssociatedObject(self, &ActionBlockKey) as! ActionBlockWrapper
        wrapper.block(sender)
    }
}
