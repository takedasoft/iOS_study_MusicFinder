#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong,nonatomic) NSString *selectedArtist;
@property (strong,nonatomic) NSURL *amazonComUrl;
@property (strong,nonatomic) NSURL *amazonJpUrl;
- (IBAction)onSwitchView;
@end
