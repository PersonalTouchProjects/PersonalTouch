//
//  SessionController.swift
//  MyTouch
//
//  Created by Tommy Lin on 2019/2/2.
//  Copyright © 2019 NTU HCI Lab. All rights reserved.
//

import UIKit
import ResearchKit

extension SessionController {
    
    enum State {
        case initial
        case success(sessions: [Session])
        case error(error: Error)
        
        var sessions: [Session]? {
            if case .success(let sessions) = self { return sessions }
            return nil
        }
        
        var error: Error? {
            if case .error(let error) = self { return error }
            return nil
        }
    }
}

class SessionController: NSObject {

    static let shared = SessionController()
    
    var researchController = ResearchController()
    
    private(set) var state: State = .initial
    
    private let client = APIClient()
    private var isFetching = false
    private var fetchingLock = NSLock()
    
    
    // MARK: - API
    
    func fetchSessions() {
       
        fetchingLock.lock()
        
        guard !isFetching else {
            fetchingLock.unlock()
            return
        }
        
        isFetching = true
        fetchingLock.unlock()
        
        client.fetchSessionResults { (sessions, error) in
            
            if let error = error {
                self.state = .error(error: error)
            } else if let sessions = sessions {
                let results = (self.temporarySessions() + sessions).sorted { $0.start > $1.start } // latest on top
                self.state = .success(sessions: results)
            } else {
                self.state = .success(sessions: [])
            }
            
            self.isFetching = false
            
            let notification = Notification(name: .sessionControllerDidChangeState, object: self, userInfo: nil)
            NotificationQueue.default.enqueue(notification, postingStyle: .asap)
        }
    }
    
    
    // MARK: - Temporary session list
    
    func addTemporarySession(_ session: Session) {
        
        let path = defaultDocumentDirectoryPath().appendingPathComponent(session.filename)
        
        do {
            let data = try APIClient.encoder.encode(session)
            try data.write(to: path, options: .atomic)
            
            var temps = UserDefaults.standard.array(forKey: "localSessions") as? [String] ?? []
            if !temps.contains(path.lastPathComponent) {
                temps.append(path.lastPathComponent)
                UserDefaults.standard.set(temps, forKey: "localSessions")
                UserDefaults.standard.synchronize()
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func temporarySessions() -> [Session] {
        
        var sessions = [Session]()
        
        let names = UserDefaults.standard.array(forKey: "localSessions") as? [String] ?? []
        
        for name in names {
            do {
                let url = defaultDocumentDirectoryPath().appendingPathComponent(name)
                let data = try Data(contentsOf: url)
                let session = try APIClient.decoder.decode(Session.self, from: data)
                
                sessions.append(session)
            } catch {
                print(error)
            }
        }
        
        return sessions
    }
    
}

