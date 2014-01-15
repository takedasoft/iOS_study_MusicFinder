#import "MyArtistsLibraryParser.h"

@interface MyArtistsLibraryParser ()
@property (strong,nonatomic) NSMutableArray *artists;
@property (strong,nonatomic) NSString *dbPath;
@end

@implementation MyArtistsLibraryParser

bool inKeyElement;
bool inStringElement;
bool nextStringIsArtistName;


+ (MyArtistsLibraryParser *)create:(NSString *)path
{
    MyArtistsLibraryParser *me = [[MyArtistsLibraryParser alloc] init];
    me.dbPath = path;
    [me parseArtists];
    return me;
}
- (NSArray *)artists
{
    return _artists;
}

- (NSArray *)parseArtists
{
    NSString *xmlstr = [NSString stringWithContentsOfFile:_dbPath encoding:NSUTF8StringEncoding error:nil];
    NSData *xmldata = [xmlstr dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmldata];
    
    [parser setDelegate:self];
	[parser parse];
    
    return _artists;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	_artists = [NSMutableArray array];
	inKeyElement = NO;
    inStringElement = NO;
    nextStringIsArtistName = NO;
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [_artists sortUsingComparator:^(NSString *o1, NSString *o2){
        return [o1 compare:o2];
    }];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"key"]) {
		inKeyElement = YES;
	}else if([elementName isEqualToString:@"string"]) {
		inStringElement = YES;
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"key"]) {
		inKeyElement = NO;
	}else if([elementName isEqualToString:@"string"]) {
		inStringElement = NO;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)text {
	if (inStringElement && nextStringIsArtistName) {
        if( ! [_artists containsObject:text] ){
            [_artists addObject:text];
//            NSLog( @"%@ , %d", text, [_artists count] );
        }
	}else if( inKeyElement ) {
        if( [text isEqualToString:@"Artist"] ){
            nextStringIsArtistName = YES;
        }else{
            nextStringIsArtistName = NO;
        }
    }
}
@end