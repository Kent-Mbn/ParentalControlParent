//
//  ChangeSafeAreaVC.h
//  ParentalControlParent
//
//  Created by CHAU HUYNH on 5/7/15.
//  Copyright (c) 2015 CHAU HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Define.h"
#import "Common.h"
#import "APIService.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "UserDefault.h"

typedef NS_ENUM(NSInteger, NSTypeOfSafeArea) {
    radiusShape = 0,
    polygonShape = 1,
};

@interface ChangeSafeAreaVC : UIViewController<MKMapViewDelegate> {
    NSTypeOfSafeArea typeSafeArea;
    int radiusCircle;
    CLLocationCoordinate2D centerPointCircle;
    int device_id;
    
}

@property(nonatomic) int device_id;

@property (nonatomic, strong) NSMutableArray *arrayForPolygon;
//Polyline
@property (nonatomic, strong) MKPolyline *polyLineFirst;
@property (nonatomic, strong) MKPolylineView *polylineViewFirst;
//Polygon
@property (nonatomic, strong) MKPolygon *polygon;
@property (nonatomic, strong) MKPolygonView *polygonView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *btRadiusType;
@property (weak, nonatomic) IBOutlet UIButton *btPolygonType;
@property (weak, nonatomic) IBOutlet UIView *viewSettingForRadius;
@property (weak, nonatomic) IBOutlet UILabel *lblRadius;
@property (weak, nonatomic) IBOutlet UIButton *btBackDraw;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGButtonChangeType;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;
@property (weak, nonatomic) IBOutlet UIView *viewBottombar;
@property (weak, nonatomic) IBOutlet UIButton *btPlus;
@property (weak, nonatomic) IBOutlet UIButton *btMinus;

//Timer press plus and minus
@property (nonatomic) NSTimer *timerPlus;
@property (nonatomic) NSTimer *timerMinus;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionDone:(id)sender;
- (IBAction)actionRadiusType:(id)sender;
- (IBAction)actionPolygonType:(id)sender;
- (IBAction)actionUpRadius:(id)sender;
- (IBAction)actionDownRadius:(id)sender;
- (IBAction)actionCancelDraw:(id)sender;
- (IBAction)actionBackDraw:(id)sender;


@end
