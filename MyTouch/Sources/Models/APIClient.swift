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
    
    func loadSessions(decoder: JSONDecoder = APIClient.decoder, completion: @escaping ([Session]?, Error?) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
//            completion(nil, NSError(domain: "aaa", code: 123, userInfo: nil))
//            return
            
            let path = Bundle.main.path(forResource: "sessionsSample", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            
            do {
                let sessions = try decoder.decode([Session].self, from: data)
                
                completion(sessions, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func uploadSession(_ session: Session, encoder: JSONEncoder = APIClient.encoder, completion: @escaping (Session?, Error?) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            
            do {
                let data = try encoder.encode(session)
                print(data.count)
                
                completion(session, nil)
            }
            catch {
                completion(nil, error)
            }
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
