//
//  Alert.h
//  Q-municate
//
//  Created by Sandeep Kumar on 18/07/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Alert : NSObject

+(void)alertWithMessage:(NSString*)message navigation:(UINavigationController*)navigation gotoBack:(BOOL)goBack animation:(BOOL)animation;
+(void)alertWithMessage:(NSString*)message navigation:(UINavigationController*)navigation gotoBack:(BOOL)goBack animation:(BOOL)animation second:(int)second;

+(void)performBlockWithInterval:(double)interval completion:(void(^)(void))completion;

+(BOOL)validationName:(NSString *)checkString;

+(BOOL)validationEmail:(NSString *)checkString;

+ (BOOL)validateMobileNumber:(NSString*)number;

+ (BOOL)validateNumber:(NSString*)number;

+ (BOOL)validatePinCode:(NSString*)number;

+ (UIColor *)colorFromHexString:(NSString *)hexString ;


+(void)setProgessView:(UIView*)view strloading:(NSString*)strloading;
+(void)CloseProgress:(UIView*)ViewProg;


+(UIImage *)scaleAndRotateImage:(UIImage *)image;

+(BOOL)networkStatus;

+(NSString*)getFirstName:(NSString*)name;

+(NSDateFormatter*)getDateFormatWithString:(NSString*)string;

+(NSDate*)getDateWithDateString:(NSString*)dateString setFormat:(NSString*)format;

+(NSString*)getDateWithString:(NSString*)string getFormat:(NSString*)format1 setFormat:(NSString*)format2;

+ (int)calculateAge:(NSDate*)date;

+(NSDictionary*)getAllCountryNameWithCodeList;

+(NSDictionary*)getCountryFromServerData;

+(NSString*)getSelectedCountryKeyWithValue:(NSString*)value;

+(NSString*)getSelectedCountryValueWithKey:(NSString*)key;

+(NSArray*)getAllValuesFromDictionary:(NSDictionary*)data;

+(NSString*)getSelectedLanguageKeyWithValue:(NSString*)value data:(NSDictionary*)data;

+(NSArray*)getLanguageNamelist;

+(NSMutableArray *)removeViewControllFromNavArray:(int)number navigation:(UINavigationController*)class;

+(NSString*) bv_jsonStringWithDictionary:(NSDictionary*)dictionary;

+(NSString*)jsonStringWithDictionary:(NSDictionary*)data;

+(NSDictionary*)getDictionaryWithJsonString:(NSString*)string;

+(NSString*)getDeviceToken:(NSData*)deviceToken;

+(void)setBalanceLabel:(UINavigationItem*)nav;

+(UIViewController*)getNavRoot;

+(void)viewButtonCALayer:(UIColor *)yourColor viewButton:(UIButton *)yourButton;

+(void)viewButtonCALayerClear:(UIButton *)yourButton;

+(NSString*)getTableNameWithUsername:(NSString*)name;

+(void)setShadowOnView:(UIView*)view;

+(NSString*)getRandomStringWithLength:(int)length;

@end
