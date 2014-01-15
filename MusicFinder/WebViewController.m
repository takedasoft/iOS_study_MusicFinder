#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *wv;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *switchBtn;
@end

@implementation WebViewController

bool onCom = false;
@synthesize wv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *encoded = [_selectedArtist stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *amazonComBase = @"http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias\%3Dpopular";
    NSString *amazonJpBase = @"http://www.amazon.co.jp/s/ref=nb_sb_ss_i_0_10?url=search-alias%3Dpopular";
    
    NSString *amazonComUrl = [NSString stringWithFormat:@"%@&field-keywords=%@", amazonComBase, encoded];
    NSString *amazonJpUrl = [NSString stringWithFormat:@"%@&field-keywords=%@", amazonJpBase, encoded ];
    
    _amazonComUrl = [NSURL URLWithString:amazonComUrl];
    _amazonJpUrl = [NSURL URLWithString:amazonJpUrl];

    [self getAmazonCom];
}

- (void)getAmazonCom
{
    onCom = YES;
    _switchBtn.title = @"JP";
    NSURLRequest *URLreq = [NSURLRequest requestWithURL:_amazonComUrl];
    [wv loadRequest: URLreq];
}
- (void)getAmazonJp
{
    onCom = NO;
    _switchBtn.title = @"COM";
    NSURLRequest *URLreq = [NSURLRequest requestWithURL:_amazonJpUrl];
    [wv loadRequest: URLreq];
}

- (IBAction)onSwitchView
{
    if( onCom ){
        [self getAmazonJp];
    }else{
        [self getAmazonCom];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
