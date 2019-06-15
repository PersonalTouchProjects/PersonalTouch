//
//  APIClient.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/12.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import Foundation
import Alamofire

//private let host = "http://192.168.1.109:3000/api/v1"
private let host = "https://secret-fjord-21101.herokuapp.com/api/v1"
private let userHeaderField = "X-Mytouch-User"
private let apnsTokenField = "X-Mytouch-APNS-Token"

class APIClient {
    
    private func userIdentify() -> String {
        
        let key = UserDefaults.Key.userIdentity
        
        if let id = UserDefaults.standard.string(forKey: key) {
            print("found in UserDefaults")
            return id
        }
        
        return generateUserIdentity()
    }
    
    private func generateUserIdentity() -> String {
        
        let id = UUID().uuidString
        
        print("generate id: \(id)")
        
        let key = UserDefaults.Key.userIdentity
        
        UserDefaults.standard.set(id, forKey: key)
        UserDefaults.standard.synchronize()
        
        return id
    }
    
    func loadSessions(decoder: JSONDecoder = APIClient.decoder, completion: @escaping ([Session]?, Error?) -> Void) {
        
        let id = userIdentify()
        print("header: id - \(id)")
        
        let headers = [userHeaderField: id]
        
        Alamofire.request("\(host)/sessions", headers: headers).responseJSON { res in
            
            if let error = res.error {
                completion(nil, error)
            }
            else if let data = res.data {
                
                do {
                    let sessions = try decoder.decode([Session].self, from: data)
                    completion(sessions, nil)
                }
                catch {
                    completion(nil, error)
                }
            }
            else {
                completion(nil, nil)
            }
        }
    }
    
    func uploadSession(_ session: Session, encoder: JSONEncoder = APIClient.encoder, decoder: JSONDecoder = APIClient.decoder, completion: @escaping (Session?, Error?) -> Void) {
        
        let id = userIdentify()
        print("header: id - \(id)")
        
        do {
            var headers = [
                "Content-Type": "application/json",
                userHeaderField: id
            ]
            if let token = UserDefaults.standard.string(forKey: UserDefaults.Key.apnsToken) {
                headers[apnsTokenField] = token
            }
            
            let data = try encoder.encode(session)
            
            Alamofire.upload(data, to: "\(host)/sessions", headers: headers)
            .responseJSON { res in
                
                if let error = res.error {
                    completion(nil, error)
                }
                else if let data = res.data {
                    do {
                        let uploaded = try decoder.decode(Session.self, from: data)
                        completion(uploaded, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, nil)
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


private var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    return formatter
}()
