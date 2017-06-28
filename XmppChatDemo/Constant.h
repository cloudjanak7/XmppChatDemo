//
//  Constant.h
//  Talk2Good
//
//  Created by Sandeep Kumar on 08/09/15.
//  Copyright (c) 2015 InfoiconTechnologies. All rights reserved.
//

#ifndef Talk2Good_Constant_h
#define Talk2Good_Constant_h


#endif

#define KEEP_ALIVE_INTERVAL     600

//************** Date Formats *************************

#define GET_FORMAT_TYPE @"yyyy-MM-dd HH:mm:ss"
#define SET_FORMAT_TYPE @"yyyy-MM-dd hh:mm a"
#define SET_FORMAT_TYPE1 @"dd MMM, yyyy"
#define SET_FORMAT_TYPE2 @"yyyy-MM-dd"



//************** Custom Medthods for ViewControllers  *************************


#define GET_VIEW_CONTROLLER(viewController) [self.storyboard instantiateViewControllerWithIdentifier:viewController]

#define GET_VIEW_CONTROLLER_STORYBOARD(viewController) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:viewController]

#define MOVE_VIEW_CONTROLLER(viewController,animation)    [self.navigationController pushViewController:viewController animated:animation];

#define JOIN_STRING(str1,str2)      [str1 stringByAppendingString:str2]

#define IS_NULL(value)              [value isEqual:[NSNull null]]

#define IS_IPHONE_4s ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )





