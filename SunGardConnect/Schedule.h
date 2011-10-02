//
//  Schedule.h
//  SunGardConnect
//
//  Created by Sonny on 9/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject
{
    NSString *courseName;
    NSString *location;
    NSArray *courses;
}
@property (nonatomic,retain) NSString *courseName;
@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain) NSArray *courses;
@end
