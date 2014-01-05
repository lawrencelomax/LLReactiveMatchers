//
//  EXPExpect+LLReactiveMatchersExtensions.h
//  LLReactiveMatchers
//
//  Created by Lawrence Lomax on 5/01/2014.
//
//

#import "EXPExpect.h"

@interface EXPExpect (LLReactiveMatchersExtensions)

@property (nonatomic) BOOL continuousAsync;

@property (nonatomic, readonly) EXPExpect *willContinueTo;
@property (nonatomic, readonly) EXPExpect *willNotContinueTo;

@end
