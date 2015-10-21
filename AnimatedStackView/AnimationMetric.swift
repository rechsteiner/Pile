import UIKit

/// Defines the configuration details for the animation block
public protocol AnimationMetric {
  var duration: CFTimeInterval { get }
  var delay: CFTimeInterval { get }
  var damping: CGFloat { get }
  var initialVelocity: CGFloat { get }
  var options: UIViewAnimationOptions { get }
}

struct DefaultAnimationMetric: AnimationMetric {
  let duration: CFTimeInterval = 0.6
  let delay: CFTimeInterval = 0
  let damping: CGFloat = 0.6
  let initialVelocity: CGFloat = 0
  let options = UIViewAnimationOptions.BeginFromCurrentState
}
