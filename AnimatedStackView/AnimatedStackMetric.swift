import UIKit

/// Defines how the views should be displayed and how
/// they should be animated into view.
public protocol AnimatedStackMetric {
  var alpha: CGFloat { get }
  var transform: CATransform3D { get }
  func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect
}

public struct DefaultActiveMetric: AnimatedStackMetric {
  public let alpha: CGFloat
  public let transform: CATransform3D
  
  public func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds
  }
  
  public init() {
    self.alpha = 1
    self.transform = CATransform3DIdentity
  }
}

public struct DefaultLeadingMetric: AnimatedStackMetric {
  public let alpha: CGFloat
  public let transform: CATransform3D
  
  public func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds.offsetBy(dx: 0, dy: -stackViewBounds.height)
  }
  
  public init() {
    self.alpha = 0
    self.transform = CATransform3DIdentity
  }
}

public struct DefaultTrailingMetric: AnimatedStackMetric {
  public let alpha: CGFloat
  public let transform: CATransform3D
  
  public func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds.offsetBy(dx: 0, dy: stackViewBounds.height)
  }
  
  public init() {
    self.alpha = 0
    self.transform = CATransform3DIdentity
  }
}
