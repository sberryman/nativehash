/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComShaunberrymanNativehashModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation ComShaunberrymanNativehashModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"d48d84f2-c056-42af-856e-7366daafb3e8";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.shaunberryman.nativehash";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma Public APIs

-(NSString*)md5:(id)args {
    NSString* inputString = [TiUtils stringValue:[args objectAtIndex:0]];
    NSData* inputData = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* result = [[HashValue md5HashWithData:inputData] description];
    return result;
}

-(NSString*)sha256:(id)args {
    NSString* inputString = [TiUtils stringValue:[args objectAtIndex:0]];
    NSData* inputData = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* result = [[HashValue sha256HashWithData:inputData] description];
    return result;
}

-(NSArray*)hashContacts:(id)args {
    CFArrayRef ABAddressBookCopyArrayOfAllPeople (ABAddressBookRef addressBook);
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    // array of hashes
    NSMutableArray *contactHashes = [[NSMutableArray alloc] initWithCapacity:3000];
    int contactIndex = 0;
    
    // go through ALL the people in the address book
    for( int i = 0 ; i < nPeople ; i++ )
    {
        ABRecordRef person = (ABRecordRef*)CFArrayGetValueAtIndex(allPeople, i );
        ABMultiValueRef phoneNumbers = (ABMultiValueRef)ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(int p = 0; p < ABMultiValueGetCount(phoneNumbers); p++)
        {   
            NSData* inputData = [[self cleanPhoneNumberString:(NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, p)] dataUsingEncoding:NSUTF8StringEncoding];
            NSString* valueHashed = [[HashValue sha256HashWithData:inputData] description];
            
            // add to the array
            [contactHashes addObject: valueHashed];
            
            // bump the index
            contactIndex++;
        }
        CFRelease(phoneNumbers);
        
        // get the email addresses
        ABMultiValueRef emailAddresses = (ABMultiValueRef)ABRecordCopyValue(person, kABPersonEmailProperty);
        for(int p = 0; p < ABMultiValueGetCount(emailAddresses); p++)
        {   
            NSData* inputData = [(NSString*)ABMultiValueCopyValueAtIndex(emailAddresses, p) dataUsingEncoding:NSUTF8StringEncoding];
            NSString* valueHashed = [[HashValue sha256HashWithData:inputData] description];
            
            // add to the array
            [contactHashes addObject: valueHashed];
            
            // bump the index
            contactIndex++;
        }
        CFRelease(emailAddresses);
    }
    
    // relase our references
    CFRelease(addressBook);
    CFRelease(allPeople);
    
    // return our array!
    return [NSArray arrayWithArray:contactHashes];
}

-(NSString*) cleanPhoneNumberString:(NSString*) input
{
    NSString *output = @"";
    for (int i=0; i<[input length]; i++) {
        if (isdigit([input characterAtIndex:i])) {
            output=   [output  stringByAppendingFormat:@"%c",[input characterAtIndex:i]];
        }
    }
    
    return  output;
}


@end
