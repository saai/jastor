#import "ProductCategory.h"
#import "Product.h"

@implementation Product

@synthesize name, category, amount, createdAt;
@synthesize phone;

@synthesize jsonKeyFromAttributeMapping;

-(NSDictionary *)jsonKeyFromAttributeMapping
{
    if (!jsonKeyFromAttributeMapping) {
        jsonKeyFromAttributeMapping = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        @"tel_num", @"phone",nil];
    }
    return jsonKeyFromAttributeMapping;
}
@end
