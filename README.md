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

Matchers will accept a ```RACSignal```s as the actual object. ```LLSignalTestRecorder```s as the actual object, allowing the values that a Signal sends to be received before matching. This can be an important distinction as ```RACReplaySubject```s are greedy and will send their events in the order that they were sent.

The matchers will also ensure that dependent conditions are also met. For example, when comparing that the output of two Signals is identical with the ```sendEvents()```, the matcher will not be able to know that both Signals are identical until they have both finished sending values.

Using a matcher with a Signal as the actual value will cause the Signal passed through to be subscribed to. Further expectations using the matchers will result in additional subscriptions. This encourages the usage of [Cold Signals](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md#connections), as well as Signals having [repeatable results](http://en.wikipedia.org/wiki/Referential_transparency_(computer_science)).

## Examples

- ```RACReplaySubject``` example
- ```RACSubject `

## Matchers
    
    expect(signal).to.complete();   //Succeeds if 'signal' completes before matching.
    expect(signal).to.error(); //Succeeds if 'signal' errors before matching.
    expect(signal).to.finish(); //Succeeds if 'signal' completes or errors before matching.
    expect(signal).to.matchValue(matchIndex, matchBlock); //Succeeds if 'matchBlock' returns YES from 'matchIndex' provided.
    expect(signal).to.matchValues(matchBlock);  //Succeeds if 'matchBlock' returns YES for all values that 'signal' sends.
    expect(signal).to.sendError(expectedError);  //Succeeds if 'signal' sends an error that is equal to 'expectedError'. 'expectedError' can be an NSError, RACSignal or LLSignalTestRecorder.
    expect(signal).to.sendEvents(expectedEvents);  //Succeeds if 'signal' and 'expectedSignal' send exactly the same events including next values. 'expectedEvents' can be a RACSignal or LLSignalTestRecorder.
    expect(signal).to.sendValues(expectedValues);  //Succeeds if 'signal' exactly sends all of the values in 'expectedValues' and then finishes. 'expectedValues' can be a RACSignal, LLSignalTestRecorder or an NSArray of expected values. 
    expect(signal).to.sendValuesWithCount(expectedCount);  //Succeeds if 'signal' sends exactly the number of events of 'expectedCounts', waits for 'signal' to finish.

## Tips

- Keep Signals Cold
- Use ```RACReplaySubject``` to declare the sequence of events before matching
- If you have a Signal that does not have repeatable results by design and you need to test multiple behaviours, multicast it, or subscribe to it with a ```RACReplaySubject``` then add matchers to the result
- Async testing isn't completely working yet

## Todo
- Sort out async
- Injecting mocks for testing side effects

## [License](./LICENSE)