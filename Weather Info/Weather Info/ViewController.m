//
//  ViewController.m
//  Weather Info
//
//  Created by Maulik Trambadiya on 16/01/19.
//  Copyright © 2019 Maulik Trambadiya. All rights reserved.
//

#define API_KEY "7b8c61f43ba41f05075cead09b85645f"

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableString *apiURLString;
    id dictWeaterInfo;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //Ahmedabad - 23.0225° N, 72.5714° E
    //[self setApiUrl:@"23.0225" withlongitude:@"72.5714"];
    
    UITapGestureRecognizer *viewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    
    [self.view addGestureRecognizer:viewTapRecognizer];
    
}
#pragma mark - TapGesture Events
- (void)viewTapped{
    ////Resign text fields
    [self.txtLatitude resignFirstResponder];
    [self.txtLongitude resignFirstResponder];
}

#pragma mark - Button Events
- (IBAction)getWeaterInfomationBtnClicked:(id)sender {
    
    [self viewTapped];//Resign text fields
    
    if (![self.txtLatitude.text length] || ![self.txtLongitude.text length]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Please fill all details" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * okay = [UIAlertAction actionWithTitle:@"Okay"                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
             if (![self.txtLatitude.text length]) {
                 [self.txtLatitude becomeFirstResponder];
             }else{
                 [self.txtLongitude becomeFirstResponder];
             }
        }];
        
        [alertController addAction:okay];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{//Means both details available and find the weather

        [self setApiUrl:self.txtLatitude.text withlongitude:self.txtLongitude.text];
    
    }
}

#pragma mark - Api Calling
//setting api url string using lat and logn
-(void)setApiUrl:(NSString *)latitude withlongitude:(NSString *)longitude {
    [self showHideLoader:NO];
    
    apiURLString = [NSMutableString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&appid=%s&units=Metric",latitude,longitude,API_KEY];
    [self makeApiCall:apiURLString];
}

//calling  the weather api of @openweather.org
-(void)makeApiCall: (NSMutableString *)apiURLStringPar{
    //NSURL—An object that contains a URL. more on:
    // https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSession_class/#//apple_ref/doc/uid/TP40013435-CH1-SW2
    NSURL *urlContainingApiCall = [NSURL URLWithString:apiURLStringPar];
    //prepare url session
    NSURLSession *mySession = [NSURLSession sharedSession];
    //when a method asks for completion handler, it asks for a block of code that is executed once method operation is completed
    //delete the completion handler and put braces for the block i.e. {} and remove the return type
    [[mySession dataTaskWithURL:urlContainingApiCall completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Network error encountered %@",error);
            return;
        }
        NSHTTPURLResponse *pointerToDetStatusCode = (NSHTTPURLResponse *) response; //type casting ?
        if (pointerToDetStatusCode.statusCode < 200 || pointerToDetStatusCode.statusCode >= 300) {
            NSLog(@"HTTP error status code %ld", (long)pointerToDetStatusCode.statusCode);
            [self showHideLoader:YES];

            return;
        }
        NSError *parseError;
        dictWeaterInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!dictWeaterInfo) {
            NSLog(@"Parse error %@", parseError);
            self.lblWeatherInfo.text = parseError.description;
        }
        NSLog(@"\nJSON response is: %@",dictWeaterInfo);
        
        //pull main thread and put the data on UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showHideLoader:YES];
            NSString *strInfo = [NSString stringWithFormat:@"Weather Info : %@\nTemperature : %@ c°\nHumidity : %@",dictWeaterInfo[@"weather"][0][@"description"],dictWeaterInfo[@"main"][@"temp"],dictWeaterInfo[@"main"][@"humidity"]];
            self.lblWeatherInfo.text = strInfo;
        });
        
    }]resume];
    
}
#pragma mark - Loading loader
- (void)showHideLoader:(BOOL)isHide{
    if (isHide) {
        [self.loadingView stopAnimating];
        [self.view sendSubviewToBack:self.viewLoader];
    }else{
        [self.loadingView startAnimating];
        [self.view bringSubviewToFront:self.viewLoader];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
