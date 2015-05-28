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
#import "HistorySelectDevicesCell.h"
#import "AppDelegate.h"

@interface HistoryMainVC : UIViewController<MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AbstractActionSheetPicker *actionDatePicker;
@property (nonatomic, strong) NSString *strCurrentTime;
@property (nonatomic, strong) NSString *strIdChild;

@property (weak, nonatomic) IBOutlet UIView *viewTopbar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) MKPolyline *polyline;
@property (nonatomic, strong) MKPolylineView *polylineView;

@property (weak, nonatomic) IBOutlet UIView *viewTblView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) NSMutableArray *arrData;

- (IBAction)actionHideViewTbl:(id)sender;

- (IBAction)actionSelectDevice:(id)sender;
- (IBAction)actionSelectDate:(id)sender;

@end
