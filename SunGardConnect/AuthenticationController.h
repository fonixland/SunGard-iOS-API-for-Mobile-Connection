//
//  SunGardConnectViewController.h
//  SunGardConnect
//
//  Created by Sonny on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticationController : UIViewController <UITextFieldDelegate> {
    UILabel *successLabel;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UILabel *successLabel;
- (IBAction)login:(id)sender;

@end
