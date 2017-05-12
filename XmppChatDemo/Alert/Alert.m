//
//  Alert.m
//  Q-municate
//
//  Created by Sandeep Kumar on 18/07/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "Alert.h"
#import "Reachability.h"
#import <UIKit/UIKit.h>

#define BALANCE_DEBUG   0

@implementation Alert


+(void)alertWithMessage:(NSString*)message navigation:(UINavigationController*)navigation gotoBack:(BOOL)goBack animation:(BOOL)animation{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles: nil];
    
    [myAlertView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [myAlertView dismissWithClickedButtonIndex:0 animated:animation];
        goBack ? [navigation popViewControllerAnimated:YES]  :nil;
    });
}

+(void)alertWithMessage:(NSString*)message navigation:(UINavigationController*)navigation gotoBack:(BOOL)goBack animation:(BOOL)animation second:(int)second{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles: nil];
    
    [myAlertView show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [myAlertView dismissWithClickedButtonIndex:0 animated:animation];
        goBack ? [navigation popViewControllerAnimated:YES]  :nil;
    });
}

+(void)performBlockWithInterval:(double)interval completion:(void(^)(void))completion{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion();
        
    });
}


+(BOOL)validationName:(NSString *)checkString{
    
    NSString *_username = checkString;
    
    NSCharacterSet * characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString: _username];
    if([[NSCharacterSet alphanumericCharacterSet] isSupersetOfSet: characterSetFromTextField] == NO)
    {
        //NSLog( @"there are bogus characters here, throw up a UIAlert at this point");
        return NO;
    }
    return YES;

   
}

/*
+(BOOL)validationEmail:(NSString *)checkString{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
 
 */

+ (BOOL)validationEmail:(NSString *)checkString {
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:checkString]) {
        aRange = [checkString rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [checkString length])];
        int indexOfDot = (int)aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [checkString substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:
                   @".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }
    return FALSE;
}

+ (BOOL)validateMobileNumber:(NSString*)number{
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}

+ (BOOL)validatePinCode:(NSString*)number{
    NSString *numberRegEx = @"[0-9]{6}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}

+ (BOOL)validateNumber:(NSString*)number{
    NSScanner *scanner = [NSScanner scannerWithString:number];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    return isNumeric;
}

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(void)setProgessView:(UIView*)view strloading:(NSString*)strloading{
    UIImageView * BilizTikLogo = [[UIImageView alloc]init];
    BilizTikLogo.frame = CGRectMake(0, 0, 200, 80);
    BilizTikLogo.image = [UIImage imageNamed:@"logo.png"];
    
    BilizTikLogo.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    
    UIActivityIndicatorView *indicatorView=[[UIActivityIndicatorView alloc] init];
    indicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    [indicatorView startAnimating];
    indicatorView.frame=CGRectMake(0,0, 40, 40);
    indicatorView.backgroundColor = [UIColor clearColor];
    indicatorView.color = [UIColor whiteColor];
    indicatorView.autoresizesSubviews = YES;
    indicatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    
    
    UILabel *lbl=[[UILabel alloc]init];
    lbl.frame=CGRectMake(0,indicatorView.frame.origin.y-indicatorView.frame.size.height, view.frame.size.width, 50);
    lbl.backgroundColor=[UIColor clearColor];
    lbl.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleRightMargin |
                            UIViewAutoresizingFlexibleTopMargin |
                            UIViewAutoresizingFlexibleBottomMargin);
    //    }
    [lbl setText:strloading];
    lbl.textColor=[UIColor whiteColor];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.font=[UIFont fontWithName:@"MyriadPro-Regular" size:20.0f];
      lbl.autoresizesSubviews = YES;
        lbl.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                UIViewAutoresizingFlexibleRightMargin |
                                UIViewAutoresizingFlexibleTopMargin |
                                UIViewAutoresizingFlexibleBottomMargin);
    
    
    UIView *v=[[UIView alloc] init];
    v.frame=view.bounds;
    v.tag=-1000;
    //v.backgroundColor=[UIColor clearColor];
    v.backgroundColor=[UIColor colorWithRed:83/255.0f green:86/255.0f blue:104/255.0f alpha:1];
    v.autoresizesSubviews = YES;
    v.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    indicatorView.center = v.center;
    
    lbl.center = CGPointMake(v.center.x, v.center.y+60);// v.center;
    BilizTikLogo.center = CGPointMake(v.center.x, v.center.y -200);
    
    [v addSubview:BilizTikLogo];
    [v addSubview:indicatorView];
    [v addSubview:lbl];
    [view bringSubviewToFront:v];
    [view addSubview:v];
    
}


+(void)CloseProgress:(UIView*)ViewProg{
    for (UIView *view in [ViewProg subviews] )
    {
        if (view.tag==-1000)
        {
            [view removeFromSuperview];
        }
    }
}



#pragma mark image Scaling
+(UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 375; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

#pragma mark  reachability .......
+(BOOL)networkStatus{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    return networkStatus;
}


+(NSString*)getFirstName:(NSString*)name{
    
    NSString *firstWord = [[name componentsSeparatedByString:@" "] objectAtIndex:0];
    return firstWord;
}

+(NSDateFormatter*)getDateFormatWithString:(NSString*)string{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:string];
    return df;
    
}

+(NSDate*)getDateWithDateString:(NSString*)dateString setFormat:(NSString*)format{
    
    NSDate* date= [[self getDateFormatWithString:format] dateFromString:dateString];
    return date;
}

+(NSString*)getDateWithString:(NSString*)string getFormat:(NSString*)format1 setFormat:(NSString*)format2{
    
    NSDate* date= [[self getDateFormatWithString:format1] dateFromString:string];
    NSString *dateString = [[self getDateFormatWithString:format2] stringFromDate:date];
    
    return dateString;
    
}

+ (int)calculateAge:(NSDate*)date{
        
        NSInteger age;
        
        if(date){
                NSDate* now = [NSDate date];
                NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                   components:NSCalendarUnitYear
                                                   fromDate:date
                                                   toDate:now
                                                   options:0];
                age = [ageComponents year];
        }
        else age=0;
        
        return  (int)age;
}

+(NSDictionary*)getAllCountryNameWithCodeList{
    // Country code
    NSDictionary *codes = @{
                            @"Canada"                                       : @"+1",
                            @"China"                                        : @"+86",
                            @"France"                                       : @"+33",
                            @"Germany"                                      : @"+49",
                            @"India"                                        : @"+91",
                            @"Japan"                                        : @"+81",
                            @"Pakistan"                                     : @"+92",
                            @"United Kingdom"                               : @"+44",
                            @"United States"                                : @"+1",
                            @"Abkhazia"                                     : @"+7 840",
                            @"Abkhazia"                                     : @"+7 940",
                            @"Afghanistan"                                  : @"+93",
                            @"Albania"                                      : @"+355",
                            @"Algeria"                                      : @"+213",
                            @"American Samoa"                               : @"+1 684",
                            @"Andorra"                                      : @"+376",
                            @"Angola"                                       : @"+244",
                            @"Anguilla"                                     : @"+1 264",
                            @"Antigua and Barbuda"                          : @"+1 268",
                            @"Argentina"                                    : @"+54",
                            @"Armenia"                                      : @"+374",
                            @"Aruba"                                        : @"+297",
                            @"Ascension"                                    : @"+247",
                            @"Australia"                                    : @"+61",
                            @"Australian External Territories"              : @"+672",
                            @"Austria"                                      : @"+43",
                            @"Azerbaijan"                                   : @"+994",
                            @"Bahamas"                                      : @"+1 242",
                            @"Bahrain"                                      : @"+973",
                            @"Bangladesh"                                   : @"+880",
                            @"Barbados"                                     : @"+1 246",
                            @"Barbuda"                                      : @"+1 268",
                            @"Belarus"                                      : @"+375",
                            @"Belgium"                                      : @"+32",
                            @"Belize"                                       : @"+501",
                            @"Benin"                                        : @"+229",
                            @"Bermuda"                                      : @"+1 441",
                            @"Bhutan"                                       : @"+975",
                            @"Bolivia"                                      : @"+591",
                            @"Bosnia and Herzegovina"                       : @"+387",
                            @"Botswana"                                     : @"+267",
                            @"Brazil"                                       : @"+55",
                            @"British Indian Ocean Territory"               : @"+246",
                            @"British Virgin Islands"                       : @"+1 284",
                            @"Brunei"                                       : @"+673",
                            @"Bulgaria"                                     : @"+359",
                            @"Burkina Faso"                                 : @"+226",
                            @"Burundi"                                      : @"+257",
                            @"Cambodia"                                     : @"+855",
                            @"Cameroon"                                     : @"+237",
                            @"Canada"                                       : @"+1",
                            @"Cape Verde"                                   : @"+238",
                            @"Cayman Islands"                               : @"+ 345",
                            @"Central African Republic"                     : @"+236",
                            @"Chad"                                         : @"+235",
                            @"Chile"                                        : @"+56",
                            @"China"                                        : @"+86",
                            @"Christmas Island"                             : @"+61",
                            @"Cocos-Keeling Islands"                        : @"+61",
                            @"Colombia"                                     : @"+57",
                            @"Comoros"                                      : @"+269",
                            @"Congo"                                        : @"+242",
                            @"Congo, Dem. Rep. of (Zaire)"                  : @"+243",
                            @"Cook Islands"                                 : @"+682",
                            @"Costa Rica"                                   : @"+506",
                            @"Ivory Coast"                                  : @"+225",
                            @"Croatia"                                      : @"+385",
                            @"Cuba"                                         : @"+53",
                            @"Curacao"                                      : @"+599",
                            @"Cyprus"                                       : @"+537",
                            @"Czech Republic"                               : @"+420",
                            @"Denmark"                                      : @"+45",
                            @"Diego Garcia"                                 : @"+246",
                            @"Djibouti"                                     : @"+253",
                            @"Dominica"                                     : @"+1 767",
                            @"Dominican Republic"                           : @"+1 809",
                            @"Dominican Republic"                           : @"+1 829",
                            @"Dominican Republic"                           : @"+1 849",
                            @"East Timor"                                   : @"+670",
                            @"Easter Island"                                : @"+56",
                            @"Ecuador"                                      : @"+593",
                            @"Egypt"                                        : @"+20",
                            @"El Salvador"                                  : @"+503",
                            @"Equatorial Guinea"                            : @"+240",
                            @"Eritrea"                                      : @"+291",
                            @"Estonia"                                      : @"+372",
                            @"Ethiopia"                                     : @"+251",
                            @"Falkland Islands"                             : @"+500",
                            @"Faroe Islands"                                : @"+298",
                            @"Fiji"                                         : @"+679",
                            @"Finland"                                      : @"+358",
                            @"France"                                       : @"+33",
                            @"French Antilles"                              : @"+596",
                            @"French Guiana"                                : @"+594",
                            @"French Polynesia"                             : @"+689",
                            @"Gabon"                                        : @"+241",
                            @"Gambia"                                       : @"+220",
                            @"Georgia"                                      : @"+995",
                            @"Germany"                                      : @"+49",
                            @"Ghana"                                        : @"+233",
                            @"Gibraltar"                                    : @"+350",
                            @"Greece"                                       : @"+30",
                            @"Greenland"                                    : @"+299",
                            @"Grenada"                                      : @"+1 473",
                            @"Guadeloupe"                                   : @"+590",
                            @"Guam"                                         : @"+1 671",
                            @"Guatemala"                                    : @"+502",
                            @"Guinea"                                       : @"+224",
                            @"Guinea-Bissau"                                : @"+245",
                            @"Guyana"                                       : @"+595",
                            @"Haiti"                                        : @"+509",
                            @"Honduras"                                     : @"+504",
                            @"Hong Kong SAR China"                          : @"+852",
                            @"Hungary"                                      : @"+36",
                            @"Iceland"                                      : @"+354",
                            @"India"                                        : @"+91",
                            @"Indonesia"                                    : @"+62",
                            @"Iran"                                         : @"+98",
                            @"Iraq"                                         : @"+964",
                            @"Ireland"                                      : @"+353",
                            @"Israel"                                       : @"+972",
                            @"Italy"                                        : @"+39",
                            @"Jamaica"                                      : @"+1 876",
                            @"Japan"                                        : @"+81",
                            @"Jordan"                                       : @"+962",
                            @"Kazakhstan"                                   : @"+7 7",
                            @"Kenya"                                        : @"+254",
                            @"Kiribati"                                     : @"+686",
                            @"North Korea"                                  : @"+850",
                            @"South Korea"                                  : @"+82",
                            @"Kuwait"                                       : @"+965",
                            @"Kyrgyzstan"                                   : @"+996",
                            @"Laos"                                         : @"+856",
                            @"Latvia"                                       : @"+371",
                            @"Lebanon"                                      : @"+961",
                            @"Lesotho"                                      : @"+266",
                            @"Liberia"                                      : @"+231",
                            @"Libya"                                        : @"+218",
                            @"Liechtenstein"                                : @"+423",
                            @"Lithuania"                                    : @"+370",
                            @"Luxembourg"                                   : @"+352",
                            @"Macau SAR China"                              : @"+853",
                            @"Macedonia"                                    : @"+389",
                            @"Madagascar"                                   : @"+261",
                            @"Malawi"                                       : @"+265",
                            @"Malaysia"                                     : @"+60",
                            @"Maldives"                                     : @"+960",
                            @"Mali"                                         : @"+223",
                            @"Malta"                                        : @"+356",
                            @"Marshall Islands"                             : @"+692",
                            @"Martinique"                                   : @"+596",
                            @"Mauritania"                                   : @"+222",
                            @"Mauritius"                                    : @"+230",
                            @"Mayotte"                                      : @"+262",
                            @"Mexico"                                       : @"+52",
                            @"Micronesia"                                   : @"+691",
                            @"Midway Island"                                : @"+1 808",
                            @"Micronesia"                                   : @"+691",
                            @"Moldova"                                      : @"+373",
                            @"Monaco"                                       : @"+377",
                            @"Mongolia"                                     : @"+976",
                            @"Montenegro"                                   : @"+382",
                            @"Montserrat"                                   : @"+1664",
                            @"Morocco"                                      : @"+212",
                            @"Myanmar"                                      : @"+95",
                            @"Namibia"                                      : @"+264",
                            @"Nauru"                                        : @"+674",
                            @"Nepal"                                        : @"+977",
                            @"Netherlands"                                  : @"+31",
                            @"Netherlands Antilles"                         : @"+599",
                            @"Nevis"                                        : @"+1 869",
                            @"New Caledonia"                                : @"+687",
                            @"New Zealand"                                  : @"+64",
                            @"Nicaragua"                                    : @"+505",
                            @"Niger"                                        : @"+227",
                            @"Nigeria"                                      : @"+234",
                            @"Niue"                                         : @"+683",
                            @"Norfolk Island"                               : @"+672",
                            @"Northern Mariana Islands"                     : @"+1 670",
                            @"Norway"                                       : @"+47",
                            @"Oman"                                         : @"+968",
                            @"Pakistan"                                     : @"+92",
                            @"Palau"                                        : @"+680",
                            @"Palestinian Territory"                        : @"+970",
                            @"Panama"                                       : @"+507",
                            @"Papua New Guinea"                             : @"+675",
                            @"Paraguay"                                     : @"+595",
                            @"Peru"                                         : @"+51",
                            @"Philippines"                                  : @"+63",
                            @"Poland"                                       : @"+48",
                            @"Portugal"                                     : @"+351",
                            @"Puerto Rico"                                  : @"+1 787",
                            @"Puerto Rico"                                  : @"+1 939",
                            @"Qatar"                                        : @"+974",
                            @"Reunion"                                      : @"+262",
                            @"Romania"                                      : @"+40",
                            @"Russia"                                       : @"+7",
                            @"Rwanda"                                       : @"+250",
                            @"Samoa"                                        : @"+685",
                            @"San Marino"                                   : @"+378",
                            @"Saudi Arabia"                                 : @"+966",
                            @"Senegal"                                      : @"+221",
                            @"Serbia"                                       : @"+381",
                            @"Seychelles"                                   : @"+248",
                            @"Sierra Leone"                                 : @"+232",
                            @"Singapore"                                    : @"+65",
                            @"Slovakia"                                     : @"+421",
                            @"Slovenia"                                     : @"+386",
                            @"Solomon Islands"                              : @"+677",
                            @"South Africa"                                 : @"+27",
                            @"South Georgia and the South Sandwich Islands" : @"+500",
                            @"Spain"                                        : @"+34",
                            @"Sri Lanka"                                    : @"+94",
                            @"Sudan"                                        : @"+249",
                            @"Suriname"                                     : @"+597",
                            @"Swaziland"                                    : @"+268",
                            @"Sweden"                                       : @"+46",
                            @"Switzerland"                                  : @"+41",
                            @"Syria"                                        : @"+963",
                            @"Taiwan"                                       : @"+886",
                            @"Tajikistan"                                   : @"+992",
                            @"Tanzania"                                     : @"+255",
                            @"Thailand"                                     : @"+66",
                            @"Timor Leste"                                  : @"+670",
                            @"Togo"                                         : @"+228",
                            @"Tokelau"                                      : @"+690",
                            @"Tonga"                                        : @"+676",
                            @"Trinidad and Tobago"                          : @"+1 868",
                            @"Tunisia"                                      : @"+216",
                            @"Turkey"                                       : @"+90",
                            @"Turkmenistan"                                 : @"+993",
                            @"Turks and Caicos Islands"                     : @"+1 649",
                            @"Tuvalu"                                       : @"+688",
                            @"Uganda"                                       : @"+256",
                            @"Ukraine"                                      : @"+380",
                            @"United Arab Emirates"                         : @"+971",
                            @"United Kingdom"                               : @"+44",
                            @"United States"                                : @"+1",
                            @"Uruguay"                                      : @"+598",
                            @"U.S. Virgin Islands"                          : @"+1 340",
                            @"Uzbekistan"                                   : @"+998",
                            @"Vanuatu"                                      : @"+678",
                            @"Venezuela"                                    : @"+58",
                            @"Vietnam"                                      : @"+84",
                            @"Wake Island"                                  : @"+1 808",
                            @"Wallis and Futuna"                            : @"+681",
                            @"Yemen"                                        : @"+967",
                            @"Zambia"                                       : @"+260",
                            @"Zanzibar"                                     : @"+255",
                            @"Zimbabwe"                                     : @"+263"
                            };
    
    return codes;
}



+(NSArray*)getAllValuesFromDictionary:(NSDictionary*)data{
        
        NSArray* keys=[data allKeys];
        NSMutableArray* arrObjects=[[NSMutableArray alloc]init];
        
        for (NSString* key in keys) {
                
                [arrObjects addObject:[data objectForKey:key]];
                
        }
        arrObjects=arrObjects.count ? arrObjects :nil;
        
        return arrObjects;
        
}


+(NSString*)getSelectedLanguageKeyWithValue:(NSString*)value data:(NSDictionary*)data{
    
    NSArray* arrCountryKeys=[data allKeysForObject:value];
    NSString* countryKey=arrCountryKeys.count ? arrCountryKeys[0]: nil;
    
    return countryKey;
    
}

+(NSArray*)getLanguageNamelist{
    NSArray* language=[[NSArray alloc]initWithObjects:
                       @"English (U.S.)",
                       @"English (UK)",
                       @"French (France)",
                       @"German",
                       @"Traditional Chinese",
                       @"Simplified Chinese",
                       @"Dutch",
                       @"Italian",
                       @"Spanish",
                       @"Portuguese (Brazil)",
                       @"Portuguese (Portugal)",
                       @"Danish",
                       @"Swedish",
                       @"Finnish",
                       @"Norwegian",
                       @"Korean",
                       @"Japanese",
                       @"Russian",
                       @"Polish",
                       @"Turkish",
                       @"Ukrainian",
                       @"Hungarian",
                       @"Arabic",
                       @"Thai",
                       @"Czech",
                       @"Greek",
                       @"Hebrew",
                       @"Indonesi",
                       @"Malay",
                       @"Romanian",
                       @"Slovak",
                       @"Croatian",
                       @"Catalan",
                       @"Vietnamese"
                       , nil];
    return language;
}

+(NSMutableArray *)removeViewControllFromNavArray:(int)number navigation:(UINavigationController*)class{
    
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: class.viewControllers];
    int count=0;
    if(number<navigationArray.count)
        for (int i= (int)navigationArray.count; i>=1; i--) {
            
            if(count==number)   break;
            
            [navigationArray removeLastObject];
            
            count++;
        }
    return navigationArray;
    
}


+(NSString*) bv_jsonStringWithDictionary:(NSDictionary*)dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

+(NSString*)jsonStringWithDictionary:(NSDictionary*)data{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return nil;
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"jsonString->%@",jsonString);
        return jsonString;
    }
}


+(NSDictionary*)getDictionaryWithJsonString:(NSString*)string{
        NSError *error;
        
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&error];
        
        return jsonResponse;
}
+(NSString*)getDeviceToken:(NSData*)deviceToken{
        
        NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSLog(@"*------------------------------*");
        NSLog(@"Device Token---%@", token);
        NSLog(@"*------------------------------*");
        return token;
}



+(void)viewButtonCALayer:(UIColor *)yourColor viewButton:(UIButton *)yourButton{
        yourButton.layer.cornerRadius=0.0F;
        yourButton.layer.masksToBounds=YES;
        yourButton.layer.borderColor=[yourColor CGColor];
        yourButton.layer.borderWidth= 1.0f;
        
        [yourButton setTitleShadowColor:yourColor forState:UIControlStateNormal];
        yourButton.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        yourButton.layer.shadowOpacity = 1.0;
        
        [yourButton setTitleColor:yourColor forState:UIControlStateNormal];
        
}

+(void)viewButtonCALayerClear:(UIButton *)yourButton{
        yourButton.layer.cornerRadius=0.0F;
        yourButton.layer.masksToBounds=YES;
        yourButton.layer.borderColor=[[UIColor clearColor] CGColor];
        yourButton.layer.borderWidth= 0.0f;
        
        [yourButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        yourButton.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        yourButton.layer.shadowOpacity = 0.0;
         [yourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        
}


+(NSString*)getTableNameWithUsername:(NSString*)name{
        
        
        //NSString *s = @"foo/bar:baz.foo";
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"-/:.@#$%^&*!"];
        name = [[name componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"_"];
        
        return name;
}

+(void)setShadowOnView:(UIView*)view{
        //Adds a shadow to sampleView
        CALayer *layer = view.layer;
        //        layer.shadowColor = [UIColor blackColor].CGColor;
        //        layer.shadowOpacity = 3;
        //        layer.shadowRadius = 1;
        //        layer.shadowOffset = CGSizeMake(0, 0);
        //        layer.masksToBounds = NO;
        
        layer.masksToBounds = NO;
        layer.shadowRadius = 2.0;
        layer.shadowOpacity = 0.6;
        layer.shadowColor = [[UIColor blackColor] CGColor];
        layer.shadowOffset = CGSizeMake(0, 3);;
        //        layer.shadowPath = [[UIBezierPath bezierPathWithRect:cell.viContainerUnread.bounds] CGPath];
}

+(NSString*)getRandomStringWithLength:(int)length{
        
        NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        
        NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
        
        for (int i=0; i<length; i++) {
                [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
        }
        
        return randomString;
        
}

@end
