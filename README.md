# Pile

<a href="https://circleci.com/gh/rechsteiner/Pile"><img src="https://circleci.com/gh/rechsteiner/Pile/tree/master.svg?style=shield&circle-token=56b16884f50f6a72873c786dc936c5c59c4ea160" /></a>
<a href="https://cocoapods.org/pods/Pile"><img src="https://img.shields.io/cocoapods/v/Pile.svg" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg" /></a>

A tiny library for pushing and popping `UIView`s using your own custom animations. You can push and pop any views onto the stack and the framework will animate between the them by using the properties you've defined. You can animate between the `frame`, `transform` and `alpha`.

## Usage

To get started, just initialize the stack view like you would with any `UIView`:

```Swift
let stackView = PileView(frame: .zero)
```

Then push any `UIView` onto the stack and it will animate it into view:

```Swift
stackView.push(view)
```

To get back to the previous view, just call:

```Swift
stackView.pop()
```

## Customization

You can completly customize the animation by defining you own metrics. The stack view takes four parameters for customization: the `activeMetric`, `leadingMetric`, `trailingMetric` and `animationMetric`.

When pushing a view, it will apply `leadingMetric` to that view and animate it to `activeMetric`. When popping, it will animate from `activeMetric` to `trailingMetric`. These metrics must all conform to the `PileMetric`:

```Swift
public protocol PileMetric {
  var alpha: CGFloat { get }
  var transform: CATransform3D { get }
  func frame(view: UIView, stackViewBounds: CGRect) -> CGRect
}
```

The `animationMetric` defines the options for the `UIView` animation block:

```Swift
public protocol PileAnimationMetric {
  var duration: CFTimeInterval { get }
  var delay: CFTimeInterval { get }
  var damping: CGFloat { get }
  var initialVelocity: CGFloat { get }
  var options: UIViewAnimationOptions { get }
}
```

## Example

Here's an example that flips in views horizontally to either side:

```Swift
func rotationTransform(angle: Double) -> CATransform3D {
  var perspective = CATransform3DIdentity
  perspective.m34 = 1.0 / -1000
  let rotation = CATransform3DMakeRotation(CGFloat(angle), 0, 1, 0)
  return CATransform3DConcat(perspective, rotation)
}

struct CustomActiveMetric: PileMetric {
  let alpha: CGFloat = 1
  let transform = rotationTransform(0)

  func frame(view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds
  }
}

struct CustomLeadingMetric: PileMetric {
  let alpha: CGFloat = 0
  let transform = rotationTransform(M_PI_2)

  func frame(view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds.offsetBy(dx: stackViewBounds.midX, dy: 0)
  }
}

struct CustomTrailingMetric: PileMetric {
  let alpha: CGFloat = 0
  let transform = rotationTransform(-M_PI_2)

  func frame(view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds.offsetBy(dx: -stackViewBounds.midX, dy: 0)
  }
}

struct CustomAnimationMetric: PileAnimationMetric {
  let duration: CFTimeInterval = 1
  let delay: CFTimeInterval = 0
  let damping: CGFloat = 0.8
  let initialVelocity: CGFloat = 0
  let options = UIViewAnimationOptions.BeginFromCurrentState
}
```

Then just initialize the stack view with those metrics:

```Swift
let view = PileView(frame: .zero,
      activeMetric: CustomActiveMetric(),
      leadingMetric: CustomLeadingMetric(),
      trailingMetric: CustomTrailingMetric(),
      animationMetric: CustomAnimationMetric())
```

Download the project and run the Example target to see it in action.

## Install

### [Carthage](https://github.com/carthage/carthage)

Add the following line into your Carfile and run `carthage update`:

```
github "rechsteiner/Pile"
```

### [CocoaPods](https://cocoapods.org)

Add the following line to your Podfile and run `pod install`:

```
pod Pile', '~> 0.1.0'
```
