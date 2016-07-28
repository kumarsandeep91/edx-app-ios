//
//  UserPreference.swift
//  edX
//
//  Created by Kevin Kim on 7/28/16.
//  Copyright © 2016 edX. All rights reserved.
//

import Foundation
import edXCore

public class UserPreference {
    
    enum PreferenceKeys: String, RawStringExtractable {
        case Username = "username"
        case PrefLang = "pref-lang"
        case TimeZone = "time_zone"
    }
    
    var username: String?
    var timeZone: String?
    var prefLang: String?
    
    var hasUpdates: Bool { return updateDictionary.count > 0 }
    var updateDictionary = [String: AnyObject]()
    
    public init?(json: JSON) {
        prefLang = json[PreferenceKeys.PrefLang].string ?? ""
        timeZone = json[PreferenceKeys.TimeZone].string ?? ""
    }
    
    internal init(username : String, prefLang: String? = nil, timeZone : String? = nil) {
        self.username = username
        self.prefLang = prefLang
        self.timeZone = timeZone
    }
    
}
