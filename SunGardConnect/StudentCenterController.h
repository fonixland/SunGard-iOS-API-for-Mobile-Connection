//
//  StudentCenterController.h
//  SunGardConnect
//
//  Created by Sonny on 9/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Student.h"

@interface StudentCenterController : UITableViewController <MFMailComposeViewControllerDelegate>
{    
    Student *currentStudent;
}
@property (nonatomic, retain) Student *currentStudent;
@end
