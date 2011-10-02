//
//  Student.m
//  SunGardConnect
//
//  Created by Sonny on 9/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Student.h"
#import "SFHFKeychainUtils.h"
@implementation Student
@synthesize username,studentID;
-(NSString *)findPassword{
    
    NSError *error = nil;
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:@"SunGard" error:&error];
    if (error)
        NSLog(@"Keychain Return Password: %@",[error description]);
    
    return password;
}

-(void)storePassword:(NSString *)password{

    NSError *error = nil;
    [SFHFKeychainUtils storeUsername:username andPassword:password forServiceName:@"SunGard" updateExisting:YES error:&error];
    if (error)
        NSLog(@"Keychain Insertion: %@",[error description]);    
}

-(void)removePassword
{
    NSError *error = nil;
    [SFHFKeychainUtils deleteItemForUsername:username andServiceName:@"SunGard" error:&error];
    if (error)
    {
    NSLog(@"Keychain Removal: %@",[error description]);
    }
}


@end
