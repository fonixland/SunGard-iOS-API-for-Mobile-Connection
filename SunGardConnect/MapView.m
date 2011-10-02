//
//  MapView.m
//  New 2 WIT
//
//  Created by Sonny on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapView.h"
#import "DisplayMap.h"


@implementation MapView
@synthesize campusMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [campusMap release];
    [super dealloc];
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
    self.title = @"Campus Map";
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 42.336237;
    coordinate.longitude = -71.095037;
    [campusMap setRegion:MKCoordinateRegionMake(coordinate,MKCoordinateSpanMake(0.001219, 0.002713))];
    [super viewDidLoad];

    
    CLLocationCoordinate2D coordinate0;
    coordinate0.latitude = 42.336537;
    coordinate0.longitude = -71.095537;
    
    DisplayMap *ann = [[DisplayMap alloc] init]; 
	ann.title = @"Rubenstein Hall";
	ann.coordinate = coordinate0; 
	[campusMap addAnnotation:ann];
    
    CLLocationCoordinate2D coordinate1;
    coordinate1.latitude = 42.336437;
    coordinate1.longitude = -71.095867;
    
    DisplayMap *ann1 = [[DisplayMap alloc] init]; 
	ann1.title = @"Kingman Hall";
	ann1.coordinate = coordinate1; 
	[campusMap addAnnotation:ann1];
    
    CLLocationCoordinate2D coordinate2;
    coordinate2.latitude = 42.336167;
    coordinate2.longitude = -71.095987;
    
    DisplayMap *ann2 = [[DisplayMap alloc] init]; 
	ann2.title = @"Willson Hall";
	ann2.coordinate = coordinate2; 
	[campusMap addAnnotation:ann2];
    
    CLLocationCoordinate2D coordinate3;
    coordinate3.latitude = 42.336867;
    coordinate3.longitude = -71.095287;
    
    DisplayMap *ann3 = [[DisplayMap alloc] init]; 
	ann3.title = @"Williston Hall";
	ann3.coordinate = coordinate3; 
	[campusMap addAnnotation:ann3];
    
    CLLocationCoordinate2D coordinate4;
    coordinate4.latitude = 42.336657;
    coordinate4.longitude = -71.095127;
    
    DisplayMap *ann4 = [[DisplayMap alloc] init]; 
	ann4.title = @"Wentworth Hall";
	ann4.coordinate = coordinate4; 
	[campusMap addAnnotation:ann4];
    
    
    CLLocationCoordinate2D coordinate5;
    coordinate5.latitude = 42.335257;
    coordinate5.longitude = -71.095127;
    
    DisplayMap *ann5 = [[DisplayMap alloc] init]; 
	ann5.title = @"Tansey Gym";
	ann5.coordinate = coordinate5; 
	[campusMap addAnnotation:ann5];
    
    
    CLLocationCoordinate2D coordinate6;
    coordinate6.latitude = 42.335557;
    coordinate6.longitude = -71.095527;
    
    DisplayMap *ann6 = [[DisplayMap alloc] init]; 
	ann6.title = @"Beatty Hall";
	ann6.coordinate = coordinate6; 
	[campusMap addAnnotation:ann6];
    
    
    CLLocationCoordinate2D coordinate7;
    coordinate7.latitude = 42.336657;
    coordinate7.longitude = -71.094507;
    
    DisplayMap *ann7 = [[DisplayMap alloc] init]; 
	ann7.title = @"Dobbs Hall";
	ann7.coordinate = coordinate7; 
	[campusMap addAnnotation:ann7];
    
    
    CLLocationCoordinate2D coordinate8;
    coordinate8.latitude = 42.336167;
    coordinate8.longitude = -71.094507;
    
    DisplayMap *ann8 = [[DisplayMap alloc] init]; 
	ann8.title = @"Watson Hall";
	ann8.coordinate = coordinate8; 
	[campusMap addAnnotation:ann8];
    
    
    CLLocationCoordinate2D coordinate9;
    coordinate9.latitude = 42.335647;
    coordinate9.longitude = -71.095617;
    
    DisplayMap *ann9 = [[DisplayMap alloc] init]; 
	ann9.title = @"DTS Help Desk";
	ann9.coordinate = coordinate9; 
	[campusMap addAnnotation:ann9];
    
    
    CLLocationCoordinate2D coordinate10;
    coordinate10.latitude = 42.335445;
    coordinate10.longitude = -71.094085;
    
    DisplayMap *ann10 = [[DisplayMap alloc] init]; 
	ann10.title = @"Annex Central";
	ann10.coordinate = coordinate10; 
	[campusMap addAnnotation:ann10];
   
    
    CLLocationCoordinate2D coordinate11;
    coordinate11.latitude = 42.336463;
    coordinate11.longitude = -71.097572;
    
    
    DisplayMap *ann11 = [[DisplayMap alloc] init]; 
	ann11.title = @"Office of Public Safety";
	ann11.coordinate = coordinate11; 
	[campusMap addAnnotation:ann11];
    
    
    CLLocationCoordinate2D coordinate12;
    coordinate12.latitude = 42.336299;
    coordinate12.longitude = -71.098389;
    
    
    DisplayMap *ann12 = [[DisplayMap alloc] init]; 
	ann12.title = @"Baker Hall";
	ann12.coordinate = coordinate12; 
	[campusMap addAnnotation:ann12];
    
    CLLocationCoordinate2D coordinate13;
    coordinate13.latitude = 42.335933;
    coordinate13.longitude = -71.097977;
    
    DisplayMap *ann13 = [[DisplayMap alloc] init]; 
	ann13.title = @"610 Dorm Hall";
	ann13.coordinate = coordinate13; 
	[campusMap addAnnotation:ann13];
    
    CLLocationCoordinate2D coordinate14;
    coordinate14.latitude = 42.336522;
    coordinate14.longitude = -71.096408;
    
    DisplayMap *ann14 = [[DisplayMap alloc] init]; 
	ann14.title = @"Visitor Parking";
	ann14.coordinate = coordinate14; 
	[campusMap addAnnotation:ann14];
    
    
    CLLocationCoordinate2D coordinate15;
    coordinate15.latitude = 42.337801;
    coordinate15.longitude = -71.093994;
    
    DisplayMap *ann15 = [[DisplayMap alloc] init]; 
	ann15.title = @"Sweeney Field";
	ann15.coordinate = coordinate15; 
	[campusMap addAnnotation:ann15];

    
    CLLocationCoordinate2D coordinate16;
    coordinate16.latitude = 42.337295;
    coordinate16.longitude = -71.097336;
    
    DisplayMap *ann16 = [[DisplayMap alloc] init]; 
	ann16.title = @"555 Housing";
	ann16.coordinate = coordinate16; 
	[campusMap addAnnotation:ann16];
    
    CLLocationCoordinate2D coordinate17;
    coordinate17.latitude = 42.337638;
    coordinate17.longitude = -71.097617;
    
    DisplayMap *ann17 = [[DisplayMap alloc] init]; 
	ann17.title = @"Evans Way";
	ann17.coordinate = coordinate17; 
	[campusMap addAnnotation:ann17];
    
    
    CLLocationCoordinate2D coordinate18;
    coordinate18.latitude = 42.337706;
    coordinate18.longitude = -71.09552;
    
    DisplayMap *ann18 = [[DisplayMap alloc] init]; 
	ann18.title = @"Green Line T-Stop";
	ann18.coordinate = coordinate18; 
	[campusMap addAnnotation:ann18];
    
    
    CLLocationCoordinate2D coordinate19;
    coordinate19.latitude = 42.336627;
    coordinate19.longitude = -71.09489;
    
    DisplayMap *ann19 = [[DisplayMap alloc] init]; 
	ann19.title = @"Admissions Office";
	ann19.coordinate = coordinate19; 
	[campusMap addAnnotation:ann19];
    
    
    CLLocationCoordinate2D coordinate20;
    coordinate20.latitude = 42.336195;
    coordinate20.longitude = -71.093868;
    
    DisplayMap *ann20 = [[DisplayMap alloc] init]; 
	ann20.title = @"Ira Allen Building";
	ann20.coordinate = coordinate20; 
	[campusMap addAnnotation:ann20];

    
    
    
    [ann release];
    [ann1 release];
    [ann2 release];
    [ann3 release];
    [ann4 release];
    [ann5 release];
    [ann6 release];
    [ann7 release];
    [ann8 release];
    [ann9 release];
    [ann10 release];
    [ann11 release];
    [ann12 release];
    [ann13 release];
    [ann14 release];
    [ann15 release];
    [ann16 release];
    [ann17 release];
    [ann18 release];
    [ann19 release];
    [ann20 release];
    // Do any additional setup after loading the view from its nib.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	MKPinAnnotationView *test=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingloc"]autorelease];
	if([annotation title]==@"Parked Location")
	{
		[test setPinColor:MKPinAnnotationColorPurple];
	}
	else
	{
		[test setPinColor:MKPinAnnotationColorGreen];
	}
	return test;
}


- (void)viewDidUnload
{
    [self setCampusMap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
