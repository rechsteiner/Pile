<p align="center">
  <img src="https://s3.eu-central-1.amazonaws.com/rechsteiner-pile/da132057-5d56-4ed2-8654-7838d09910b0.png" width="280" height="115" />
</p>

<p align="center">
    <strong><a href=“#usage”>Usage</a></strong> |
    <strong><a href="#customization">Customization</a></strong> |
    <strong><a href="#installation">Installation</a></strong>
</p>

<p align="center">
    <a href="https://circleci.com/gh/rechsteiner/Pile"><img src="https://circleci.com/gh/rechsteiner/Pile/tree/master.svg?style=shield&circle-token=56b16884f50f6a72873c786dc936c5c59c4ea160" /></a>
    <a href="https://cocoapods.org/pods/Pile"><img src="https://img.shields.io/cocoapods/v/Pile.svg" /></a>
    <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg" /></a>
</p>

<br/>

A tiny library for pushing and popping `UIView`s using your own custom animations. You can push and pop any views onto the stack and the framework will animate between the them by using the properties you've defined. You can animate between the `frame`, `transform` and `alpha`.

## Usage

To get started you need to initialize a new `PileView`:

```Swift
let view = PileView(frame: .zero)
```

Then you can push any `UIView` onto the stack and it will animate it into view:

```Swift
stackView.push(view)
```

To get back to the previous view, just call:

```Swift
stackView.pop()
```

## Customization

You can completly customize the animation by defining you own metrics. `PileView` takes four parameters for customization: the `activeMetric`, `leadingMetric`, `trailingMetric` and `animationMetric`.

When pushing a view, it will apply `leadingMetric` to that view and animate it to `activeMetric`. When popping, it will animate from `activeMetric` to `trailingMetric`. These metrics must all conform to the `PileMetric` protocol:

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

Then initialize the `PileView` with those metrics:

```Swift
let view = PileView(frame: .zero,
      activeMetric: CustomActiveMetric(),
      leadingMetric: CustomLeadingMetric(),
      trailingMetric: CustomTrailingMetric(),
      animationMetric: CustomAnimationMetric())
```

Download the project and run the Example target to see it in action.

## Installation

Pile will be compatible with the lastest public release of Swift.

### [CocoaPods](https://cocoapods.org)

Add the following line to your Podfile and run `pod install`:

```
pod Pile', '~> 0.2.2'
```

### [Carthage](https://github.com/Carthage/Carthage)

Add the following to your `Cartfile`:

```
github "rechsteiner/Pile"  
```

Then you need to:

1. Run `carthage update`
2. Link `Pile.framework` with you target
3. Add `$(SRCROOT)/Carthage/Build/iOS/Pile.framework` to your
   `copy-frameworks` script phase

See [this guide](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) for more details on using Carthage.

## Requirements

* iOS 8.0+
* Xcode 8.0+

## Licence

Parchment is released under the MIT license. See LICENSE for details.
