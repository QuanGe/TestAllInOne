

/*－－－－－－－－－－－－－－－－－－－－app的相关配置－－－－－－－－－－－－－－－－－－*/
/*---------------------------------相关值根据需要自行更改------------------------*/

#define kAPIBaseURI @" "
#define kBaiduAPIKey @" "
#define kBaiduSecretKey @" "
#define kUMengKey       @" "
#define kShareSDKKey    @""
#define kQZoneId        @""
#define kQZoneKey       @""
#define kOrtherAESKey   @""
#define kBookAESKey     @""


/*---------------------------------用户相关信息-------------------------------------*/

#define kUsername           @"usernameNew"
#define kUserNickname       @"userNicknameNew"
#define kUserPassword       @"userPassword"
#define kUserID             @"userID"
#define kUserToken          @"userToken"
#define kUserPortraitUrl    @"userPortraitUrl"
#define kUserEmail          @"userEmail"
#define kUserGender         @"userGender"
#define kUserSign           @"userSign"
#define kUserTelephone      @"userTelephone"
#define kUserStatus         @"userStatus"
#define kUserType           @"userType"
#define kUserOSPlatform     @"userOSPlatform"




/*---------------------------------程序相关常数-------------------------------------*/
//App Id、下载地址、评价地址
#define kAppId      @"593499239"
#define kAppUrl     [NSString stringWithFormat:@"https://itunes.apple.com/us/app/ling-hao-xian/id%@?ls=1&mt=8",kAppId]
#define kRateUrl    [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppId]

#define kPlaceholderImage       [UIImage imageNamed:@"lessonDefult"]
#define kUserPlaceHoldImage [UIImage imageNamed:@"userImageDefault.png"]


/*---------------------------------程序全局通知-------------------------------------*/
//重新登录通知

/*---------------------------------程序界面配置信息-------------------------------------*/

//设置app界面字体及颜色

#define kTitleFontLarge              [UIFont boldSystemFontOfSize:25]//一级标题字号
#define kTitleFontMiddle             [UIFont boldSystemFontOfSize:19]//二级标题字号
#define kTitleFontSmall              [UIFont boldSystemFontOfSize:16]//三级标题字号


//几个常用色彩

#define kTabSelectColor         mRGBToColor(0x0494ba)
#define kNavTitleColor          mRGBToColor(0x262626)
#define kWhiteColor             [UIColor whiteColor]
#define kBlackColor             [UIColor blackColor]
#define kClearColor             [UIColor clearColor]

#define kShadowColor mRGBToColor(0x8D8D8D)


//界面布局
#define kLeftOrRightEdgeInset           50 //所有界面左右边距




/*---------------------------------第三方登录-------------------------------------*/
