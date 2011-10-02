//
//  SunGardConnectViewController.m
//  SunGardConnect
//
//  Created by Sonny on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthenticationController.h"
#import "StudentCenterController.h"
#import "AFSunGardAPIClient.h"
#import "SFHFKeychainUtils.h"
#import "Student.h"
#import "JSONKit.h"

@implementation AuthenticationController
@synthesize successLabel;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"SunGard Mobile Connection";
    [scrollView setContentSize:CGSizeMake(320, 500)];
    [scrollView setBackgroundColor:[UIColor lightGrayColor]];
    [successLabel setText:@""];

   
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Login Page" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
    [newBackButton release];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)viewDidUnload
{
    [self setSuccessLabel:nil];
    [usernameField release];
    usernameField = nil;
    [passwordField release];
    passwordField = nil;
    [scrollView release];
    scrollView = nil;
    [super viewDidUnload];
    self.successLabel = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [successLabel release];
    [usernameField release];
    [passwordField release];
    [scrollView release];
    [super dealloc];
}
- (IBAction)login:(id)sender {
    
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    if ([usernameField.text length] > 0 && [passwordField.text length] > 0)
    {
        [[AFSunGardAPIClient sharedClient] setAuthorizationHeaderWithUsername:usernameField.text password:passwordField.text];
    
    [[AFSunGardAPIClient sharedClient] getPath:@"security/getUserInfo" parameters:nil success:^(id response){
    
    if ([[response valueForKey:@"status"] isEqualToString:@"success"])
        {
            Student *newStudent = [[Student alloc]init];
            [newStudent setUsername:usernameField.text];
            [newStudent storePassword:passwordField.text];
            [newStudent setStudentID:[response valueForKey:@"userId"]];
            StudentCenterController *studentView = [[StudentCenterController alloc]initWithStyle:UITableViewStylePlain];
            studentView.currentStudent = newStudent;
            
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:studentView];
            
            [self.navigationController presentModalViewController:navController animated:YES];
            
            [navController release];
            [newStudent release];
            [studentView release];
        }
        else{
            [successLabel setText:@"Error in Connection"];
        }
        
        
        
    }failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
        [successLabel setText:@"Incorrect Username/Password"];
    }];
}
}

@end
