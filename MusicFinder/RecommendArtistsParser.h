#import <Foundation/Foundation.h>

@interface RecommendArtistsParser : NSObject <NSXMLParserDelegate>
+ (RecommendArtistsParser *)create:(NSString *)xml;
- (NSArray *)artists;
@end
