//
//  ViewController.h
//  Weather Info
//
//  Created by Maulik Trambadiya on 16/01/19.
//  Copyright © 2019 Maulik Trambadiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtLatitude;
@property (weak, nonatomic) IBOutlet UITextField *txtLongitude;
@property (weak, nonatomic) IBOutlet UIButton *btnGetWeatherInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblWeatherInfo;
@property (weak, nonatomic) IBOutlet UIView *viewLoader;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
- (IBAction)getWeaterInfomationBtnClicked:(id)sender;

@end

