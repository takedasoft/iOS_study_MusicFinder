/*
 
 */
#define ITUNES_LIBRALY_XML_FILE @"/Users/hihappy/Music/iTunes/iTunes Music Library.xml"

#import "MyArtistsViewController.h"
#import "Artist.h"
#import "MyArtistsLibraryParser.h"
#import "RecommendArtistsViewController.h"

@interface MyArtistsViewController ()
@property (strong,nonatomic) NSMutableArray *artists;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MyArtistsViewController


- (void)setupArtists
{
    MyArtistsLibraryParser *parser = [MyArtistsLibraryParser create:ITUNES_LIBRALY_XML_FILE];
    NSArray *artists = [parser artists];
    _artists = [[NSMutableArray alloc] init];
    for (NSString *artistName in artists) {
        [_artists addObject:[Artist create:artistName]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupArtists];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RecommendArtistsViewController *next = [segue destinationViewController];
    Artist *a = _artists[_tableView.indexPathForSelectedRow.row];
    next.selectedArtist = a.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//テーブル表示に必要なメソッド
//指定セクションに何個データがあるか。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"-- NumberOfRowSection %d", [_artists count]);
    return [_artists count];
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             @"ArtistCell" forIndexPath:indexPath];
    Artist *artist = _artists[indexPath.row];
    //NSLog(@"-- cellForRowAtIndexPath %d %@", indexPath.row, artist);
    cell.textLabel.text = [NSString stringWithFormat:@"%@", artist.name];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}


@end
