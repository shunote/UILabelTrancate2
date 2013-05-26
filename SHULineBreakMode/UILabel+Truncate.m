#import "UILabel+Truncate.h"
#import <objc/runtime.h>

#define ellipsis @"...Mer ▾ "
#define kNumberOfLines 2

@implementation UILabel ( Truncate )

- (void)setTruncatingText:(NSString *)txt {    

    int lines = self.numberOfLines;

    if ([self numberOfLinesNeeded:txt] > lines) {
        
        NSMutableString *truncatedString = [txt mutableCopy];
        [truncatedString appendString:ellipsis];
        NSRange range = NSMakeRange(truncatedString.length - (ellipsis.length + 1), 1);
        
        while ([self numberOfLinesNeeded:truncatedString] > lines) {
            [truncatedString deleteCharactersInRange:range];
            range.location--;
        }
        
        [truncatedString deleteCharactersInRange:range];  //need to delete one more to make it fit
        CGRect labelFrame = self.frame;
        labelFrame.size.height = [txt sizeWithFont:self.font].height * lines;
        self.frame = labelFrame;
        self.text = truncatedString;

    } else {
        
        CGRect labelFrame = self.frame;
        labelFrame.size.height = [txt sizeWithFont:self.font].height * lines;
        self.frame = labelFrame;
        self.text = txt;
    }
}

- (int)numberOfLinesNeeded:(NSString *) s {

    float oneLineHeight = [s sizeWithFont:self.font].height;
    float totalHeight = [s sizeWithFont:self.font
                      constrainedToSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping].height;
    return nearbyint(totalHeight/oneLineHeight);
}


@end
