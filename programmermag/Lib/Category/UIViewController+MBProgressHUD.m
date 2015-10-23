//
//  UIViewController+MBProgressHUD.m
//  EducationVideo
//
//  Created by zhangruquan on 15/5/19.
//  Copyright (c) 2015年 net.csdn. All rights reserved.
//

#import "UIViewController+MBProgressHUD.h"

@implementation UIViewController (MBProgressHUD)

- (void)showLoadAlertView:(NSString*)title imageName:(NSString*)name  autoHide:(BOOL)hide
{
    MBProgressHUD *hud = (MBProgressHUD *)[self.view  viewWithTag:6666];
    if(hide)
        hud = (MBProgressHUD *)[self.view  viewWithTag:7777];
    if(hud == nil)
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.tag = 6666;
        if(hide)
            hud.tag = 7777;
    }
    hud.labelText = title;
    
    if(hide)
    {
        if(name == nil)
        {
            hud.mode = MBProgressHUDModeText;
        }
        else
        {
            if(hud.customView == nil)
            {
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]] ;
            }
            else
            {
                
                
                [(UIImageView*)hud.customView setImage:[UIImage imageNamed:name]];
            }
            hud.customView.frame = CGRectMake(0, 0, ((UIImageView *)hud.customView).image.size.width, ((UIImageView *)hud.customView).image.size.height);
            hud.mode = MBProgressHUDModeCustomView;
        }
        [hud show:YES];
        [hud hide:YES afterDelay:1];
    }
    else
    {
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud show:YES];
    }

    
}

- (void)hideLoadAlertView
{
   
    MBProgressHUD *hud = (MBProgressHUD *)[self.view  viewWithTag:6666];
    if(hud == nil)
    {
        return;
    }
    else
        [hud hide:YES];
    
}
@end
