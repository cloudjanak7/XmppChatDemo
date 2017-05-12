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

#define VALUE_IN_STRING(val_Char)       @(val_Char)
#define VALUE_IN_CHAR(val_String)       (char*)[val_String UTF8String]

//************** SIP SERVER STATIC *************************



//#define SIP_SERVER              "128.199.154.118"
//#define SIP_USER_PASSWORD1       "91100245iit"
//#define SIP_USER_NAME3          "101"
//#define SIP_USER_NAME4          "102"
//
//#define SIP_USER_PASSWORD      "info1234"
//#define SIP_USER_NAME1          "1060"
//#define SIP_USER_NAME2          "1061"

#define SIP_USER_REGISTER      @"register"
#define SIP_USER_NAME          @"sip"
#define SIP_SERVER             @"sip_server"
#define SIP_USER_PASSWORD      @"sip_password"


#define SIP_CHATTING_USER_NAME1         @"sandeep@localhost"
#define SIP_CHATTING_USER_NAME2         @"nitin@localhost"
#define SIP_CHATTING_USER_NAME3         @"arun@localhost"
#define SIP_CHATTING_USER_NAME4         @"prabhat@localhost"


#define SIP_CHATTING_SERVER      @"52.29.3.37"//@"162.243.213.192"
#define SIP_CHATTING_PORT        5222


#define ENABLE_SIP_USER1        1

//************** Call Type  *************************

#define CALL_TYPE_VOIP_NATIVE   @"NATIVE"
#define CALL_TYPE_VOIP_SEXY     @"SEXY"


//************** PayPal Id STATIC *************************

#define PAYPAL_SANDBOX_CLIENT_ID   @"Af3d1mxH39jHEUKH7AE4zZUH-kBVZ1-U8bnhZcLaQ8bPqAJaeq2SMT4qTk9s-4bJYuvyIl5Jhdp6D09y"
#define PAYPAL_SANDBOX_SECRET_ID   @"EMqoNbLwxGV5-WJUBh9-rpBX15HsbES9-6b1fQluQG1tUGAQIiah2i4OIG2ueM8tNt0wItEUmEQcunHN"

#define isTRANSACTION           @"Transaction"
#define TRANSACTION_DETAIL      @"Transaction_Detail"
#define TRANSACTION_STATUS      @"Transaction_Status"
#define isYES                   @"Yes"
#define isNO                    @"No"



//************** Images *************************
#define NAV_BAR_IMAGE           @"top_bg_inner.png"
#define MENU_IMAGE              @"menu.png"

#define DEMO_PROFILE_PIC        @"profile_mainpic.png"
#define DEMO_LOGO_PIC           @"search_pic.png"

//************** Color *************************
#define COLOR_DEFAULT_BUTTON    @"#67F226"
#define COLOR_CALLING           @"#00CE30"
#define COLOR_END_CALL          @"#FF0027"
#define COLOR_ON_LINE           @"#00CE30"
#define COLOR_OFF_LINE          @"#DFDFDF"

#define COLOR_BALANCE1          @"#949192"
#define COLOR_BALANCE2          @"#009124"

#define COLOR_HEADER_DEFAULT    @"#F4F4F4"

//************** Date Formats *************************

#define GET_FORMAT_TYPE @"yyyy-MM-dd HH:mm:ss"
#define SET_FORMAT_TYPE @"yyyy-MM-dd hh:mm a"
#define SET_FORMAT_TYPE1 @"dd MMM, yyyy"
#define SET_FORMAT_TYPE2 @"yyyy-MM-dd"

//************** Local Server URL *************************



static NSString *const kPrefixUrl=@"http://52.28.27.22";
//static NSString *const kPrefixUrl=@"http://162.243.251.173/talk2good";

static NSString *const kURL_Registration = @"/services/user/register";

static NSString *const kURL_Login =@"/services/user/login" ;

static NSString *const kURL_Logout =@"/services/user/logout";

static NSString *const kURL_CountryList = @"/services/api/countries";

static NSString *const kURL_LanguageList = @"/services/api/languages";

static NSString *const kURL_UpdateProfile = @"/services/user/update";

static NSString *const kURL_ChangePassword = @"/services/user/changepassword";

static NSString *const kURL_ForgotPassword = @"/services/user/forget";

static NSString *const kURL_SearchPeople = @"/services/search";

static NSString *const kURL_AddToContact = @"/services/user/addContact";

static NSString *const kURL_RemoveToContact = @"/services/user/removeContact";

static NSString *const kURL_ContactList = @"/services/user/getContacts";

static NSString *const kURL_CallBilling = @"/services/user/callBillingPerMinute";

static NSString *const kURL_MessageHistory = @"http://52.29.3.37/talk2good/singleChatSync.php";

static NSString *const kURL_Withdrawal = @"/services/payment/withdrawal";

static NSString *const kURL_DeviceInfo = @"/services/user/userDevice";

static NSString *const kURL_GetCurrentBalance = @"/services/user/getMemberBalance";

static NSString *const kURL_CreditBalance = @"/services/payment/paymentCredit";

static NSString *const kURL_Transaction_History = @"/services/payment/transactionLogs";

static NSString *const kURL_SendVoipNotification = @"/services/user/userCall";

static NSString *const kURL_DeleteUser = @"/services/user/deleteUser";

static NSString *const kURL_UserRating = @"/services/user/userRating";





//************** User Data Constants *************************
#define COUNTRY_LIST                @"countries"
#define LANGUAGE_LIST               @"languages"
#define MALE                        @"Male"
#define FEMALE                      @"Female"
#define USER_DATA_USER_NAME         @"username"
#define USER_DATA_EMAIL             @"email"
#define USER_DATA_PASSWORD          @"password"
#define USER_DATA_OLD_PASSWORD      @"old_password"
#define USER_DATA_NEW_PASSWORD      @"new_password"
#define USER_DATA_FULL_NAME         @"firstName"
#define USER_DATA_LAST_NAME         @"lastName"
#define USER_DATA_GENDER            @"gender"
#define USER_DATA_DOB               @"dob"
#define USER_DATA_AGE               @"age"
#define USER_DATA_COUNTRY           @"country"
#define USER_DATA_CURRENCEY         @"currency"
#define USER_DATA_PIC               @"profile_image"
#define USER_DATA_DESCRIPTION       @"description"
#define USER_DATA_LANGUAGE          @"native_languages"
#define USER_DATA_IS_NATIVE         @"is_native"
#define USER_DATA_NATIVE_RATE       @"native_charge"
#define USER_DATA_NATIVE_LANGUAGE   @"native_languages"
#define USER_DATA_IS_SEXY           @"is_sexy"
#define USER_DATA_SEXY_TALK_RATE    @"sexy_talk_charge"
#define USER_DATA_PAY_PAL_ACCOUNT   @"paypal_email"
#define USER_DATA_MEMBER_ID         @"member_id"
#define USER_DATA_USER_ID           @"user_id"
#define USER_DATA_REGISTERED_ON     @"registered_on"
#define USER_DATA_CREDIT_BALANCE    @"credit_balance"
#define USER_DATA_INTEREST_IN       @"interested_in"
#define USER_DATA_LOCAL_PIC         @"local_pic"
#define USER_DATA_RATING            @"rating"
#define USER_DATA_USER              @"user"
#define USER_DATA_MEMEBER           @"member"






//************** ViewControllers Identifiers *************************
static NSString *const kslider = @"slider";
static NSString *const kLeftMenuTableViewController = @"LeftMenuTableViewController";
static NSString *const kSignUpSecondTableViewController = @"SignUpSecondTableViewController";
static NSString *const kSignUpThirdTableViewController  = @"SignUpThirdTableViewController";
static NSString *const kLoginDetailViewController       = @"LoginDetailViewController";
static NSString *const kPersonDetailTableViewController = @"PersonDetailTableViewController";
static NSString *const kEditProfieViewController        = @"EditProfieViewController";
static NSString *const kAccountDetailTableViewController= @"AccountDetailTableViewController";
static NSString *const kWithdrawAmountViewController    = @"WithdrawAmountViewController";
static NSString *const kAccountBalanceViewController    = @"AccountBalanceViewController";
static NSString *const kAddAmountViewController         = @"AddAmountViewController";
static NSString *const kSearchContactTableViewController= @"SearchContactTableViewController";
static NSString *const kDashboardViewController         = @"DashboardViewController";
static NSString *const kCustomDatePickerViewController  = @"CustomDatePickerViewController";
static NSString *const kProfileViewController           = @"ProfileViewController";
static NSString *const kContactsTableViewController     = @"ContactsTableViewController";
static NSString *const kCallingViewController           = @"CallingViewController";
static NSString *const kInboxMessageTableViewController = @"InboxMessageTableViewController";
static NSString *const kChatViewController              = @"ChatViewController";
static NSString *const kSettingsViewController          = @"SettingsViewController";
static NSString *const kViewController                  = @"ViewController";
static NSString *const kAboutTalk2GoodViewController    = @"AboutTalk2GoodViewController";
static NSString *const kSearchContactsResultTableViewController = @"SearchContactsResultTableViewController";
static NSString *const kTransactionHistoryTableViewController   = @"TransactionHistoryTableViewController";
static NSString *const kSexyTalkSectionViewController           = @"SexyTalkSectionViewController";
static NSString *const kSexyTalkContactsTableViewController     = @"SexyTalkContactsTableViewController";

static NSString *const kAccountSettingTableViewController     = @"AccountSettingTableViewController";

//************** Custom Medthods for ViewControllers  *************************


#define GET_VIEW_CONTROLLER(viewController) [self.storyboard instantiateViewControllerWithIdentifier:viewController]

#define GET_VIEW_CONTROLLER_STORYBOARD(viewController) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:viewController]

#define MOVE_VIEW_CONTROLLER(viewController,animation)    [self.navigationController pushViewController:viewController animated:animation];

#define JOIN_STRING(str1,str2)      [str1 stringByAppendingString:str2]

#define IS_NULL(value)              [value isEqual:[NSNull null]]

#define IS_IPHONE_4s ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

//        #define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : \
//                                ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 :\
//                                ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 :\
//                                ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : 999))))
//



//************** Define for Chatting   *************************

#define		VIDEO_LENGTH	5

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]

#define		COLOR_OUTGOING	HEXCOLOR(0x007AFFFF)
#define		COLOR_INCOMING	HEXCOLOR(0xE6E5EAFF)

#define UPDATE_CONTACTS      @"update_contacts"

//#define DATABASE_NAME        @"Talk2Good.db"

//************** Devive Token *************************

#define DEVICE_TOKEN_CHATTING   @"deviceToken_chat"

#define DEVICE_TOKEN_VOIP       @"deviceToken_voip"

#define DEVICE_TYPE             @"iOS"

#define NOTIFICATION_TYPE_BALANCE       @"balance"
#define NOTIFICATION_TYPE_CONTACT       @"contact"
#define NOTIFICATION_TYPE_MESSAGE       @"message"

