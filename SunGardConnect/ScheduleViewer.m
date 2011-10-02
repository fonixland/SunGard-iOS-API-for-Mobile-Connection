//
//  ScheduleViewer.m
//  SunGardConnect
//
//  Created by Sonny Fazio on 9/25/11.
//  Licensed under MIT License
//  Source Code provided "as is" without express or implied warranty.
//  
//  Connects to Banner Mobile Connection Server and downloads/displays the user's schedule data.


#import "ScheduleViewer.h"
#import "AFJSONRequestOperation.h"
#import "AFSunGardAPIClient.h"



@implementation ScheduleViewer
@synthesize myStudent;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Student Schedule";
    
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int today = [comp weekday]-2;

    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    //Banner API requires date format to be in YEAR-MONTH-DATE
    [format setDateFormat:@"yyy-MM-dd"];
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:-today*3600*24];
    NSDate *then = [now dateByAddingTimeInterval:4*3600*24];
    NSString *firstDate = [format stringFromDate:now];
    NSString *secondDate = [format stringFromDate:then];
    [format release];

    /*Uses Basic Authentication username:password @ url format for sending password data to remote server.
     The URL should look like http://username:password@university.edu:8041/mobileserver/rest/schedule/student/start/2011-09-26/end/2011-09-30
     AFJSONRequestOperation handles networking request and provides a success block for storing the recieved JSON data.
    
     We reload the UITableView after success to update the interface
    */
    NSString *urlString = [NSString stringWithFormat:@"%@%@:%@@%@%@/%@/start/%@/end/%@/",urlPrefix,[myStudent username],[myStudent findPassword],baseURLofServer,@"schedule/student", [myStudent studentID],firstDate,secondDate];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation operationWithRequest:request success:^(id JSON){
        week = [[NSMutableArray alloc]initWithArray:[JSON valueForKeyPath:@"dates"]];
        [self.tableView reloadData];
    }];
    queue = [[[NSOperationQueue alloc]init] autorelease];
    [queue addOperation:operation];


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
    return [week count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Monday";
            break;
        case 1:
            return @"Tuesday";
            break;
        case 2:
            return @"Wednesday";
            break;
        case 3:
            return @"Thursday";
            break;
        case 4:
            return @"Friday";
            break;
            
        default:
            break;
    }
    
    //Function requires return of String
    return @"Monday";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

return [[[week objectAtIndex:section] valueForKey:@"courses"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    
    NSDictionary *courseDictionary = [[NSDictionary alloc]initWithDictionary:[[[week objectAtIndex:indexPath.section] valueForKey:@"courses"] objectAtIndex:indexPath.row]];
    
    cell.textLabel.text = [courseDictionary valueForKey:@"description"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[courseDictionary valueForKey:@"startTime"], [courseDictionary valueForKey:@"location"]];
    
    [courseDictionary release];
    

    
    return cell;
}



-(void)dealloc{
    [super dealloc];
    [week release];
    [myStudent release];
    //[queue kil
//[queue release];
  //  queue = nil;
    week = nil;
    myStudent = nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*
     I would recommend creating and passing the NSDictionary of the row if you would like to have a drilled-down view that displays more schedule information.
     
     Something like
     
     ScheduleDetailViewController *detail = [[ScheduleDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
     detail.course = courseDictionary;
     [self.navigationController pushViewController:detail animated:YES];
     [detail release];
     
     */
}

@end
