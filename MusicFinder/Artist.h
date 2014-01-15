#import <Foundation/Foundation.h>

@interface Artist : NSObject
@property (strong, nonatomic) NSString *name;
+ (Artist *)create:(NSString *)name;
@end
