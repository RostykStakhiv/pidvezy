
import Foundation
import CoreData
import UIKit

protocol SearchableRequest{
    var searchContent: String {set get}
}

class PaginableRequest: Request {
    
    class PaginableResponse: Response {
        
        var totalPages: Int = 0
        var totalItems: Int = 0
        
        var items: [NSManagedObject] {
            preconditionFailure("This method must be overridden")
        }
        
        override func parseResponse(response: URLResponse?, data: Data?) throws {
            try super.parseResponse(response: response, data: data)
            if let jsonDictionary = json as? Dictionary<String, Any>,
                let dataArray = jsonDictionary["results"] as? [Dictionary<String, Any>] {
                if let metaDictionary = jsonDictionary["meta"] as? Dictionary<String, Any>,
                    let paginationDictionary = metaDictionary["pagination"] as? Dictionary<String, Any> {
                    totalPages = paginationDictionary["total_pages"] as? Int ?? 0
                    totalItems = paginationDictionary["total"] as? Int ?? 0
                }
                
                parseItems(dataArray: dataArray)
            }
        }
        
        func parseItems(dataArray:[Dictionary<String, Any>]) {
            preconditionFailure("This method must be overriden")
        }
    }
    
    var page: Int = 0
    var itemsPerPage: Int = 20
}

extension Request {
    // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
    // Example: Accept-Language: da, en-gb;q=0.8, en;q=0.7
    static private let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
        let quality = 1.0 - (Double(index) * 0.1)
        return "\(languageCode);q=\(quality)"
        }.joined(separator: ", ")
    // User-Agent Header; see https://tools.ietf.org/html/rfc7231#section-5.5.3
    // Example: iOS Example/1.0 (org.alamofire.iOS-Example; build:1; iOS 10.0.0)
    static private let userAgent: String = {
        if let info = Bundle.main.infoDictionary {
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            
            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                
                let osName: String = {
                    #if os(iOS)
                        return "iOS"
                    #elseif os(watchOS)
                        return "watchOS"
                    #elseif os(tvOS)
                        return "tvOS"
                    #elseif os(macOS)
                        return "OS X"
                    #elseif os(Linux)
                        return "Linux"
                    #else
                        return "Unknown"
                    #endif
                }()
                
                return "\(osName) \(versionString)"
            }()
            
            return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion) like Mac OS X)"
        }
        
        return "Alamofire"
    }()
	
    private class var APIVersionString: String {
        get {
			return ""
        }
    }
    
    func addHeaders(request: URLRequest) -> URLRequest {
        var requestWithHeader = request
        if let token = AuthorizationManager.shared.getAccessToken() {
            requestWithHeader.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        requestWithHeader.setValue(Request.acceptLanguage, forHTTPHeaderField: "Accept-Language")
        requestWithHeader.setValue(Request.userAgent, forHTTPHeaderField: "User-Agent")
        
        return requestWithHeader
    }
    
    func formData(for boundary: String, withCanonical data:(name: String, data: Data)) -> Data {
        var payload = Data()
        if let boundaryData = "--\(boundary)\n".data(using: .utf8),
            let newline = "\n".data(using: .utf8),
            let contentDisposition = "Content-Disposition: form-data; name=\"\(data.name)\"\n".data(using: .utf8) {
            payload.append(boundaryData)
            payload.append(contentDisposition)
            payload.append(newline)
            payload.append(data.data)
            payload.append(newline)
        }
        return payload
    }
    
    func formData(for boundary: String, with data:(name: String, data: Any)) -> Data {
        var payload = Data()
        if let boundaryData = "--\(boundary)\n".data(using: .utf8),
            let newline = "\n".data(using: .utf8),
            let contentDisposition = "Content-Disposition: form-data; name=\"\(data.name)\"\n".data(using: .utf8),
            let data = "\(data.data)".data(using: .utf8) {
            payload.append(boundaryData)
            payload.append(contentDisposition)
            payload.append(newline)
            payload.append(data)
            payload.append(newline)
        }
        return payload
    }
    
    func formData(for boundary: String, with data:(name: String, image: UIImage)) -> Data {
        var payload = Data()
        if let boundaryData = "--\(boundary)\n".data(using: .utf8),
            let contentType = "Content-Type: image/jpeg\n".data(using: .utf8),
            let newline = "\n".data(using: .utf8),
            let contentDisposition = "Content-Disposition: form-data; name=\"\(data.name)\"; filename=\"image\"\n".data(using: .utf8),
            let imageData = data.image.jpegData(compressionQuality: 0.5) {
            payload.append(boundaryData)
            payload.append(contentDisposition)
            payload.append(contentType)
            payload.append(newline)
            payload.append(imageData)
            payload.append(newline)
        }
        return payload
    }
}

extension Request {
    static var baseURL = "https://pidvezy-debug.herokuapp.com/api/"
}
