//
//  PreferenceAPI.swift
//  edX
//
//  Created by Kevin Kim on 7/28/16.
//  Copyright © 2016 edX. All rights reserved.
//

import Foundation
import edXCore

public class PreferenceAPI: NSObject {
    
    private static var currentPreferenceFeed = [String: Feed<UserPreference>]()

    
    private static func preferenceDeserializer(response : NSHTTPURLResponse, json : JSON) -> Result<UserPreference> {
        return UserPreference(json: json).toResult()
    }
    
    private class func path(username:String) -> String {
        return "/api/user/v1/preferences/{username}".oex_formatWithParameters(["username": username])
    }
    
    class func preferenceRequest(username: String) -> NetworkRequest<UserPreference> {
        return NetworkRequest(
            method: HTTPMethod.GET,
            path : path(username),
            requiresAuth : true,
            deserializer: .JSONResponse(preferenceDeserializer))
    }
    
    class func getPreference(username: String, networkManager: NetworkManager, handler: (preference: NetworkResult<UserPreference>) -> ()) {
        let request = preferenceRequest(username)
        networkManager.taskForRequest(request, handler: handler)
    }
    
    class func getPreference(username: String, networkManager: NetworkManager) -> Stream<UserPreference> {
        let request = preferenceRequest(username)
        return networkManager.streamForRequest(request)
    }
    
//    class func profileUpdateRequest(profile: UserProfile) -> NetworkRequest<UserProfile> {
//        let json = JSON(profile.updateDictionary)
//        let request = NetworkRequest(method: HTTPMethod.PATCH,
//                                     path: path(profile.username!),
//                                     requiresAuth: true,
//                                     body: RequestBody.JSONBody(json),
//                                     headers: ["Content-Type": "application/merge-patch+json"], //should push this to a lower level once all our PATCHs support this content-type
//            deserializer: .JSONResponse(profileDeserializer))
//        return request
//    }
    
}
