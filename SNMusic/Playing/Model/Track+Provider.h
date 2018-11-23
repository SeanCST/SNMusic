//
//  Track+Provider.h
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/23.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "Track.h"

@interface Track (Provider)

+ (NSArray *)remoteTracks;
+ (NSArray *)musicLibraryTracks;

@end
