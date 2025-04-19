import Foundation
import AVKit
class APIMessage {
    var ResponseCode: Int = 404 // Not-Ok
    var ResponseData: Data?
    var ResponseMessage: String = "OK"
}

class APIWrapper {
    private let baseURLString = "http://192.168.43.93/Final_Project/api/"
    
    func getMethodCall(controllerName: String, actionName: String) -> APIMessage {
        let apiMessage = APIMessage()
        
        let completePath: String = "\(baseURLString)\(controllerName)/\(actionName)"
        guard let url = URL(string: completePath) else {
            apiMessage.ResponseCode = 209 // error
            apiMessage.ResponseMessage = "Error: cannot create URL"
            return apiMessage
        }
        
        let group = DispatchGroup()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        group.enter()
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                apiMessage.ResponseMessage = error.debugDescription
                group.leave()
                return
            }
            
            let rurl = (response as! HTTPURLResponse)
            apiMessage.ResponseCode = rurl.statusCode
            
            guard let responseData = data else {
                apiMessage.ResponseMessage = "Error: did not receive data"
                group.leave()
                return
            }
            
            apiMessage.ResponseData = responseData
            apiMessage.ResponseMessage = String(data: data!, encoding: .utf8) ?? rurl.description
            group.leave()
        }
        task.resume()
        group.wait()
        return apiMessage
    }
    
    func postMethodCall(controllerName: String, actionName: String, httpBody: Data) -> APIMessage {
        let apiMessage = APIMessage()
        
        let completePath: String = "\(baseURLString)\(controllerName)/\(actionName)"
        guard let url = URL(string: completePath) else {
            apiMessage.ResponseCode = 209 // error
            apiMessage.ResponseMessage = "Error: cannot create URL"
            return apiMessage
        }
        
        let group = DispatchGroup()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = httpBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        group.enter()
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                apiMessage.ResponseMessage = error.debugDescription
                group.leave()
                return
            }
            
            let rurl = (response as! HTTPURLResponse)
            apiMessage.ResponseCode = rurl.statusCode
            
            guard let responseData = data else {
                apiMessage.ResponseMessage = "Error: did not receive data"
                group.leave()
                return
            }
            apiMessage.ResponseData = responseData
            apiMessage.ResponseMessage = String(data: data!, encoding: .utf8) ?? rurl.description
            
            group.leave()
        }
        task.resume()
        group.wait()
        return apiMessage
    }
    
    func createBody(parameters: [String: String], boundary: String, data: Data, mimeType: String, filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        return body as Data
    }
    
    func uploadImageMethodCall(cJson: Data, endPoint: String) -> APIMessage {
        let apiMessage = APIMessage()
        
        let todoEndpoint: String = "\(baseURLString)\(endPoint)"
        guard let url = URL(string: todoEndpoint) else {
            apiMessage.ResponseCode = 209 // error
            return apiMessage
        }
        
        let group = DispatchGroup()
        let params = ["user": "abc"]
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = createBody(parameters: params, boundary: boundary, data: cJson, mimeType: "image/jpg", filename: "hello.jpg")
        
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("multipart/form-data", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        group.enter()
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                group.leave()
                return
            }
            
            guard let responseData = data else {
                group.leave()
                return
            }
            
            let rurl = (response as! HTTPURLResponse)
            apiMessage.ResponseCode = rurl.statusCode
            apiMessage.ResponseData = responseData
            apiMessage.ResponseMessage = String(data: data!, encoding: .utf8) ?? rurl.description
            
            group.leave()
        }
        task.resume()
        group.wait()
        return apiMessage
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
