//
//  FirstViewPage.h
//  CameraIntegration
//
//  Created by lab702 on 2017/3/20.
//  Copyright © 2017年 Wlson.lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>




@interface FirstViewPage : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) AVPlayer *videoPlayer;
@property (strong, nonatomic) AVPlayerItem *videoPlayerItem;
@property (strong, nonatomic) AVPlayerLayer *videoPlayerLayer;

@end
