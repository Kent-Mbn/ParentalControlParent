//
//  ChildsAllDeviceVC.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "ChildsAllDeviceVC.h"

@interface ChildsAllDeviceVC ()

@end

@implementation ChildsAllDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewTopbar.backgroundColor = masterColor;
    
    //Hide navigation bar
    [self.navigationController setNavigationBarHidden:YES];
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

#pragma mark - ACTION
- (IBAction)actionAddNewDevice:(id)sender {
    
}

- (void) goToChangeSafeArea:(id)sender {
    [self performSegueWithIdentifier:@"segueToChangeSafeArea" sender:nil];
}

#pragma mark - TABLEVIEW DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChildsAllDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildsAllDeviceCellId" forIndexPath:indexPath];
    cell.lblName.text = @"Huynh Phong Chau";
    cell.lblEmail.text = @"huynhphongchau@gmail.com";
    cell.lblPhoneNumber.text = @"090565656475";
    [cell.btSetArea addTarget:self action:@selector(goToChangeSafeArea:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueToEditDevice" sender:nil];
}

@end
