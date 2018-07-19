//
//  APIHandler.swift
//  Testing
//
//  Created by Dev on 13/07/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

class APIHandler: NSObject {
    
    class func getJSON(withUrl url:String,withParameters params:[String:AnyObject]!,success:@escaping ([String: AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        var urlToSend:String = ""
        var newUrl = url
        if let param = params {
            if param.count > 0 {
                newUrl = url + "?"
                for (key,value) in param {
                    newUrl = "\(newUrl)\(key)=\(value)&"
                }
                urlToSend = newUrl.substring(to: newUrl.characters.index(newUrl.startIndex, offsetBy: newUrl.characters.count - 1))
            }
        }else {
            urlToSend = url
        }
        
        
        urlToSend = urlToSend.replacingOccurrences(of: " ", with: "%20")
        
        print(urlToSend)
        var request = URLRequest(url: URL(string: urlToSend)!)
        request.addValue("188c089f-2ed5-4648-80d5-b1a41b5a4eb6", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async(execute: {
                    
                    failure(error!.localizedDescription)
                })
            }
            else {
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200
                {
                    do {
                        let responseDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        DispatchQueue.main.async(execute: {
                            
                            success(responseDict as! [String: AnyObject])
                        })
                    }
                    catch {
                        
                        DispatchQueue.main.async(execute: {
                            
                            failure("ErrorMsg")
                        })
                        
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        
                        failure("ErrorMsg")
                    })
                }
            }
        })
        task.resume()
    }
    
    
    class func postJSON(withURL url:String,withParameters params:[String:AnyObject],withHeader header:String,success:@escaping ([String:AnyObject]) -> (),failure:@escaping (String) -> ())
    {
        
        var request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        request.httpMethod = "POST"
        let parameters = params
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        catch {
            
        }
        print(url)
        
        request.addValue("188c089f-2ed5-4648-80d5-b1a41b5a4eb6", forHTTPHeaderField: "Authorization")
        request.addValue("\(header)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(header)", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error == nil
            {
                let httpResponse = response as! HTTPURLResponse
                
                print("Http Response is: \(httpResponse)")
                if httpResponse.statusCode == 200
                {
                    do
                    {
                        
                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        
                        //            var newJsonData = jsonData as! [String:Any]
                        
                        DispatchQueue.main.async(execute: {
                            
                            print("Json data is: \(jsonData)")
                            
                            success(jsonData as! [String : AnyObject])
                           
                        })
                    }
                    catch {
                        DispatchQueue.main.async(execute: {
                            failure("Oops! some problem occured")
                        })
                    }
                    
                }
                    
                else
                {
                    DispatchQueue.main.async(execute: {
                        failure("ErrorMsg")
                    })
                }
            }
            else
            {
                DispatchQueue.main.async(execute: {
                    failure("ErrorMsg")
                })
            }
        })
        task.resume()
    }
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
