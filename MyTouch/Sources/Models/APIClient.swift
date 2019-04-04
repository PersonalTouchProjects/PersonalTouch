//
//  APIClient.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/12.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    
    private func userIdentify() -> String? {
        
        let key = UserDefaults.Key.userIdentity
        
        if let id = UserDefaults.standard.string(forKey: key) {
            print("found in UserDefaults")
            return id
        }
        
        if let id = NSUbiquitousKeyValueStore.default.string(forKey: key) {
            print("found in NSUbiquitousKeyValueStore")
            UserDefaults.standard.set(id, forKey: key)
            UserDefaults.standard.synchronize()
            return id
        }
        
        return nil
    }
    
    private func generateUserIdentity() -> String {
        
        let id = UUID().uuidString
        
        print("generate id: \(id)")
        
        let key = UserDefaults.Key.userIdentity
        
        UserDefaults.standard.set(id, forKey: key)
        UserDefaults.standard.synchronize()
        
        NSUbiquitousKeyValueStore.default.set(id, forKey: key)
        NSUbiquitousKeyValueStore.default.synchronize()
        
        return id
    }
    
    func loadSessions(decoder: JSONDecoder = APIClient.decoder, completion: @escaping ([Session]?, Error?) -> Void) {
        
        let id = userIdentify() ?? generateUserIdentity()
        print("header: id - \(id)")
        
        completion([], nil)
        return
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            
//            let path = Bundle.main.path(forResource: "sessionsSample", ofType: "json")!
//            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
//            
//            do {
//                let sessions = try decoder.decode([Session].self, from: data)
//                
//                completion(sessions, nil)
//            } catch {
//                completion(nil, error)
//            }
//        }
    }
    
    func uploadSession(_ session: Session, encoder: JSONEncoder = APIClient.encoder, completion: @escaping (Session?, Error?) -> Void) {
        
        let id = userIdentify() ?? generateUserIdentity()
        print("header: id - \(id)")
        
        do {
            let data = try encoder.encode(session)
            
            Alamofire.upload(data, to: "https://httpbin.org/post", headers: ["Content-Type": "application/json"])
            .responseJSON { res in
                
                if let error = res.error {
                    completion(nil, error)
                }
                else {
                    do {
                        
                        // TODO: real implementation
                        
                        let value = res.value as! [String: Any]
                        let json = value["json"]!
                        let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        
                        let session = try APIClient.decoder.decode(Session.self, from: data)
                        completion(session, nil)
                    }
                    catch {
                        completion(nil, error)
                    }
                }
            }
        }
        catch {
            completion(nil, error)
        }
    }
}

extension APIClient {
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.nonConformingFloatDecodingStrategy = .convertFromString(
            positiveInfinity: "+inf",
            negativeInfinity: "-inf",
            nan: "nan")
        return decoder
    }()
    
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.nonConformingFloatEncodingStrategy = .convertToString(
            positiveInfinity: "+inf",
            negativeInfinity: "-inf",
            nan: "nan")
        return encoder
    }()
    
}
