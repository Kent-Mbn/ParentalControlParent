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

@interface HistorySelectDevicesVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblDevices;
- (IBAction)actionCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;

@end
