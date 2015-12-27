//
//  LiveObjectCache.swift
//  edX
//
//  Created by Akiva Leffert on 10/28/15.
//  Copyright © 2015 edX. All rights reserved.
//

import Foundation

public protocol LifetimeTrackable : class {
    /// Lifetime should be associated with Self such that it gets deallocated when the object owning
    /// get deallocated
    var lifetimeToken : NSObject { get }
}

extension NSObject : LifetimeTrackable {
    public var lifetimeToken : NSObject {
        return self
    }
}

private struct Weak<A : AnyObject> {
    weak var value : A?
    init(_ value : A) {
        self.value = value
    }
}

/// Cache that doesn't clear an object as long as it has live pointers
/// this way you don't end up with duplicated objects when the memory cache gets flushed.
public class LiveObjectCache<A : LifetimeTrackable> : NSObject {
    private let dataCache = NSCache()
    private var activeObjects : [String : Weak<A>] = [:]
    private var deallocActionRemovers : [Removable] = []
    
    override public init() {
        super.init()
        NSNotificationCenter.defaultCenter().oex_addObserver(self, name: UIApplicationDidReceiveMemoryWarningNotification) { (_, owner, _) -> Void in
            owner.dataCache.removeAllObjects()
        }
    }
    
    public func objectForKey(key : String, @noescape generator : () -> A) -> A {
        // first look in the active objects cache
        if let object = activeObjects[key]?.value {
            dataCache.setObject(Box(object), forKey: key)
            return object
        }
        else if let object = dataCache.objectForKey(key) as? Box<A> {
            return object.value
        }
        else {
            let object = generator()
            dataCache.setObject(Box(object), forKey: key)
            activeObjects[key] = Weak(object)
            let removable = object.lifetimeToken.oex_performActionOnDealloc {[weak self] in
                self?.activeObjects.removeValueForKey(key)
            }
            deallocActionRemovers.append(BlockRemovable{removable.remove()})
            return object
        }
    }
    
    public func empty() {
        dataCache.removeAllObjects()
        activeObjects = [:]
        for actionRemover in deallocActionRemovers {
            actionRemover.remove()
        }
    }
}