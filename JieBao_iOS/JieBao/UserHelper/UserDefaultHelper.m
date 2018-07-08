

#import "UserDefaultHelper.h"

#define StandardUserDefault     [NSUserDefaults standardUserDefaults]

#pragma mark - Helper

void UserDefaultSynchronize()
{
    [StandardUserDefault synchronize];
}

void UserDefaultRemoveKey(NSString *key)
{
    [StandardUserDefault removeObjectForKey:key];
}

void UserDefaultRegister(NSDictionary *defaultDictionary)
{
    [StandardUserDefault registerDefaults:defaultDictionary];
}

NSDictionary *UserDefaultAllValue()
{
    return [StandardUserDefault dictionaryRepresentation];
}

void UserDefaultClearAllExcept(NSArray *keys)
{
    NSDictionary *dict = UserDefaultAllValue();
    for (id key in dict) {
        if ([keys containsObject:key])
            continue;
        [StandardUserDefault removeObjectForKey:key];
    }
    UserDefaultSynchronize();
}

void UserDefaultClearAll()
{
    UserDefaultClearAllExcept(nil);
}

#pragma mark - Getter

id UserDefaultObject(NSString *key)
{
    return [StandardUserDefault objectForKey:key];
}

NSString *UserDefaultString(NSString *key)
{
    return [StandardUserDefault stringForKey:key];
}

NSArray *UserDefaultArray(NSString *key)
{
    return [StandardUserDefault arrayForKey:key];
}

NSDictionary *UserDefaultDictionary(NSString *key)
{
    return [StandardUserDefault dictionaryForKey:key];
}

NSData *UserDefaultData(NSString *key)
{
    return [StandardUserDefault dataForKey:key];
}

NSArray *UserDefaultStringArray(NSString *key)
{
    return [StandardUserDefault stringArrayForKey:key];
}

NSInteger UserDefaultInteger(NSString *key)
{
    return [StandardUserDefault integerForKey:key];
}

float UserDefaultFloat(NSString *key)
{
    return [StandardUserDefault floatForKey:key];
}

double UserDefaultDouble(NSString *key)
{
    return [StandardUserDefault doubleForKey:key];
}

BOOL UserDefaultBool(NSString *key)
{
    return [StandardUserDefault boolForKey:key];
}

NSURL *UserDefaultURL(NSString *key)
{
    return [StandardUserDefault URLForKey:key];
}


#pragma mark - Setter

void SetUserDefaultInteger(NSString *key, NSInteger value)
{
    [StandardUserDefault setInteger:value forKey:key];
    UserDefaultSynchronize();
}

void SetUserDefaultFloat(NSString *key, float value)
{
    [StandardUserDefault setFloat:value forKey:key];
    UserDefaultSynchronize();
}

void SetUserDefaultDouble(NSString *key, double value)
{
    [StandardUserDefault setDouble:value forKey:key];
    UserDefaultSynchronize();
}

void SetUserDefaultBool(NSString *key, BOOL value)
{
    [StandardUserDefault setBool:value forKey:key];
    UserDefaultSynchronize();
}

void SetUserDefaultURL(NSString *key, NSURL *value)
{
    [StandardUserDefault setURL:value forKey:key];
    UserDefaultSynchronize();
}

void SetUserDefaultObject(NSString *key, id value)
{
    [StandardUserDefault setObject:value forKey:key];
    UserDefaultSynchronize();
}

