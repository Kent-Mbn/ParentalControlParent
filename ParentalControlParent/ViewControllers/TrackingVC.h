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
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UserDefault.h"
#import "APIService.h"
#import "HistorySelectDevicesCell.h"


@interface TrackingVC : UIViewController<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)actionListDevice:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong , nonatomic) NSMutableArray *arrayLocationPins;
@property (weak, nonatomic) IBOutlet UIView *viewTblView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
- (IBAction)actionHideViewTbl:(id)sender;

@end
