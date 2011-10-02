//
//  Schedule.m
//  SunGardConnect
//
//  Created by Sonny on 9/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule
@synthesize courseName,location,courses;

-(void)dealloc{
    [super dealloc];
    [courseName release];
    courseName = nil;
    [location release];
    location = nil;
    [courses release];
    courses = nil;
}

@end
