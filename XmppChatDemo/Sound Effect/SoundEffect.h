//
//  SoundEffect.h
//  Talk2Good
//
//  Created by Sandeep Kumar on 15/12/15.
//  Copyright © 2015 InfoiconTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundEffect : NSObject

+ (SoundEffect *)sharedSoundEffect;

-(void)messageToneStart;

@end
