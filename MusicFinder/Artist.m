#import "Artist.h"

@implementation Artist

+ (Artist *)create:(NSString *)name
{
    Artist *new = [[Artist alloc] init];
    new.name = name;
    return new;
}
@end
