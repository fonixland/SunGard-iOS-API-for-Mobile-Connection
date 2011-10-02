//
//  Student.h
//  SunGardConnect
//
//  Created by Sonny on 9/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
{
    NSString *username;
    NSString *studentID;
}
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *studentID;
-(NSString *)findPassword;
-(void)storePassword:(NSString *)password;
-(void)removePassword;

@end
