//
//  Jastor.h
//  Jastor
//
//  Created by Elad Ossadon on 12/14/11.
//  http://devign.me | http://elad.ossadon.com | http://twitter.com/elado
//

@interface Jastor : NSObject <NSCoding>
{
    NSDictionary *_jsonKeyFromAttributeMapping;
}
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) NSDictionary *jsonKeyFromAttributeMapping;

@end
