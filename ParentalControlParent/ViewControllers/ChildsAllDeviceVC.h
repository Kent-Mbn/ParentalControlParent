//
//  ChildsAllDeviceVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildsAllDeviceCell.h"
#import "Define.h"
#import "Common.h"
#import "APIService.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UserDefault.h"
#import "DeviceObj.h"

@interface ChildsAllDeviceVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (weak, nonatomic) IBOutlet UIView *viewTopbar;
@property (nonatomic, strong) NSMutableArray *arrayData;
- (IBAction)actionAddNewDevice:(id)sender;
@end
