//
//  OEXVideoPlayerInterface.h
//  edX_videoStreaming
//
//  Created by Nirbhay Agarwal on 13/05/14.
//  Copyright (c) 2014 edX, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CLVideoPlayer.h"
#import "OEXHelperVideoDownload.h"

@protocol OEXVideoPlayerInterfaceDelegate <NSObject>

- (void)movieTimedOut;

@optional
- (void) videoPlayerTapped:(UIGestureRecognizer *) sender;

@end

@interface OEXVideoPlayerInterface : UIViewController <CLVideoPlayerControllerDelegate>

@property(nonatomic, weak) id <OEXVideoPlayerInterfaceDelegate>  delegate;
// Allows setting the controller's view. This is deprecated, the controller should be responsible for its own view
@property (nonatomic, weak) UIView* videoPlayerVideoView;
@property (nonatomic, strong) CLVideoPlayer* moviePlayerController;
@property(nonatomic) BOOL shouldRotate;

//player height and width
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;

// This is deprecated. Once old uses of this class are removed, remove it
// The owner should be responsible for this, in case it needs to fade in *with* other UI
// Defaults to true for backward compatibility reasons
@property (assign, nonatomic) BOOL fadeInOnLoad;

- (void)orientationChanged:(NSNotification*)notification;
- (void)playVideoFor:(OEXHelperVideoDownload*)video;
- (void)resetPlayer;
- (void)videoPlayerShouldRotate;
- (void)setAutoPlaying:(BOOL)playing;
// Add orientation observer for my videos, will remove this when enable landscape mode for my videos section
- (void) enableFullscreenAutorotation;

// Disable moving directly from one video to the next
@property (assign, nonatomic) BOOL hidesNextPrev;

@end
