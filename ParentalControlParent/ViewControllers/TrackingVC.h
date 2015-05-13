//
//  TrackingVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/8/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Common.h"
#import "Define.h"
#import "UserDefault.h"

@interface TrackingVC : UIViewController<MKMapViewDelegate>
@property (nonatomic, strong) NSMutableArray *arrayLocationPins;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)actionListDevice:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;

@end
