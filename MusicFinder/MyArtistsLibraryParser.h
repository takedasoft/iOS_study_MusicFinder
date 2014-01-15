#import <Foundation/Foundation.h>

@interface MyArtistsLibraryParser : NSObject <NSXMLParserDelegate>
+ (MyArtistsLibraryParser *)create:(NSString *)path;
- (NSArray *)artists;
@end
