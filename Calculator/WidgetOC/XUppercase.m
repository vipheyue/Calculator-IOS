//
//  XUppercase.m
//  Calculator
//
//  Created by YC X on 2018/1/21.
//  Copyright © 2018年 YC X. All rights reserved.
//

#import "XUppercase.h"

@interface XUppercase()
{
    NSArray *strArray1;
    NSArray *strArray2;
    NSArray *strArray3;
    NSArray *strArray4;
}

@end

@implementation XUppercase

- (NSString *)uppercaseWithNumber:(NSString *) number
{
    if (number.doubleValue == 0) {
        return @"零元整";
    }
    [self strArrayInit];
    return [NSString stringWithFormat:@"%@%@", [self convertIntergerPart:number.doubleValue], [self convertFractionalPart:number.doubleValue]];
}

- (void)strArrayInit
{
    strArray1 = [NSArray arrayWithObjects:@"", @"拾", @"佰", @"仟", nil];
    strArray2 = [NSArray arrayWithObjects:@"", @"萬", @"亿", nil];
    strArray3 = [NSArray arrayWithObjects:@"角", @"分", nil];
    strArray4 = [NSArray arrayWithObjects:@"零", @"壹", @"贰", @"叁", @"肆",  @"伍", @"陆", @"柒", @"捌", @"玖", nil];
}

- (NSString *)convertIntergerPart:(double) currentNumber
{
    long long nIntNumber = (long long)currentNumber;
    NSString *sIntNumber = @"";
    if (nIntNumber>0) {
        int nPos = 0;
        int nIndex1 = 0, nIndex2 = 0;
        int nLastNumber = 0;
        while(nIntNumber>0)
        {
            int nNumber = nIntNumber%10;
            NSString *sNumber = [strArray4 objectAtIndex:nNumber];
            if (nIndex2 >= 0 && nIndex1 == 0) {
                sIntNumber = [[strArray2 objectAtIndex:nIndex2] stringByAppendingString:sIntNumber];
            }
            if (nNumber >0) {
                sIntNumber = [[strArray1 objectAtIndex:nIndex1] stringByAppendingString:sIntNumber];//[strArray4 objectAtIndex:nNumber]];
            }
            if (!(nNumber == 0 && (nIndex1==0 || nLastNumber==0 ))) {
                sIntNumber = [sNumber stringByAppendingString:sIntNumber];//[strArray4 objectAtIndex:nNumber]];
            }
            nIntNumber = nIntNumber/10;
            nLastNumber = nNumber;
            nPos++;
            nIndex1 = nPos%4;
            nIndex2 = (nPos/4)%3;
            if (nPos>8 && nIndex2==0) {
                nIndex2++;
            }
        }
        sIntNumber = [sIntNumber stringByAppendingString:@"元"];
    }
    return sIntNumber;
}

- (NSString *)convertFractionalPart:(double) currentNumber
{
    NSString *sFloatNumber = @"";
    long long nIntNumber = (long long)currentNumber;
    float fFloatNumber = currentNumber - nIntNumber +0.001;
    int nJiao = (int)(fFloatNumber*10);
    int nFen  = (int)(fFloatNumber*100)%10;
    if (nJiao == 0 && nFen == 0) {
        sFloatNumber = @"整";
    }
    else if (nJiao == 0)
    {
        sFloatNumber = [sFloatNumber stringByAppendingString:@"零"];
        sFloatNumber = [sFloatNumber stringByAppendingString:[strArray4 objectAtIndex:nFen]];
        sFloatNumber = [sFloatNumber stringByAppendingString:@"分"];
    }
    else
    {
        sFloatNumber = [sFloatNumber stringByAppendingString:[strArray4 objectAtIndex:nJiao]];
        sFloatNumber = [sFloatNumber stringByAppendingString:@"角"];
        sFloatNumber = [sFloatNumber stringByAppendingString:[strArray4 objectAtIndex:nFen]];
        sFloatNumber = [sFloatNumber stringByAppendingString:@"分"];
    }
    return sFloatNumber;
}

@end
