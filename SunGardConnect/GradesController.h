//
//  GradesController.h
//  SunGardConnect
//
//  Created by Sonny on 9/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface GradesController : UITableViewController
{
 NSOperationQueue *queue;   
}
@property (nonatomic, retain) NSMutableArray *gradesDatabase;
@property (nonatomic, retain) Student *studentUser;
-(void)networkRequest:(NSString *)appendText;
@end
