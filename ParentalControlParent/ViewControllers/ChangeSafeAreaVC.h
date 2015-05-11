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

typedef NS_ENUM(NSInteger, NSTypeOfSafeArea) {
    radiusShape = 0,
    polygonShape = 1,
};

@interface ChangeSafeAreaVC : UIViewController<MKMapViewDelegate> {
    NSTypeOfSafeArea typeSafeArea;
    int radius;
}

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
@property (weak, nonatomic) IBOutlet UIButton *actionBackDraw;
@property (weak, nonatomic) IBOutlet UIButton *btBackDraw;
@property (weak, nonatomic) IBOutlet UIImageView *imgBGButtonChangeType;
@property (weak, nonatomic) IBOutlet UIView *viewTopbar;
@property (weak, nonatomic) IBOutlet UIView *viewBottombar;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionDone:(id)sender;
- (IBAction)actionRadiusType:(id)sender;
- (IBAction)actionPolygonType:(id)sender;
- (IBAction)actionUpRadius:(id)sender;
- (IBAction)actionDownRadius:(id)sender;
- (IBAction)actionCancelDraw:(id)sender;


@end
