//
//  HistorySelectDevicesVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistorySelectDevicesCell.h"
#import "Define.h"
#import "Common.h"
#import "APIService.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UserDefault.h"


@interface HistorySelectDevicesVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblDevices;
- (IBAction)actionCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;
@property (nonatomic, strong) NSMutableArray *arrayData;

@end
