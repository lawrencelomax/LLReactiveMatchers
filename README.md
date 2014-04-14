LLReactiveMatchers
=================

[![Build Status](https://travis-ci.org/lawrencelomax/LLReactiveMatchers.png)](https://travis-ci.org/lawrencelomax/LLReactiveMatchers)

[Expecta matchers](https://github.com/specta/expecta) for [ReactiveCocoa](https://github.com/reactiveCocoa/reactivecocoa)

## TL;DR
- ```LLReactiveMatchers``` should be able to cover most of the reasons you want to test Signals.
- One matcher = One Subscription, ```n``` Matchers = ```n``` Subscriptions
- Tests that compose on top of Subjects should use ```LLSignalTestRecorder``` and expectations should be made on the recorder.

## Introduction
ReactiveCocoa is awesome. However, Unit-Testing Signals can be cumbersome. This set of custom matchers for Expecta exists to help make writing tests significantly easier to write and understand. By performing expectations on Signals directly, you will not have to write subscription code to find out about the events they send.

To test that a particular error is received without matcher:

```objc    
    NSError *expectedError = ...;
    NSError *receivedError = nil;
    [signal subscribeError:^(NSError *error){
        receivedError = error;
    }];
    
    expect(expectedError).to.equal(receivedError);
```
    
Can be changed to this:

```objc
    NSError *expectedError = ...;
    expect(signal).to.sendError(expectedError);
```
    
Matchers will accept a ```RACSignal```s as the actual object, subscribing to the Signal in order to receieve it's events. Further expectations using the matchers will result in additional subscriptions. This encourages the usage of [Cold Signals](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md#connections), as well as Signals having [repeatable results](http://en.wikipedia.org/wiki/Referential_transparency_(computer_science)).

In another case you may reason about all of the values that an asynchronous Signal sends. We want to make sure that *only* the expected values are sent. In other words that the array of values sent by the Signal and our expected array of values are equal:

```objc
    NSMutableArray *sentValues = [NSMutableArray array];
    NSArray *expected = @[@0, @1, @2];
    [signal subscribeNext:^(id value) {
        [sentValues addObject:value];
    }];
    expect(hasCompleted).will.equal(expected);
```
    
In the original test, a Mutable Array is used to contain all of the values and then tested against. However, in an asynchronous test it is possible that the Signal sends more values *after* the next value expectation has passed. For this reason, the original test requires an additional expectation that the Signal has completed:

```objc
    NSMutableArray *sentValues = [NSMutableArray array];
    NSArray *expected = @[@0, @1, @2];
    BOOL hasCompleted = NO;
    [signal subscribeNext:^(id value) {
        [sentValues addObject:value];
    } completed:^{
        hasCompleted = YES;
    }];
    expect(hasCompleted && [sentValues isEqualToArray:expected]).will.beTruthy();
```
    
Which can be changed to:
    
```objc
    expect(expectedValues).will.sendValues(@[@0, @1, @2]);
```

The Matchers in this library will ensure that dependent conditions such as the completion of a Signal are met. We can therefore reason that no additional values are sent by the Signal and have a higher degree of confidence in our tests.

## Asynchonous Testing
Though Synchronous behaviour is common in Signals and readily testable with ```to```/```toNot```, ```LLReactiveMatchers``` works great with the asynchronous ```will```/```willNot```. The only exception to this rule is asynchronous negation (```willNot```) on some asynchronous matchers.

```objc
    // This will allways pass if signal does not complete as soon as is subscribed to.
    // If the signal completes in 0.2 seconds and the async timeout is 1.0 seconds this will still pass
    expect(signal).willNot.complete();
```

Since ```willNot``` will succeed as soon as the matcher passes for the first time, a Signal that completes asynchronously will pass this test. Instead of using ```willContinueTo```/```willNotContinueTo``` can be used, as these matching methods will wait until the asynchronous timeout before matching.
    
```objc
    // This will allways pass if signal does not complete as soon as is subscribed to.
    // If the signal completes in 0.2 seconds and the async timeout is 1.0 seconds this will fail.
    expect(signal).willNotContinueTo.complete();
```

## Subjects & Replay Subjects
It is quite common to use a ```RACSubject``` or ```RACReplaySubject``` in place of a ```RACSignal``` for [testing compound operators]() where the order in which order in which events are important. For example, the tests for ```combineLatest``` use two Subjects to test that the order in which next events sent effects the output of the compound Signal. 

```objc
    __block RACSubject *subject1 = nil;
    __block RACSubject *subject2 = nil;
    __block RACSignal *combined = nil;

    beforeEach(^{
    	subject1 = [RACSubject subject];
    	subject2 = [RACSubject subject];
    	combined = [RACSignal combineLatest:@[ subject1, subject2 ]];
    });
    
    it(@"should send nexts when either signal sends multiple times", ^{
    	NSMutableArray *results = [NSMutableArray array];
    	[combined subscribeNext:^(id x) {
    		[results addObject:x];
    	}];
	
    	[subject1 sendNext:@"1"];
    	[subject2 sendNext:@"2"];
	
    	[subject1 sendNext:@"3"];
    	[subject2 sendNext:@"4"];
	
    	expect(results[0]).to.equal(RACTuplePack(@"1", @"2"));
    	expect(results[1]).to.equal(RACTuplePack(@"3", @"2"));
    	expect(results[2]).to.equal(RACTuplePack(@"3", @"4"));
    });
```

As all the matchers subscribe to Signals when the expectation is resolved, none of the events sent via Subjects will get passed through to the Signal composed with ```combineLatest```; the Subjects have sent their events before the composed Signal is subscribed to. It would be wrong to rectifty this with a ```RACReplaySubject``` to re-send events on subscription as Replay Subjects are greedy and will send all their accumilated events on subsciption. This will ignore the ordering in which events were sent by ```subject1``` and ```subject2```, essential for the behaviour we wish to test.

The matchers accept ```LLSignalTestRecorder``` in place of a Signal. By creating the ```LLSignalTestRecorder``` *before* Subjects send their values, the composed Signal will receive values sent by the Subjects. This is equivalent subscribing to subscribing to the composed Signal with a ```RACReplaySubject``` and matching against the Replay Subject.

```objc
    it(@"should send nexts when either signal sends multiple times", ^{
        LLSignalTestRecorder *recorder = [LLSignalTestRecorder recordWithSignal:signal];
        
    	[subject1 sendNext:@"1"];
    	[subject2 sendNext:@"2"];

    	[subject1 sendNext:@"3"];
    	[subject2 sendNext:@"4"];
        
    	expect(results).to.sendValue(0, RACTuplePack(@"1", @"2"));
    	expect(results).to.sendValue(1, RACTuplePack(@"3", @"2"));
    	expect(results).to.sendValue(2, RACTuplePack(@"3", @"4"));
    });
```
    
```LLSignalTestRecorder``` does provide additional conveniences over ```RACReplaySubject```. You can avoid repeated calls to create a recorder by creating the recorder up front, in a ```beforeEach``` block:

```objc
    beforeEach(^{
    	subject1 = [RACSubject subject];
    	subject2 = [RACSubject subject];
    	combined = [[RACSignal combineLatest:@[ subject1, subject2 ]] testRecorder];
    });
```
    
## Subscription Counts
Occasionally, you may need to make assertions about the number of subscriptions to a Signal, for example when describing multicasting behaviour, where repeated side-effects pose a problem. Instead of deriving a new Signal, you can mark a Signal as having it's subscription invocations counted. Use ```startCountingSubscriptions```

```objc
    RACSignal *signal = [[RACSignal sideEffectingSignal] startCountingSubscriptions];
    RACSignal *multicastingSignal = [RACSignal multicastingSignalWithSignal:signal];
    
    [multicastingSignal subscribeCompleted:^{}];
    [multicastingSignal subscribeCompleted:^{}];
    [multicastingSignal subscribeCompleted:^{}];
    
    expect(signal).to.beSubscribedTo(1);
```

## Matchers

```objc    
    expect(signal).to.beSubscribedTo(expectedCount);  //Succeeds if 'signal' sends exactly the number of events of 'expectedCounts'. Fails if startCountingSubscriptions has not been called.
    expect(signal).to.complete();   //Succeeds if 'signal' completes before matching.
    expect(signal).to.error(); //Succeeds if 'signal' errors before matching.
    expect(signal).to.finish(); //Succeeds if 'signal' completes or errors before matching.
    expect(signal).to.matchError(matchBlock); //Succeeds if 'matchBlock' returns YES from 'matchBlock' provided.
    expect(signal).to.matchValue(matchIndex, matchBlock); //Succeeds if 'matchBlock' returns YES from 'matchIndex' provided.
    expect(signal).to.matchValues(matchBlock);  //Succeeds if 'matchBlock' returns YES for all values that 'signal' sends.
    expect(signal).to.sendError(expectedError);  //Succeeds if 'signal' sends an error that is equal to 'expectedError'. 'expectedError' can be an NSError, RACSignal or LLSignalTestRecorder.
    expect(signal).to.sendEvents(expectedEvents);  //Succeeds if 'signal' and 'expectedSignal' send exactly the same events including next values. 'expectedEvents' can be a RACSignal or LLSignalTestRecorder.
    expect(signal).to.sendValue(matchIndex, expectedValue);  //Succeeds if 'signal' sends 'expectedValue' at 'matchIndex'.
    expect(signal).to.sendValues(expectedValues);  //Succeeds if 'signal' exactly sends all of the values in 'expectedValues' and then finishes. 'expectedValues' can be a RACSignal, LLSignalTestRecorder or an NSArray of expected values. 
    expect(signal).to.sendValuesWithCount(expectedCount);  //Succeeds if 'signal' sends exactly the number of events of 'expectedCounts', waits for 'signal' to finish.
```

## Todo
- Injecting Mock Objects for testing Side-Effects

## [License](./LICENSE)
