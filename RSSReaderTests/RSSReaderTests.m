//
//  RSSReaderTests.m
//  RSSReaderTests
//
//  Created by mdomans on 17.03.2014.
//  Copyright (c) 2014 mdomans. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>

SPEC_BEGIN(MathSpec)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 17;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(43)];
    });
});

SPEC_END
