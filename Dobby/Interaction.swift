//  Copyright (c) 2015 Rheinfabrik. All rights reserved.

import Foundation

public struct Interaction0: Equatable {

}

public struct Interaction1<A: Equatable>: Equatable {
    public let arg0: Argument<A>
}

public struct Interaction2<A: Equatable, B: Equatable>: Equatable {
    public let arg0: Argument<A>
    public let arg1: Argument<B>
}

public struct Interaction3<A: Equatable, B: Equatable, C: Equatable>: Equatable {
    public let arg0: Argument<A>
    public let arg1: Argument<B>
    public let arg2: Argument<C>
}

public struct Interaction4<A: Equatable, B: Equatable, C: Equatable, D: Equatable>: Equatable {
    public let arg0: Argument<A>
    public let arg1: Argument<B>
    public let arg2: Argument<C>
    public let arg3: Argument<D>
}

public struct Interaction5<A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable>: Equatable {
    public let arg0: Argument<A>
    public let arg1: Argument<B>
    public let arg2: Argument<C>
    public let arg3: Argument<D>
    public let arg4: Argument<E>
}

// MARK: - Equality

public func == (lhs: Interaction0, rhs: Interaction0) -> Bool {
    return true
}

public func == <A: Equatable>(lhs: Interaction1<A>, rhs: Interaction1<A>) -> Bool {
    return lhs.arg0 == rhs.arg0
}

public func == <A: Equatable, B: Equatable>(lhs: Interaction2<A, B>, rhs: Interaction2<A, B>) -> Bool {
    return lhs.arg0 == rhs.arg0 && lhs.arg1 == rhs.arg1
}

public func == <A: Equatable, B: Equatable, C: Equatable>(lhs: Interaction3<A, B, C>, rhs: Interaction3<A, B, C>) -> Bool {
    return lhs.arg0 == rhs.arg0 && lhs.arg1 == rhs.arg1 && lhs.arg2 == rhs.arg2
}

public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable>(lhs: Interaction4<A, B, C, D>, rhs: Interaction4<A, B, C, D>) -> Bool {
    return lhs.arg0 == rhs.arg0 && lhs.arg1 == rhs.arg1 && lhs.arg2 == rhs.arg2 && lhs.arg3 == rhs.arg3
}

public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable>(lhs: Interaction5<A, B, C, D, E>, rhs: Interaction5<A, B, C, D, E>) -> Bool {
    return lhs.arg0 == rhs.arg0 && lhs.arg1 == rhs.arg1 && lhs.arg2 == rhs.arg2 && lhs.arg3 == rhs.arg3 && lhs.arg4 == rhs.arg4
}

// MARK: - Basics

public func interaction() -> Interaction0 {
    return Interaction0()
}

public func interaction<A: ArgumentConvertible>(arg0: A) -> Interaction1<A.ArgumentType> {
    return Interaction1(arg0: arg0.argument())
}

public func interaction<A: ArgumentConvertible, B: ArgumentConvertible>(arg0: A, arg1: B) -> Interaction2<A.ArgumentType, B.ArgumentType> {
    return Interaction2(arg0: arg0.argument(), arg1: arg1.argument())
}

public func interaction<A: ArgumentConvertible, B: ArgumentConvertible, C: ArgumentConvertible>(arg0: A, arg1: B, arg2: C) -> Interaction3<A.ArgumentType, B.ArgumentType, C.ArgumentType> {
    return Interaction3(arg0: arg0.argument(), arg1: arg1.argument(), arg2: arg2.argument())
}

public func interaction<A: ArgumentConvertible, B: ArgumentConvertible, C: ArgumentConvertible, D: ArgumentConvertible>(arg0: A, arg1: B, arg2: C, arg3: D) -> Interaction4<A.ArgumentType, B.ArgumentType, C.ArgumentType, D.ArgumentType> {
    return Interaction4(arg0: arg0.argument(), arg1: arg1.argument(), arg2: arg2.argument(), arg3: arg3.argument())
}

public func interaction<A: ArgumentConvertible, B: ArgumentConvertible, C: ArgumentConvertible, D: ArgumentConvertible, E: ArgumentConvertible>(arg0: A, arg1: B, arg2: C, arg3: D, arg4: E) -> Interaction5<A.ArgumentType, B.ArgumentType, C.ArgumentType, D.ArgumentType, E.ArgumentType> {
    return Interaction5(arg0: arg0.argument(), arg1: arg1.argument(), arg2: arg2.argument(), arg3: arg3.argument(), arg4: arg4.argument())
}
