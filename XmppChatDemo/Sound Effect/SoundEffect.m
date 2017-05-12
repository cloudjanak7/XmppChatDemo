//
//  SoundEffect.m
//  Talk2Good
//
//  Created by Sandeep Kumar on 15/12/15.
//  Copyright © 2015 InfoiconTechnologies. All rights reserved.
//

#import "SoundEffect.h"

@interface SoundEffect ()
{
        
        NSTimer *messageCoundownTimer;
}

@property (nonatomic, retain) AVAudioPlayer *messagePlayer;

@end

@implementation SoundEffect
@synthesize messagePlayer;

+ (SoundEffect *)sharedSoundEffect
{
        static SoundEffect *sharedInstance = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                sharedInstance = [[SoundEffect alloc] init];
        });
        return sharedInstance;
}


-(void)messageToneStart{
        
        dispatch_async(dispatch_get_main_queue(), ^{
                if (!messagePlayer.playing){
                        NSString *soundFilePath =[[NSBundle mainBundle] pathForResource: @"pop" ofType: @"mp3"];
                        NSURL *fileURL =[[NSURL alloc] initFileURLWithPath: soundFilePath];
                        AVAudioPlayer *newPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
                        messagePlayer = newPlayer;
                        
                        
                        //Play ring tone
                        messagePlayer.numberOfLoops = -1;
                        messagePlayer.currentTime = 0;
                        messagePlayer.volume = 1.0;
                        [messagePlayer play];
                        
                        [self setMessageCoundwonTimer:1];
                        
                }
                
        });
        
}

-(void)messageToneStop{
        
        dispatch_async(dispatch_get_main_queue(), ^{
                //Stop Ring tone
                if (messagePlayer.playing)
                {
                        [messagePlayer stop];
                        
                }
                [self setMessageCoundwonTimer:0];
        });
        
}

-(void)setMessageCoundwonTimer:(int) interval{
        if (messageCoundownTimer && [messageCoundownTimer isValid]) {
                [messageCoundownTimer invalidate];
                messageCoundownTimer = NULL;
        }
        
        
        if (interval > 0) {
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                                  target:self
                                                                selector:@selector(messageToneStop)
                                                                userInfo:nil
                                                                 repeats:NO];
                messageCoundownTimer = timer;
        }
        
}


@end
