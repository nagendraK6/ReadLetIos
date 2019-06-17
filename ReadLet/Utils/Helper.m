//
//  Helper.m
//  ReadLet
//
//  Created by Nagendra on 6/16/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "Helper.h"

@implementation Helper
+ (BOOL)validateEmailWithString:(NSString*)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
