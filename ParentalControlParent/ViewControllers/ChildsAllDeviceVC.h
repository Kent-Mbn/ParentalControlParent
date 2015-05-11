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

@interface ChildsAllDeviceVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewTopbar;
- (IBAction)actionAddNewDevice:(id)sender;
@end
