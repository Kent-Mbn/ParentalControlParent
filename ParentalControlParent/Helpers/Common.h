//
//  Common.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/6/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "Define.h"
#import "UserDefault.h"
#import "APIService.h"

@interface Common : NSObject

+(void)roundView:(UIView *) uView andRadius:(float) radius;
+(void) showAlertView:(NSString *)title message:(NSString *)message delegate:(UIViewController *)delegate cancelButtonTitle:(NSString *)cancelButtonTitle arrayTitleOtherButtons:(NSArray *)arrayTitleOtherButtons tag:(int)tag;
+ (CLLocationCoordinate2D) get2DCoordFromString:(NSString*)coordString;
+ (void) updateDeviceToken:(NSString *) newDeviceToken;
+ (NSString *) getDeviceToken;
+ (BOOL) isValidEmail:(NSString *)checkString;

+ (void) showNetworkActivityIndicator;
+ (void) hideNetworkActivityIndicator;
+ (void) showLoadingViewGlobal:(NSString *) titleaLoading;
+ (void) hideLoadingViewGlobal;

+ (AFHTTPRequestOperationManager *)AFHTTPRequestOperationManagerReturn;
+ (BOOL) validateRespone:(id) respone;

+ (NSString *) returnStringArrayLat:(NSMutableArray *) arrData;
+ (NSString *) returnStringArrayLong:(NSMutableArray *) arrData;
+ (float) calDistanceTwoCoordinate:(CLLocationCoordinate2D)firstPoint andSecondPoint:(CLLocationCoordinate2D)secondPoint;
+ (void) setMapTypeGlobal:(MKMapView *)mapView;

+ (BOOL) isValidString:(NSString *) strCheck;
+ (BOOL) isValidCoordinate:(CLLocationCoordinate2D) checkPoint;

+ (void) getAddressFromGoogleApi:(double)numLat andLong:(double)numLong completion:(void(^)(NSString *strAddress))completBlock;

#pragma mark - Algorthim calculate area of polygon and circle
+ (double) areaOfTriangle:(CLLocationCoordinate2D)firstPoint andSecondPoint:(CLLocationCoordinate2D)secondPoint andThirdPoint:(CLLocationCoordinate2D)thirdPoint;
+ (double) areaOfPolygon:(NSMutableArray *) arrPoints;

#pragma mark - Algorthim checking polygon safe area
+ (BOOL) checkTwoPointsSideWithSegment:(CLLocationCoordinate2D) pointA1 : (CLLocationCoordinate2D)pointB1 :(CLLocationCoordinate2D)pointA2 :(CLLocationCoordinate2D)pointB2;
+ (BOOL) checkPolygonSafeArea:(NSMutableArray *) arrayPoints;

@end
