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

The matchers will also ensure that dependent conditions are also met. For example, when comparing the output of two Signals with the ```haveIdenticalEvents()``` matcher, the matcher will not be able to pass until both signals have ended.

Using a matcher will result in the Signal passed through to be subscribed to. Further expectations using the matchers will result in additional subscriptions. This encourages the usage of [Cold Signals](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/Documentation/FrameworkOverview.md#connections), as well as Signals having [repeatable results](http://en.wikipedia.org/wiki/Referential_transparency_(computer_science)).

## Examples

Occasionally, you may not be able to use a ```RACReplaySubject``` because the ordering of events in a composed signal is important. In these cases you can provide ```LLSignalTestRecorder```

## Matchers
    
    expect(signal).to.complete();   //Succeeds if 'signal' completes before matching
    expect(signal).to.error(); //Succeeds if 'signal' errors before matching
    expect(signal).to.finish(); //Succeeds if 'signal' completes or errors before matching
    expect(signal).to.haveIdenticalEvents(expectedSignal);  //Succeeds if 'signal' and 'expectedSignal' send exactly the same events
    expect(signal).to.haveIdenticalErrors(expectedSignal);  //Succeeds if 'signal' and 'expectedSignal' both send errors that are equal
    expect(signal).to.haveIdenticalValues(expectedSignal);  //Succeeds if 'signal' and 'expectedSignal' both send the same next events in the same order
    expect(signal).to.sendError(expectedError);  //Succeeds if 'signal' sends an error that is equal to 'expectedError'
    expect(signal).to.sendValues( @[@1, @2] );  //Succeeds if 'signal' sends the values in the array. Ordering and additional values in the expected Signal do not effect success
    expect(signal).to.sendValuesWithCount(4);  //Succeeds if 'signal' sends exactly 4 next events
    expect(signal).to.sendValuesIdentically( @[@1, @2] );   //Succeeds if values sent in 'signal' is identical to the array
    

## Tips

- Keep Signals Cold
- Use ```RACReplaySubject``` to declare the sequence of events before matching
- If you have a Signal that does not have repeatable results by design and you need to test multiple behaviours, multicast it, or subscribe to it with a ```RACReplaySubject``` then add matchers to the result
- Async testing isn't completely working yet

## Todo
- Sort out async
- Injecting mocks for testing side effects

## [License](./LICENSE)