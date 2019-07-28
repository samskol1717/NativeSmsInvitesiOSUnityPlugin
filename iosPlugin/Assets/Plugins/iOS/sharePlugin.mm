#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

extern UIViewController* UnityGetGLViewController();

@interface sharePlugin: UIViewController <MFMessageComposeViewControllerDelegate>
{
    NSDate *creationDate;
   // - (void)sendText:(id)sender;
}
@end

@implementation sharePlugin

static sharePlugin *_sharedInstance;

+(sharePlugin*) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"Creating shared instance");
        _sharedInstance = [[sharePlugin alloc] init];
    });
    return _sharedInstance;
}

-(id) init
{
    self = [super init];
    if(self)
        [self initHelper];
    return self;
}

-(void)initHelper
{
    NSLog(@"Init helper called");
    creationDate = [NSDate date];
}

-(double) getElapsedTime
{
    NSLog(@"called get elapsed time from objC!");
    return[[NSDate date] timeIntervalSinceDate:creationDate];
}

-(void) sendText
{
    //[super viewDidAppear:YES];
    NSLog(@"called send text! objC");
     if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *textSheet = [[MFMessageComposeViewController alloc]init];
        textSheet.messageComposeDelegate = self;
        [textSheet setBody:@"Hello, World"];
        UIViewController *rootViewController = UnityGetGLViewController();
        [rootViewController presentViewController:textSheet animated:YES completion:nil];
    }
    else
    {
        NSString *result = @"SMS sharing is not supported with this device";
      //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      //  [alert show];
        
        UIViewController *rootViewController = UnityGetGLViewController();
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
            message:result
            preferredStyle:UIAlertControllerStyleAlert];
                        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        dispatch_async(dispatch_get_main_queue(), ^ {
        [rootViewController presentViewController:alert animated:YES completion:nil];
        });
        
        NSLog(@"%@",result);
    }
}



- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSString *output = nil;
    switch (result) {
    case MessageComposeResultSent:
        output = @"Message Sent Successfully";
        NSLog(@"%@",output);
        UnitySendMessage("pluginTest","catchTextMessageCallback", "0");
        break;
    case MessageComposeResultCancelled:
        output =@"Message Cancelled";
        NSLog(@"%@",output);
        UnitySendMessage("pluginTest","catchTextMessageCallback", "1");
        break;
    case MessageComposeResultFailed:
        output = @"Error Occured while sending";
        NSLog(@"%@",output);
        UnitySendMessage("pluginTest","catchTextMessageCallback", "2");
        break;
        
    default:
        break;
    }
    
    //UIAlertView *resultView = [[UIAlertView alloc] initWithTitle:@"Result" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    UIViewController *rootViewController = UnityGetGLViewController();
    
   UIAlertController *resultView = [UIAlertController alertControllerWithTitle:@"Result"
                              message:output
                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    [resultView addAction:defaultAction];
     dispatch_async(dispatch_get_main_queue(), ^ {
    [rootViewController presentViewController:resultView animated:YES completion:nil];
         });
    
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

extern "C"
{
    double IOSgetElapsedTime()
    {
        return[[sharePlugin sharedInstance] getElapsedTime];
    }
    void IOSsendText()
    {
        [[sharePlugin sharedInstance] sendText];
    }
}
