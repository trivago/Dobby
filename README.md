# Dobby

Dobby provides a few helpers for mocking and stubbing using expectations.

## Expectations

Expectations can be matched with values, serving as the fundamental building block for mocking and stubbing. There are many functions that help creating expectations for (equatable) types, including tuples, arrays, and dictionaries with equatable elements:

```swift
matches { $0 == value } // matches value
any() // matches anything
equals(1) // matches 1
equals((1, 2)) // matches (1, 2)
equals((1, 2, 3)) // matches (1, 2, 3)
equals((1, 2, 3, 4)) // matches (1, 2, 3, 4)
equals((1, 2, 3, 4, 5)) // matches (1, 2, 3, 4, 5)
equals([1, 2, 3]) // matches [1, 2, 3]
equals([1: 1, 2: 2, 3: 3]) // matches [1: 1, 2: 2, 3: 3]
```

Expectations may also be nested:

```swift
matches((matches { $0 == 0 }, any(), 2)) // matches (0, _, 2)
matches([any(), equals(4)]) // matches [_, 4]
matches(["key": matches { $0 == 5 }]) // matches ["key": 5]
```

## Mocks

Mocks can be used to verify that all set up expectations are matched with the recorded interactions. Verification is performed in order and all expectations must match an interaction and vice versa:

```swift
let mock = Mock<[Int]>()
mock.expect(matches([any(), matches { $0 > 0 }])) // expects [_, n > 0]
mock.record([0, 1])
mock.verify() // succeeds
```

## Stubs

Stubs, when invoked, return a value based on their set up behavior, or, if an interaction is unexpected, throw an error. Behavior is matched in order, i.e., the function or return value associated with the first expectation that matches an interaction is invoked/returned:

```swift
let stub = Stub<(Int, Int), Int>()
let behavior = stub.on(equals((4, 3)), returnValue: 9)
stub.on(matches((any(), any()))) { $0.0 + $0.1 }
try! stub.invoke((4, 3)) // returns 9
try! stub.invoke((4, 4)) // returns 8
```

Behavior may also be disposed:

```swift
behavior.dispose()
try! stub.invoke((4, 3)) // returns 7
```

## Example

> to be written..

## Documentation

Please check out the [source](https://github.com/rheinfabrik/Dobby/tree/swift-2.0/Dobby) and [tests](https://github.com/rheinfabrik/Dobby/tree/swift-2.0/DobbyTests) for further documentation.

## About

Dobby was built at [Rheinfabrik](http://www.rheinfabrik.de) 🏭
