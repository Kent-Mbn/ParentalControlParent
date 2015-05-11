//
//  HistorySelectDevicesVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "HistorySelectDevicesVC.h"

@interface HistorySelectDevicesVC ()

@end

@implementation HistorySelectDevicesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewTopbar.backgroundColor = masterColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TABLE DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistorySelectDevicesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historySelectDevicesCellId" forIndexPath:indexPath];
    cell.lblName.text = @"Huynh Phong Chau";
    cell.lblEmail.text = @"hpc@gmail.com";
    cell.lblPhoneNumber.text = @"0905656565";
    
    return cell;
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
