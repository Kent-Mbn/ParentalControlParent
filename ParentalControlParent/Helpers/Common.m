//
//  Common.m
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import "Common.h"

@implementation Common

+(void)roundView:(UIView *)uView andRadius:(float) radius {
    uView.layer.cornerRadius = radius;
}
+ (void) showAlertView:(NSString *)title message:(NSString *)message delegate:(UIViewController *)delegate cancelButtonTitle:(NSString *)cancelButtonTitle arrayTitleOtherButtons:(NSArray *)arrayTitleOtherButtons tag:(int)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    alert.tag = tag;
    
    if([arrayTitleOtherButtons count] > 0) {
        for (int i = 0; i < [arrayTitleOtherButtons count]; i++) {
            [alert addButtonWithTitle:arrayTitleOtherButtons[i]];
        }
    }
    
    [alert show];
}
+ (CLLocationCoordinate2D) get2DCoordFromString:(NSString*)coordString
{
    CLLocationCoordinate2D location;
    NSArray *coordArray = [coordString componentsSeparatedByString: @","];
    location.latitude = ((NSNumber *)coordArray[0]).doubleValue;
    location.longitude = ((NSNumber *)coordArray[1]).doubleValue;
    
    return location;
}

+ (void) updateDeviceToken:(NSString *) newDeviceToken {
    [[NSUserDefaults standardUserDefaults] setObject:newDeviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) getDeviceToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceToken"];
}

+ (BOOL) isValidEmail:(NSString *)checkString
{
    checkString = [checkString lowercaseString];
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

+ (void) showLoadingViewGlobal:(NSString *) titleaLoading {
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    if (titleaLoading != nil) {
        [SVProgressHUD showWithStatus:titleaLoading maskType:SVProgressHUDMaskTypeGradient];
    } else {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
}

+ (void) showNetworkActivityIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void) hideNetworkActivityIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

+ (void) hideLoadingViewGlobal {
    [SVProgressHUD dismiss];
}

+ (AFHTTPRequestOperationManager *)AFHTTPRequestOperationManagerReturn {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager.requestSerializer setTimeoutInterval:30];
    return manager;
}

+ (BOOL) validateRespone:(id) respone {
    NSArray *arrRespone = (NSArray *)respone;
    NSDictionary *dicRespone = (NSDictionary *)[arrRespone objectAtIndex:0];
    if (dicRespone) {
        if ([dicRespone[@"resultcode"] intValue] == CODE_RESPONE_SUCCESS) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *) returnStringArrayLat:(NSMutableArray *) arrData {
    NSString *strReturn = @"";
    if ([arrData count] > 0) {
        for (int i = 0; i < [arrData count]; i++) {
            CLLocation *objLocation = [arrData objectAtIndex:i];
            if (i == [arrData count] - 1) {
                strReturn = [NSString stringWithFormat:@"%@%@", strReturn, [NSString stringWithFormat:@"%@", @(objLocation.coordinate.latitude)]];
            } else {
                strReturn = [NSString stringWithFormat:@"%@%@", strReturn, [NSString stringWithFormat:@"%@;", @(objLocation.coordinate.latitude)]];
            }
        }
    }
    return strReturn;
}

+ (NSString *) returnStringArrayLong:(NSMutableArray *) arrData {
    NSString *strReturn = @"";
    if ([arrData count] > 0) {
        for (int i = 0; i < [arrData count]; i++) {
            CLLocation *objLocation = [arrData objectAtIndex:i];
            if (i == [arrData count] - 1) {
                strReturn = [NSString stringWithFormat:@"%@%@", strReturn, [NSString stringWithFormat:@"%@", @(objLocation.coordinate.longitude)]];
            } else {
                strReturn = [NSString stringWithFormat:@"%@%@", strReturn, [NSString stringWithFormat:@"%@;", @(objLocation.coordinate.longitude)]];
            }
        }
    }
    return strReturn;
}

+ (float) calDistanceTwoCoordinate:(CLLocationCoordinate2D)firstPoint andSecondPoint:(CLLocationCoordinate2D)secondPoint {
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:firstPoint.latitude longitude:firstPoint.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:secondPoint.latitude longitude:secondPoint.longitude];
    CLLocationDistance dist = [userloc distanceFromLocation:dest];
    return (float)dist;
}

+ (void) setMapTypeGlobal:(MKMapView *)mapView {
    NSString *strMaptype = [UserDefault user].type_map;
    if (strMaptype.length > 0) {
        if ([strMaptype isEqualToString:@"standanrd"]) {
            mapView.mapType = MKMapTypeStandard;
        }
        if ([strMaptype isEqualToString:@"hybrid"]) {
            mapView.mapType = MKMapTypeHybrid;
        }
        if ([strMaptype isEqualToString:@"satellite"]) {
            mapView.mapType = MKMapTypeSatellite;
        }
    }
}

+ (BOOL) isValidString:(NSString *) strCheck {
    if (strCheck.length > 0 && ![strCheck isEqual:[NSNull null]] && ![strCheck isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

+ (BOOL) isValidCoordinate:(CLLocationCoordinate2D) checkPoint {
    if (checkPoint.latitude != 0 && checkPoint.longitude != 0 && CLLocationCoordinate2DIsValid(checkPoint)) {
        return YES;
    }
    return NO;
}

+ (void) getAddressFromGoogleApi:(double)numLat andLong:(double)numLong completion:(void(^)(NSString *strAddress))completBlock {
    [Common showNetworkActivityIndicator];
    AFHTTPRequestOperationManager *manager = [Common AFHTTPRequestOperationManagerReturn];
    NSString *strLat = [NSString stringWithFormat:@"%f", numLat];
    NSString *strLong = [NSString stringWithFormat:@"%f", numLong];
    __block NSString *strAddress = @"";
    NSMutableDictionary *request_param = [@{
                                            
                                            } mutableCopy];
    NSLog(@"GET ADDRESS FROM GOOGLE: %@ %@", request_param, API_ADDRESS_GOOGLE(strLat, strLong, GOOGLE_API_KEY));
    [manager GET:API_ADDRESS_GOOGLE(strLat, strLong, GOOGLE_API_KEY) parameters:request_param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Common hideNetworkActivityIndicator];
        NSLog(@"GET ADDRESS FROM GOOGLE RESPONE: %@", responseObject);
        
        //Parse data address
        NSArray *arrResult = responseObject[@"results"];
        if ([arrResult count] > 0) {
            NSDictionary *address_components = [arrResult objectAtIndex:0];
            NSArray *arrAddress = address_components[@"address_components"];
            if ([arrAddress count] > 0) {
                //Get street number
                NSDictionary *dicStreetNum = [arrAddress objectAtIndex:0];
                strAddress = [NSString stringWithFormat:@"%@%@", strAddress, dicStreetNum[@"long_name"]];
                
                //Get street name
                NSDictionary *dicStreetName = [arrAddress objectAtIndex:1];
                strAddress = [NSString stringWithFormat:@"%@ %@", strAddress, dicStreetName[@"long_name"]];
                
            }
        }
        completBlock(strAddress);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Common hideNetworkActivityIndicator];
        completBlock(strAddress);
    }];
}

#pragma mark - Algorthim calculate area of polygon and circle
+ (double) areaOfTriangle:(CLLocationCoordinate2D)firstPoint andSecondPoint:(CLLocationCoordinate2D)secondPoint andThirdPoint:(CLLocationCoordinate2D)thirdPoint {
    double areaReturn = 0.0f;
    
    /* Herong: S=sqrt(p(p-a)(p-b)(p-c)) */
    double a = [self calDistanceTwoCoordinate:firstPoint andSecondPoint:secondPoint];
    double b = [self calDistanceTwoCoordinate:secondPoint andSecondPoint:thirdPoint];
    double c = [self calDistanceTwoCoordinate:firstPoint andSecondPoint:thirdPoint];
    
    // 1/2 perimeter
    double p = (a + b + c)/2;
    
    //Cal area
    areaReturn = sqrtf(p * (p - a) * (p - b) * (p - c));
    
    return areaReturn;
}

+ (double) areaOfPolygon:(NSMutableArray *) arrPoints {
    double areaReturn = 0.0f;
    
    // Area is summury all of area of triangle
    int count = [arrPoints count] - 2;
    if (count >= 1) {
        for (int i = 0; i < count; i++) {
            CLLocation *firstPoint = [arrPoints objectAtIndex:0];
            CLLocation *secondPoint = [arrPoints objectAtIndex:(i+1)];
            CLLocation *thirdPoint = [arrPoints objectAtIndex:(i+2)];
            
            areaReturn += [self areaOfTriangle:firstPoint.coordinate andSecondPoint:secondPoint.coordinate andThirdPoint:thirdPoint.coordinate];
        }
    }
    
    return areaReturn;
}

#pragma mark - Algorthim checking polygon safe area
+ (BOOL) checkTwoPointsSideWithSegment:(CLLocationCoordinate2D) pointA1 : (CLLocationCoordinate2D)pointB1 :(CLLocationCoordinate2D)pointA2 :(CLLocationCoordinate2D)pointB2 {
    
    //A2 and B2 -> SEGMENT
    
    //SEGMENT: f(x,y) = (x-x1)/(x2-x1) = (y-y1)/(y2-y1)
    //A2(a1,b1) and B2(a2,b2) f(A2)*f(B2) < 0
    
    //SEGMENT POINTS
    //A2
    double x1 = pointA2.latitude;
    double y1 = pointA2.longitude;
    
    //B2
    double x2 = pointB2.latitude;
    double y2 = pointB2.longitude;
    
    //POINTS CHECKING
    //A1
    double xc1 = pointA1.latitude;
    double yc1 = pointA1.longitude;
    
    //B2
    double xc2 = pointB1.latitude;
    double yc2 = pointB1.longitude;
    
    //f(A2)
    double fA2 = ((x2 - x1) * (yc1 - y1)) - ((y2 - y1) * (xc1 - x1));
    
    //f(B2)
    double fB2 = ((x2 - x1) * (yc2 - y1)) - ((y2 - y1) * (xc2 - x1));
    
    if (fA2 * fB2 < 0) {
        return YES;
    }
    return NO;
}

+ (BOOL) checkPolygonSafeArea:(NSMutableArray *) arrayPoints {
    if ([arrayPoints count] > 2) {
        
        CLLocationCoordinate2D pointBegin;
        CLLocationCoordinate2D pointNextLast;
        CLLocationCoordinate2D pointNew;
        NSMutableArray *arrMediumPoints = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [arrayPoints count]; i++) {
            CLLocation *point = [arrayPoints objectAtIndex:i];
            NSLog(@"POINT: %f and %f", point.coordinate.latitude, point.coordinate.longitude);
            if (i == 0) {
                //Get point Begin
                pointBegin = point.coordinate;
                continue;
            } else if (i == [arrayPoints count] - 2) {
                //Get point Next Last
                pointNextLast = point.coordinate;
                continue;
            } else if (i == [arrayPoints count] - 1) {
                //Get point Last
                pointNew = point.coordinate;
                continue;
            } else {
                //Get point medium
                [arrMediumPoints addObject:point];
            }
        }
        
        //CHECKING BEGIN....
        for (int i = 0; i < [arrMediumPoints count]; i++) {
            CLLocation *point = [arrMediumPoints objectAtIndex:i];
            if (!([self checkTwoPointsSideWithSegment:point.coordinate :pointNew :pointBegin :pointNextLast] && [self checkTwoPointsSideWithSegment:pointBegin :pointNextLast :point.coordinate :pointNew])) {
                return NO;
            }
        }
    }
    
    return YES;
}



@end
