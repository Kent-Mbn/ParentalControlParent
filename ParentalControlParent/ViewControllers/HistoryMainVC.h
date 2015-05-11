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

@interface HistoryMainVC : UIViewController
@property (nonatomic, strong) AbstractActionSheetPicker *actionDatePicker;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;

- (IBAction)actionSelectDevice:(id)sender;
- (IBAction)actionSelectDate:(id)sender;

@end
