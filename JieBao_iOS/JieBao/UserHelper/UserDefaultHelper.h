
#import <Foundation/Foundation.h>

#pragma mark - Helper

void UserDefaultSynchronize();

void UserDefaultRemoveKey(NSString *key);

void UserDefaultRegister(NSDictionary *defaultDictionary);

NSDictionary *UserDefaultAllValue();

void UserDefaultClearAllExcept(NSArray *keys);

void UserDefaultClearAll();


#pragma mark - Getter

id UserDefaultObject(NSString *key);

NSString *UserDefaultString(NSString *key);

NSArray *UserDefaultArray(NSString *key);

NSDictionary *UserDefaultDictionary(NSString *key);

NSData *UserDefaultData(NSString *key);

NSArray *UserDefaultStringArray(NSString *key);

NSInteger UserDefaultInteger(NSString *key);

float UserDefaultFloat(NSString *key);

double UserDefaultDouble(NSString *key);

BOOL UserDefaultBool(NSString *key);

NSURL *UserDefaultURL(NSString *key);


#pragma mark - Setter

void SetUserDefaultInteger(NSString *key, NSInteger value);

void SetUserDefaultFloat(NSString *key, float value);

void SetUserDefaultDouble(NSString *key, double value);

void SetUserDefaultBool(NSString *key, BOOL value);

void SetUserDefaultURL(NSString *key, NSURL *value);

void SetUserDefaultObject(NSString *key, id value);

void SetUserDefaultMutableArray(NSString *key,NSMutableArray *value);
