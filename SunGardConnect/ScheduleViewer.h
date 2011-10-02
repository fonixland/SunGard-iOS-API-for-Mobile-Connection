//
//  ScheduleViewer.m
//  SunGardConnect
//
//  Created by Sonny Fazio on 9/25/11.
//  Licensed under MIT License
//  Source Code provided "as is" without express or implied warranty.
//  
//  Connects to Banner Mobile Connection Server and downloads/displays the user's schedule data.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "Student.h"



@interface ScheduleViewer : UITableViewController
{
    NSMutableArray *week;
    Student *myStudent;
    NSOperationQueue *queue;

}
@property (nonatomic,retain) Student *myStudent;
@end
 