import UIKit

/// Defines the configuration details for the animation block
public protocol AnimationMetric {
  var duration: CFTimeInterval { get }
  var delay: CFTimeInterval { get }
  var damping: CGFloat { get }
  var initialVelocity: CGFloat { get }
  var options: UIViewAnimationOptions { get }
}

public struct DefaultAnimationMetric: AnimationMetric {
  public let duration: CFTimeInterval
  public let delay: CFTimeInterval
  public let damping: CGFloat
  public let initialVelocity: CGFloat
  public let options: UIViewAnimationOptions
  
  public init() {
    self.duration = 0.6
    self.delay = 0
    self.damping = 0.6
    self.initialVelocity = 0
    self.options = .beginFromCurrentState
  }
}
