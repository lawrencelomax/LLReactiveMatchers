LLReactiveMatchers
=================

[![Build Status](https://travis-ci.org/lawrencelomax/LLReactiveMatchers.png)](https://travis-ci.org/lawrencelomax/LLReactiveMatchers)

[Expecta matchers](https://github.com/specta/expecta) for [ReactiveCocoa](https://github.com/reactiveCocoa/reactivecocoa)


## Introduction
ReactiveCocoa is awesome. However, Unit-Testing Signals can be cumbersome. This set of custom matchers for Expecta exists to help make writing tests significantly easier to write and understand. By performing expectations on Signals directly, you will not have to write subscription code to find out about the events they send.

To test that a particular error is received without matcher:
    
    NSError *expectedError = ...;
    NSError *receivedError = nil;
    [signal subscribeError:^(NSError *error){
        receivedError = error;
    }];
    
    expect(expectedError).to.equal(receivedError);
    
Can be changed to this:

    NSError *expectedError = ...;
    expect(signal).to.sendError(expectedError);

The matchers will also ensure that certain conditions dependent for the matcher to succeed are met. For example, when comparing the output of two Signals with the ```haveIdenticalEvents()``` matcher, the matcher will not pass until the Signal has ended in completion or error. In other words, two Signals do not have the same output until we know that the lifecycle is completed.

Using a matcher will cause the Signal to be subscribed to, successive calls to create match Signals will result in further subscription to the Signal. This encourages the usage of [Cold Signals](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md#connections), as well as Signals having [repeatable results](http://en.wikipedia.org/wiki/Idempotence#Computer_science_meaning).

## Matchers
    
    expect(signal).to.complete();   //Succeeds if 'signal' completes before matching
    expect(signal).to.finish(); //Succeeds if 'signal' completes or errors before matching
    expect(signal).to.haveIdenticalEvents(expectedSignal);  //Succeeds if 'signal' and 'expectedSignal' send exactly the same events
    expect(signal).to.haveIdenticalErrors(expectedSignal);  //Succeeds if 'signal' and 'expectedSignal' both send errors that are equal
    expect(signal).to.haveIdenticalValues(expectedSignal);  //Succeeds if 'signal' and 'expectedSignal' both send the same next events in the same order
    expect(signal).to.sendError(expectedError);  //Succeeds if 'signal' sends an error that is equal to 'expectedError'
    expect(signal).to.sendValues(@[ @1, @2 ]);  //Succeeds if 'signal' sends the values in the array. Ordering and additional values do not effect success
    expect(signal).to.sendValuesWithCount(4);  //Succeeds if 'signal' sends exactly 4 next events
    

## Tips

- Keep Signals Cold
- Use ```RACReplaySubject``` to declare the sequence of events before matching
- Async testing isn't completely working yet

## [License](./LICENSE)