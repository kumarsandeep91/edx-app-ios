//
//  UserPreferenceManager.swift
//  edX
//
//  Created by Kevin Kim on 7/28/16.
//  Copyright © 2016 edX. All rights reserved.
//

import Foundation

public class UserPreferenceManager : NSObject {
    
    private let networkManager : NetworkManager
    private let session: OEXSession
    private let currentPreferenceFeed = BackedFeed<UserPreference>()
    private let currentPreferenceUpdateStream = Sink<UserPreference>()
    private let cache = LiveObjectCache<Feed<UserPreference>>()
    
    public init(networkManager : NetworkManager, session : OEXSession) {
        self.networkManager = networkManager
        self.session = session
        
        super.init()
        
        self.currentPreferenceFeed.backingStream.addBackingStream(currentPreferenceUpdateStream)
        
        NSNotificationCenter.defaultCenter().oex_addObserver(self, name: OEXSessionEndedNotification) { (_, owner, _) -> Void in
            owner.sessionChanged()
        }
        NSNotificationCenter.defaultCenter().oex_addObserver(self, name: OEXSessionStartedNotification) { (_, owner, _) -> Void in
            owner.sessionChanged()
        }
        self.sessionChanged()
    }
    
    public func feedForUser(username : String) -> Feed<UserPreference> {
        return self.cache.objectForKey(username) {
            let request = PreferenceAPI.preferenceRequest(username)
            return Feed(request: request, manager: self.networkManager)
        }
    }
    
    private func sessionChanged() {
        if let username = self.session.currentUser?.username {
            self.currentPreferenceFeed.backWithFeed(self.feedForUser(username))
        }
        else {
            self.currentPreferenceFeed.removeBacking()
            // clear the stream
            self.currentPreferenceUpdateStream.send(NSError.oex_unknownError())
        }
        if self.session.currentUser == nil {
            self.cache.empty()
        }
    }
    
    // Feed that updates if the current user changes
//    public func feedForCurrentUser() -> Feed<UserPreference> {
//        return currentPreferenceFeed
//    }
//    
//    public func updateCurrentUserProfile(profile : UserProfile, handler : Result<UserPreference> -> Void) {
//        let request = PreferenceAPI.preferenceUpdateRequest(profile)
//        self.networkManager.taskForRequest(request) { result -> Void in
//            if let data = result.data {
//                self.currentPreferenceUpdateStream.send(Success(data))
//            }
//            handler(result.data.toResult(result.error))
//        }
//    }
}