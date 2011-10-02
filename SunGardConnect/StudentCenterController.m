//
//  StudentCenterController.m
//  SunGardConnect
//
//  Created by Sonny on 9/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StudentCenterController.h"
#import "GradesController.h"
#import "ScheduleViewer.h"
#import "AboutViewController.h"
#import "MapView.h"
#import "Web.h"
@implementation StudentCenterController
@synthesize currentStudent;

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
    self.title = @"Student Center";
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = done;
    [done release];
    
    
    UIBarButtonItem *about = [[UIBarButtonItem alloc]initWithTitle:@"About" style:UIBarButtonItemStyleBordered target:self action:@selector(launchAbout)];
    self.navigationItem.rightBarButtonItem = about;
    [about release];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    if (indexPath.row == 0)
    {
    cell.textLabel.text = @"Grades";
    cell.imageView.image = [UIImage imageNamed:@"reciept.png"];
    }
    else if (indexPath.row == 1)
    {
    cell.textLabel.text = @"Schedule";
    cell.imageView.image = [UIImage imageNamed:@"calendar2.png"];

    }
    else if (indexPath.row == 2)
    {
    cell.textLabel.text = @"Campus Map";
    cell.imageView.image = [UIImage imageNamed:@"map.png"];

    }
    else if (indexPath.row == 3)
    {
    cell.textLabel.text = @"Contact Support";
    cell.imageView.image = [UIImage imageNamed:@"headset.png"];

    }
    else if (indexPath.row == 4)
    {
    cell.textLabel.text = @"Twitter";
    cell.imageView.image = [UIImage imageNamed:@"talk-bubble.png"];

    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)logout{
    
    [currentStudent removePassword];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)launchAbout{
    AboutViewController *aboutView = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:aboutView animated:YES];
    [aboutView release];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0)
    {
        GradesController *grades = [[GradesController alloc]initWithStyle:UITableViewStyleGrouped];
        grades.studentUser = currentStudent;
        [self.navigationController pushViewController:grades animated:YES];
        [grades release];
    }
    if (indexPath.row == 1)
    {
        ScheduleViewer *schedule = [[ScheduleViewer alloc]initWithStyle:UITableViewStylePlain];
        schedule.myStudent = currentStudent;
        [self.navigationController pushViewController:schedule animated:YES];
       [schedule release];
    }
    else if (indexPath.row == 2)
    {
        MapView *map = [[MapView alloc]initWithNibName:@"MapView" bundle:nil];
        [self.navigationController pushViewController:map animated:YES];
        [map release];
    }
    else if (indexPath.row == 3)
    {
        if ([MFMailComposeViewController canSendMail]){
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc]init];
            mail.mailComposeDelegate = self;
            [mail setToRecipients:[NSArray arrayWithObject:@"sonny@sonstermedia.com"]];
            
            [self presentModalViewController:mail animated:YES];
            [mail release];
        }
        else{
            NSLog(@"Mail not setup on device");   
        }
    }
    else if (indexPath.row == 4){
        Web *web = [[Web alloc]initWithNibName:@"Web" bundle:nil];
        web.url = [NSURL URLWithString:@"http://twitter.com/WITLife"];
        [self presentModalViewController:web animated:YES]; 
        [web release];
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
    
}


@end
