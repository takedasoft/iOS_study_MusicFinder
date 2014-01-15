#import <UIKit/UIKit.h>

@interface RecommendArtistsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSString *selectedArtist;
@end
