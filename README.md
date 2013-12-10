LLReactiveMatchers
=================

[![Build Status](https://travis-ci.org/lawrencelomax/LLReactiveMatchers.png)](https://travis-ci.org/lawrencelomax/LLReactiveMatchers)

[Expecta matchers](https://github.com/specta/expecta) for [ReactiveCocoa](https://github.com/reactiveCocoa/reactivecocoa)


## Introduction
ReactiveCocoa is awesome. However, Unit-Testing Signals can be cumbersome. This set of custom matchers for Expecta is meant to help make writing tests significantly easier, and far easier to read. By performing expectations on Signals themselves, you will not have to explicitly subscribe to to write Unit Tests for the events that they send.

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

Matchers will also ensure that certain conditions are met. For example, when comparing the output of two Signals with the ```haveIdenticalEvents()``` matcher, the matcher will not pass until the Signal has ended in completion or error. In other words, two Signals do not have the same output until their lifecycle is completed.
    

## Matchers
```expect`

## Components
```LLSignalTestProxy``` receives all of the values, errors and completion that a Signal will send. All Matchers are built on top of this class, as it essentially acts like a ```RACReplaySubject``` of unlimited capacity, but with accessors for the events themselves. A proxy is eas


    

## [License](./LICENSE)