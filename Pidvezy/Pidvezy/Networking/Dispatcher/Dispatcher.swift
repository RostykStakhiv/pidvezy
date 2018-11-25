//
//  Dispatcher.swift
//  Dispatcher
//
//  Created by Nick Savula on 11/15/16.
//

import Foundation
import SwiftSpinner

class Dispatcher {
    static let shared = Dispatcher()
    private var headRequestHandler = DepotRequestHandler()
    
    private init() {
        headRequestHandler.nextHandler = ServiceRequestHandler()
    }
    
    public func processRequest(request: Request) {
        showSpinnerIfNeeded(for: request)
        headRequestHandler.processRequest(request: request, error: nil)
    }
    
    private func showSpinnerIfNeeded(for request: Request) {
        guard SwiftSpinner.sharedInstance.superview == nil,
            request.showActivity != false else { return }
        SwiftSpinner.show(AlertConstants.Activity.PleaseWait, animated: true)
    }
    
    
    public func cancelAllRequests(owner: ObjectIdentifier) {
        headRequestHandler.cancelAllRequests(owner: owner)
    }
}
