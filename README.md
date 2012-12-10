Jastor
===

Jastor is an Objective-C base class that is initialized with a dictionary (probably from your JSON response), and assigns dictionary values to all its (derived class's) typed @properties.

It supports nested types, arrays, NSString, NSNumber, NSDate and more.

Jastor is NOT a JSON parser. For that, you have [JSONKit](https://github.com/johnezang/JSONKit), [yajl](https://github.com/gabriel/yajl-objc) and many others.

The name sounds like **JSON to Object**er. Or something.


Examples
---

You have the following JSON:


	{
		"name": "Foo",
		"amount": 13
	}

and the following class:

	@interface Product
	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, copy) NSNumber *amount;
	@end

	@implementation Product
	@synthesize name, amount;
	@end

with Jastor, you can just inherit from `Jastor` class, and use `initWithDictionary:`

	// Product.h
	@interface Product : Jastor
	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, copy) NSNumber *amount;
	@end

	// Product.m
	@implementation Product
	@synthesize name, amount;
	@end

	// Some other code
	NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
	Product *product = [[Product alloc] initWithDictionary:dictionary];

	// Log
	product.name // => Foo
	product.amount // => 13

Nested Objects
---
Jastor also converts nested objects to their destination type:

	// JSON
	{
		"name": "Foo",
		"category": {
			"name": "Bar Category"
		}
	}

	// ProductCategory.h
	@interface ProductCategory : Jastor
	@property (nonatomic, copy) NSString *name;
	@end

	// ProductCategory.m
	@implementation ProductCategory
	@synthesize name;
	@end

	// Product.h
	@interface Product : Jastor
	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, copy) ProductCategory *category;
	@end

	// Product.m
	@implementation Product
	@synthesize name, category;
	@end


	// Code
	NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
	Product *product = [[Product alloc] initWithDictionary:dictionary];

	// Log
	product.name // => Foo
	product.category // => <ProductCategory>
	product.category.name // => Bar Category


Arrays
---
Having fun so far?

Jastor also supports arrays of a certain type:

	// JSON
	{
		"name": "Foo",
		"categories": [
			{ "name": "Bar Category 1" },
			{ "name": "Bar Category 2" },
			{ "name": "Bar Category 3" }
		]
	}

	// ProductCategory.h
	@interface ProductCategory : Jastor
	@property (nonatomic, copy) NSString *name;
	@end

	// ProductCategory.m
	@implementation ProductCategory
	@synthesize name;
	@end

	// Product.h
	@interface Product : Jastor
	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, retain) NSArray *categories;
	@end

	// Product.m
	@implementation Product
	@synthesize name, categories;

	+ (Class)categories_class {
		return [ProductCategory class];
	}
	@end


	// Code
	NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
	Product *product = [[Product alloc] initWithDictionary:dictionary];

	// Log
	product.name // => Foo
	product.categories // => <NSArray>
	[product.categories count] // => 3
	[product.categories objectAtIndex:1] // => <ProductCategory>
	[[product.categories objectAtIndex:1] name] // => Bar Category 2


Notice the declaration of 

	+ (Class)categories_class {
		return [ProductCategory class];
	}

it tells Jastor what class of items the array holds.


Nested + Arrays = Trees
---
Jastor can handle trees of data:


	// JSON
	{
		"name": "1",
		"children": [
			{ "name": "1.1" },
			{ "name": "1.2",
			  children: [
				{ "name": "1.2.1",
				  children: [
					{ "name": "1.2.1.1" },
					{ "name": "1.2.1.2" },
				  ]
				},
				{ "name": "1.2.2" },
			  ]
			},
			{ "name": "1.3" }
		]
	}

	// ProductCategory.h
	@interface ProductCategory : Jastor
	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, retain) NSArray *children;
	@end

	// ProductCategory.m
	@implementation ProductCategory
	@synthesize name, children;

	+ (Class)children_class {
		return [ProductCategory class];
	}
	@end


	// Code
	NSDictionary *dictionary = /* parse the JSON response to a dictionary */;
	ProductCategory *category = [[ProductCategory alloc] initWithDictionary:dictionary];

	// Log
	category.name // => 1
	category.children // => <NSArray>
	[category.children count] // => 3
	[category.children objectAtIndex:1] // => <ProductCategory>
	[[category.categories objectAtIndex:1] name] // => 1.2

	[[[category.children objectAtIndex:1] children] objectAtIndex:0] // => <ProductCategory>
	[[[[category.children objectAtIndex:1] children] objectAtIndex:0] name] // => 1.2.1.2


How does it work?
---
Runtime API. The class's properties are read in runtime and assigns all values from dictionary to these properties with `NSObject setValue:forKey:`. For Dictionaries, Jastor instantiates a new class, based on the property type, and issues another `initWithDictionary`. Arrays are only a list of items such as strings (which are not converted) or dictionaries (which are treated the same as other dictionaries).

Installation
---
Just copy Jastor.m+.h and JastorRuntimeHelper.m+.h to your project, create a class, inherit, use the `initWithDictionary` and enjoy!


REALLY Good to know
---

**Where's the dealloc in the inheritor classes?**

`dealloc` is implemented in the base class and it nilifies all properties.


**What about properties that are reserved words?**

As for now, `id` is converted to `objectId` automatically. Maybe someday Jastor will have ability to map server and obj-c fields.

**Jastor classes also conforms to NSCoding protocol**

So you get `initWithCoder`/`encodeWithCoder` for free.

**You can look at the tests for real samples**.

**Created by** [@elado](http://twitter.com/elado)


Alternatives
---

* [KVCObjectMapping](https://github.com/tuyennguyencanada/KVCObjectMapping)
* [ManagedJastor](https://github.com/patternoia/ManagedJastor) - for `NSManageObject`s
* [RestKit](http://restkit.org/)