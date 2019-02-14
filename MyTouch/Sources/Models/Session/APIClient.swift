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
    
    func fetchSessionResults(decoder: JSONDecoder = APIClient.decoder, completion: @escaping ([Session]?, Error?) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        
            let path = Bundle.main.path(forResource: "sessionsSample", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            
            do {
                let sessionResults = try decoder.decode([Session].self, from: data)
                
                completion(sessionResults, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
}

extension APIClient {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
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
