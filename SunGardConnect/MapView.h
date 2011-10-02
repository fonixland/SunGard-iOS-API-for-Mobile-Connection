//
//  MapView.h
//  New 2 WIT
//
//  Created by Sonny on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>

@interface MapView : UIViewController <MKMapViewDelegate> {
    
    MKMapView *campusMap;
}
@property (nonatomic, retain) IBOutlet MKMapView *campusMap;

@end
