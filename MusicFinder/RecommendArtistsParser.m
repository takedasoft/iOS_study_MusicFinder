#import "RecommendArtistsParser.h"

@interface RecommendArtistsParser ()
@property (strong,nonatomic) NSMutableArray *artists;
@property (strong,nonatomic) NSString *xml;
@end

@implementation RecommendArtistsParser

bool inAElement;

+ (RecommendArtistsParser *)create:(NSString *)xml
{
    RecommendArtistsParser *me = [[RecommendArtistsParser alloc] init];
    me.xml = xml;
    [me parseArtists];
    return me;
}
- (NSArray *)artists
{
    return _artists;
}

- (NSArray *)parseArtists
{
    NSData *xmldata = [_xml dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmldata];
    
    [parser setDelegate:self];
	[parser parse];
    
    return _artists;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	_artists = [NSMutableArray array];
	inAElement = NO;
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [_artists sortUsingComparator:^(NSString *o1, NSString *o2){
        return [o1 compare:o2];
    }];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"a"]) {
		inAElement = YES;
	}
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"a"]) {
		inAElement = NO;
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)text {
	if (inAElement) {
        if( ! [_artists containsObject:text] ){
            [_artists addObject:text];
        }
	}
}

@end
