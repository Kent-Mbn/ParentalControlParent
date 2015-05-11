//
//  SettingsVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "SettingsCell.h"
#import "Common.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, TypeOfMap) {
    standanrd = 0,
    hybrid = 1,
    satellite = 2,
};

@interface SettingsVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    TypeOfMap typeOfMap;
}
@property (weak, nonatomic) IBOutlet UITableView *tblSettings;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;

@end
