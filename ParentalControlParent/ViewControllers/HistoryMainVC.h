//
//  HistoryMainVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AbstractActionSheetPicker.h"
#import "ActionSheetDatePicker.h"
#import "Define.h"
#import "UserDefault.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UserDefault.h"
#import "APIService.h"
#import "Common.h"

@interface HistoryMainVC : UIViewController<MKMapViewDelegate>
@property (nonatomic, strong) AbstractActionSheetPicker *actionDatePicker;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) MKPolylineView *polylineView;

- (IBAction)actionSelectDevice:(id)sender;
- (IBAction)actionSelectDate:(id)sender;

@end
