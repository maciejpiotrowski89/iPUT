//
//  CABeaconConstants.h
//  ADMDConfApp
//
//  Created by Piotrowski, Maciej {FPSA~Poznan} on 22/07/14.
//  Copyright (c) 2014 roche. All rights reserved.
//
#import <EstimoteSDK/ESTBeaconManager.h>

#define kContextNumbersProximityUUID @"UUID"
#define kContextNumbersMajor @"Major"
#define kContextNumbersMinor @"Minor"

#define kEstimoteUUID ESTIMOTE_PROXIMITY_UUID
#define kBeaconADMDUUID [[NSUUID alloc]initWithUUIDString:@"555097F4-B465-4BCC-9553-C8D57CFCBD2F"]

#define kBeaconPlaceMajorNumber 512
#define kBeaconPersonMajorNumber 4096

#define kBeaconRegistrationMinorNumber 0

#define kRegistrationBeaconRegion [[CLBeaconRegion alloc]initWithProximityUUID:kBeaconADMDUUID major:kBeaconPlaceMajorNumber minor:kBeaconRegistrationMinorNumber identifier:@"REGISTRATION BEACON"]
#define kPersonBeaconRegion [[CLBeaconRegion alloc]initWithProximityUUID:kBeaconADMDUUID major:kBeaconPersonMajorNumber identifier:@"PERSON BEACON"]
#define kSD1BeaconRegion [[CLBeaconRegion alloc]initWithProximityUUID:kBeaconADMDUUID major:kBeaconPlaceMajorNumber minor:1 identifier:@"Speed Dating 1 BEACON"]
#define kSD2BeaconRegion [[CLBeaconRegion alloc]initWithProximityUUID:kBeaconADMDUUID major:kBeaconPlaceMajorNumber minor:2 identifier:@"Speed Dating 2 BEACON"]
#define kSD3BeaconRegion [[CLBeaconRegion alloc]initWithProximityUUID:kBeaconADMDUUID major:kBeaconPlaceMajorNumber minor:3 identifier:@"Speed Dating 3 BEACON"]
#define kSD4BeaconRegion [[CLBeaconRegion alloc]initWithProximityUUID:kBeaconADMDUUID major:kBeaconPlaceMajorNumber minor:4 identifier:@"Speed Dating 4 BEACON"]
#define kSD5BeaconRegion [[CLBeaconRegion alloc]initWithProximityUUID:kBeaconADMDUUID major:kBeaconPlaceMajorNumber minor:5 identifier:@"Speed Dating 5 BEACON"]
#define kSD6BeaconRegion [[CLBeaconRegion alloc]initWithProximityUUID:kBeaconADMDUUID major:kBeaconPlaceMajorNumber minor:6 identifier:@"Speed Dating 6 BEACON"]
#define kSD7BeaconRegion [[CLBeaconRegion alloc]initWithProximityUUID:kBeaconADMDUUID major:kBeaconPlaceMajorNumber minor:7 identifier:@"Speed Dating 7 BEACON"]
#define kSD8BeaconRegion [[CLBeaconRegion alloc]initWithProximityUUID:kBeaconADMDUUID major:kBeaconPlaceMajorNumber minor:8 identifier:@"Speed Dating 8 BEACON"]

