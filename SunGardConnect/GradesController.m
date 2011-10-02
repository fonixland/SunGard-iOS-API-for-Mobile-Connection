//
//  GradesController.m
//  SunGardConnect
//
//  Created by Sonny on 9/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GradesController.h"
#import "AFSunGardAPIClient.h"
#import "AFJSONRequestOperation.h"

@implementation GradesController
@synthesize gradesDatabase,studentUser;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



-(void)networkRequest:(NSString *)appendText{
    
    self.navigationItem.rightBarButtonItem = nil;
    NSString *urlString;

    if ([appendText length] > 0){
    urlString = [NSString stringWithFormat:@"%@%@:%@@%@%@/%@/%@",urlPrefix,[studentUser username],[studentUser findPassword],baseURLofServer,@"grade/student", [studentUser studentID],appendText];
    }
    else{
    urlString = [NSString stringWithFormat:@"%@%@:%@@%@%@/%@/",urlPrefix, [studentUser username],[studentUser findPassword],baseURLofServer,@"grade/student", [studentUser studentID]];    
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation operationWithRequest:request acceptableStatusCodes:nil acceptableContentTypes:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
      
        [gradesDatabase addObject:(NSMutableDictionary *)JSON];
        
        if (![[NSNull null] isEqual:[JSON valueForKeyPath:@"previousTermId"]]) {
            [self networkRequest:[NSString stringWithFormat:@"term/%@",[JSON valueForKeyPath:@"previousTermId"]]];  
        }
        [self.tableView reloadData];
      
        
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Grades Download/Parse Error: %@",[error description]);
    
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,0,340,60)];
        UITextView *textField = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        
        UIBarButtonItem *tryAgain = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(networkRequest:)];
        self.navigationItem.rightBarButtonItem = tryAgain;
        [tryAgain release];
   

        
        //Server gave 500 Error
        if([response statusCode] == 500)
       {
           textField.text = @"Error: Server Unavailable. Try Again";
       }
        //Crendentials Invalid for Server
        else if ([response statusCode] == 401)
        {
            textField.text = @"Error: Invalid Credentials";
            NSLog(@"GradesController: Invalid Credentials");
        }
        
        else {
           textField.text = @"Error: Unable to load grades";
        }
       
    
        textField.backgroundColor = [UIColor clearColor];
        textField.textAlignment = UITextAlignmentCenter;
        textField.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        textField.editable = NO;
        [topView addSubview:textField];
        [textField release];
        self.tableView.tableHeaderView = topView;
        [topView release];
        
        
    }];
    
    queue = [[[NSOperationQueue alloc]init] autorelease];
    [queue addOperation:operation];
                                         
                                         
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Grades";
    
    gradesDatabase = [[NSMutableArray alloc]init];
    
    /*Uses Basic Authentication username:password @ url format for sending password data to remote server.
     The URL should look like http://username:password@university.edu:8041/mobileserver/rest/schedule/student/start/2011-09-26/end/2011-09-30
     AFJSONRequestOperation handles networking request and provides a success block for storing the recieved JSON data.
     
     We reload the UITableView after success to update the interface
     */
        
    [self networkRequest:nil];
    
  }

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [gradesDatabase count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[gradesDatabase objectAtIndex:section] valueForKey:@"grades"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [[[[gradesDatabase objectAtIndex:indexPath.section] objectForKey:@"grades"] objectAtIndex:indexPath.row]
                           objectForKey:@"courseDescription"];
    cell.detailTextLabel.text = [[[[gradesDatabase objectAtIndex:indexPath.section] objectForKey:@"grades"] objectAtIndex:indexPath.row]
                                 objectForKey:@"instructorName"];
    
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
