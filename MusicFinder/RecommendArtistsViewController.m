/*
iTunes API
*/
#import "RecommendArtistsViewController.h"
#import "RecommendArtistsParser.h"
#import "WebViewController.h"
#import "Artist.h"

@interface RecommendArtistsViewController ()
@property (strong,nonatomic) NSMutableArray *artists;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation RecommendArtistsViewController


- (NSString *)urlEncode:(NSString *)word
{
    CFStringRef plain = (__bridge CFStringRef)word;
    NSString *encoded =
    (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                          NULL,
                                                                          plain,
                                                                          NULL,
                                                                          CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                          CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return encoded;
}

- (NSURL *)getLookupUrl:(NSString *)word
{
    NSString *base = @"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?entity=musicArtist";
    NSString *searchPath = [NSString stringWithFormat:@"%@&term=%@", base, [self urlEncode:word] ];
    //NSLog( @"%@", searchPath );
    NSURL *url = [NSURL URLWithString:searchPath];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSHTTPURLResponse *res;
    NSError *error = nil;
    
    NSData *contents = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:contents options:0 error:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *lookupPath = [[[json objectForKey:@"results"] objectAtIndex:0] objectForKey:@"artistLinkUrl"];
    
    //NSLog( @"%@", [[json objectForKey:@"results"] objectAtIndex:0] );
    //NSLog( @"%@", lookupPath );

    return [NSURL URLWithString:lookupPath];;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebViewController *next = [segue destinationViewController];
    Artist *a = _artists[_tableView.indexPathForSelectedRow.row];
    next.selectedArtist = a.name;
}

- (NSArray *)parseRelativeArtists:(NSString *)contents byPattern:(NSString *)pattern
{
    NSError *error = nil;
    
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    
    if( error == nil ){
        NSTextCheckingResult *result = [regexp firstMatchInString:contents options:0 range:NSMakeRange(0, contents.length)];
        NSString *m =  [contents substringWithRange:[result rangeAtIndex:0]];
        //NSLog( @"%@", m );
        RecommendArtistsParser *parser = [RecommendArtistsParser create:m];
        return [parser artists];
    }else{
        NSLog( @"--- regex error ---");
    }
    return [NSArray array];
}

- (NSArray *)getRelativeArtists:(NSURL *)lookupUrl
{
    NSMutableArray *relativeArtists = [NSMutableArray array];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:lookupUrl];
    NSHTTPURLResponse *res;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
    NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    for( NSString *a in [self parseRelativeArtists:contents byPattern:@"<div metrics-loc=\"Titledbox_Contemporaries\">.*?</div>"] ){
        [relativeArtists addObject:a];
    }
    for( NSString *a in [self parseRelativeArtists:contents byPattern:@"<div metrics-loc=\"Titledbox_Influencers\">.*?</div>"] ){
        [relativeArtists addObject:a];
    }
    for( NSString *a in [self parseRelativeArtists:contents byPattern:@"<div metrics-loc=\"Titledbox_Followers\">.*?</div>"] ){
        [relativeArtists addObject:a];
    }
    
    return relativeArtists;
}

- (NSArray *)getRelativeArtistsByWord:(NSString *)word
{
    return [self getRelativeArtists:[self getLookupUrl:word]];
}

- (void)setupArtists
{
    NSString *artist = _selectedArtist;
    NSArray *relatives = [self getRelativeArtistsByWord:artist];
    
    _artists = [[NSMutableArray alloc] init];
    
    for( NSString *name in relatives ){
        [_artists addObject:[Artist create:name]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupArtists];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_artists count];
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell" forIndexPath:indexPath];
    Artist *artist = _artists[indexPath.row];
    //NSLog(@"-- cellForRowAtIndexPath %d %@", indexPath.row, artist);
    cell.textLabel.text = [NSString stringWithFormat:@"%@", artist.name];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

@end