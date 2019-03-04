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
        case loading
        case empty
        case sessions(sessions: [Session])
        case error(error: Error)
    }
}

class SessionController: NSObject {

    private(set) var state: State = .initial {
        didSet {
            let notification = Notification(name: .sessionControllerDidChangeState, object: self, userInfo: nil)
            NotificationQueue.default.enqueue(notification, postingStyle: .asap)
        }
    }
    
    private let client = APIClient()
    private var fetchingLock = NSLock()
    
    
    // MARK: - API
    
    func fetchSessions() {
       
        fetchingLock.lock()
        
        if case .loading = self.state {
            fetchingLock.unlock()
            return
        }
        
        self.state = .loading
        fetchingLock.unlock()
        
        
        client.fetchSessionResults { (sessions, error) in
            
            if let error = error {
                self.state = .error(error: error)
            }
            else if let sessions = sessions {
                
                let locals = self.temporarySessions()
                let results = (locals + sessions).sorted { $0.start > $1.start } // latest on top
                
                if results.isEmpty {
                    self.state = .empty
                } else {
                    self.state = .sessions(sessions: results)
                }
            }
            else {
                // present only local sessions
                self.state = .sessions(sessions: self.temporarySessions())
            }
        }
    }
    
    
    // MARK: - Temporary session list
    
    func addTemporarySession(_ session: Session) {
        
        let path = defaultDocumentDirectoryPath().appendingPathComponent(session.filename)
        
        do {
            let data = try APIClient.encoder.encode(session)
            try data.write(to: path, options: .atomic)
            
            var temps = UserDefaults.standard.array(forKey: UserDefaults.Key.localSessions) as? [String] ?? []
            if !temps.contains(path.lastPathComponent) {
                temps.append(path.lastPathComponent)
                UserDefaults.standard.set(temps, forKey: UserDefaults.Key.localSessions)
                UserDefaults.standard.synchronize()
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func removeTemporarySession(_ session: Session) {
        let path = defaultDocumentDirectoryPath().appendingPathComponent(session.filename)
        removeTemporarySession(path: path)
    }
    
    func removeTemporarySession(path: URL) {
        
        do {
            if FileManager.default.fileExists(atPath: path.absoluteString) {
                try FileManager.default.removeItem(at: path)
            }
            
            let temps = UserDefaults.standard.array(forKey: UserDefaults.Key.localSessions) as? [String] ?? []
            var set = Set(temps)
            set.remove(path.lastPathComponent)
            UserDefaults.standard.set(set, forKey: UserDefaults.Key.localSessions)
            UserDefaults.standard.synchronize()
            
        } catch {
            print(error)
        }
    }
    
    func temporarySessions() -> [Session] {
        
        var sessions = [Session]()
        
        let names = UserDefaults.standard.array(forKey: UserDefaults.Key.localSessions) as? [String] ?? []
        
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

