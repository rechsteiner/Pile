import UIKit

/// Defines how the views should be displayed and how
/// they should be animated into view.
public struct AnimatedStackMetric {
  public let alpha: CGFloat
  public let transform: CATransform3D
  public let frame: CGRect
  
  public init(alpha: CGFloat, transform: CATransform3D, frame: CGRect) {
    self.alpha = alpha
    self.transform = transform
    self.frame = frame
  }
}
