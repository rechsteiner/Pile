import UIKit

/// Defines how the views should be displayed and how
/// they should be animated into view.
public protocol AnimatedStackMetric {
  var alpha: CGFloat { get }
  var transform: CATransform3D { get }
  func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect
}

struct DefaultActiveMetric: AnimatedStackMetric {
  let alpha: CGFloat = 1
  let transform = CATransform3DIdentity
  
  func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds
  }
}

struct DefaultLeadingMetric: AnimatedStackMetric {
  let alpha: CGFloat = 0
  let transform = CATransform3DIdentity
  
  func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds.offsetBy(dx: 0, dy: -stackViewBounds.height)
  }
}

struct DefaultTrailingMetric: AnimatedStackMetric {
  let alpha: CGFloat = 0
  let transform = CATransform3DIdentity
  
  func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds.offsetBy(dx: 0, dy: stackViewBounds.height)
  }
}
