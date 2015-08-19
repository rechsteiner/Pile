import UIKit

public protocol AnimationMetric {
  var duration: CFTimeInterval { get }
  var delay: CFTimeInterval { get }
  var damping: CGFloat { get }
  var initialVelocity: CGFloat { get }
  var options: UIViewAnimationOptions { get }
}

public protocol AnimatedStackMetric {
  var alpha: CGFloat { get }
  var transform: CATransform3D { get }
  func frame(bounds: CGRect) -> CGRect
}

struct DefaultAnimationMetric: AnimationMetric {
  let duration: CFTimeInterval = 0.6
  let delay: CFTimeInterval = 0
  let damping: CGFloat = 0.6
  let initialVelocity: CGFloat = 0
  let options = UIViewAnimationOptions.BeginFromCurrentState
}

struct DefaultActiveMetric: AnimatedStackMetric {
  let alpha: CGFloat = 1
  let transform = CATransform3DIdentity

  func frame(bounds: CGRect) -> CGRect {
    return bounds
  }
}

struct DefaultLeadingMetric: AnimatedStackMetric {
  let alpha: CGFloat = 0
  let transform = CATransform3DIdentity

  func frame(bounds: CGRect) -> CGRect {
    return CGRectOffset(bounds, 0, -bounds.height)
  }
}

struct DefaultTrailingMetric: AnimatedStackMetric {
  let alpha: CGFloat = 0
  let transform = CATransform3DIdentity

  func frame(bounds: CGRect) -> CGRect {
    return CGRectOffset(bounds, 0, bounds.height)
  }
}

public class AnimatedStackView: UIView {

  private var items = [UIView]()
  private var viewToBeRemoved: UIView?
  private let activeMetric: AnimatedStackMetric
  private let leadingMetric: AnimatedStackMetric
  private let trailingMetric: AnimatedStackMetric
  private let animationMetric: AnimationMetric

  public init(frame: CGRect,
    activeMetric: AnimatedStackMetric = DefaultActiveMetric(),
    leadingMetric: AnimatedStackMetric = DefaultLeadingMetric(),
    trailingMetric: AnimatedStackMetric = DefaultTrailingMetric(),
    animationMetric: AnimationMetric = DefaultAnimationMetric()
    ) {
      self.activeMetric = activeMetric
      self.leadingMetric = leadingMetric
      self.trailingMetric = trailingMetric
      self.animationMetric = animationMetric
      super.init(frame: frame)
  }

  required public init(coder: NSCoder) {
    self.activeMetric = DefaultActiveMetric()
    self.leadingMetric = DefaultLeadingMetric()
    self.trailingMetric = DefaultTrailingMetric()
    self.animationMetric = DefaultAnimationMetric()
    super.init(coder: coder)
  }

  public func push(view: UIView, animated: Bool = true) {

    if let lastView = self.items.last {
      self.viewToBeRemoved = lastView
      self.updateView(lastView,
        fromMetric: self.activeMetric,
        toMetric: self.trailingMetric,
        animated: animated) { completed in
          if completed {
            if let viewToBeRemoved = self.viewToBeRemoved {
              viewToBeRemoved.removeFromSuperview()
              self.viewToBeRemoved = nil
            }
          }
      }
    }

    self.addSubview(view)
    self.items.append(view)
    self.updateView(view,
      fromMetric: self.leadingMetric,
      toMetric: self.activeMetric,
      animated: animated,
      completion: nil
    )
  }

  public func pop(animated: Bool = true) {

    if self.items.count > 1 {

      let lastView = self.items.removeLast()
      self.viewToBeRemoved = lastView
      self.updateView(lastView,
        fromMetric: self.activeMetric,
        toMetric: self.leadingMetric,
        animated: animated) { completed in
          if completed {
            if let viewToBeRemoved = self.viewToBeRemoved {
              lastView.removeFromSuperview()
              self.viewToBeRemoved = nil
            }
          }
      }

      if let newLastView = self.items.last {
        self.addSubview(newLastView)
        self.updateView(newLastView,
          fromMetric: self.trailingMetric,
          toMetric: self.activeMetric,
          animated: animated,
          completion: nil)
      }

    }
  }

  public func setViews(views: [UIView]) {
    let lastView = self.items.removeLast()
    lastView.removeFromSuperview()
    self.items = views
    if let lastItem = self.items.last {
      self.addSubview(lastItem)
      self.updateView(lastItem,
        fromMetric: self.leadingMetric,
        toMetric: self.activeMetric,
        animated: false,
        completion: nil
      )
    }
  }

  public func update(view: UIView) {
    if self.items.count > 0 {
      let lastItem = self.items.removeLast()
      lastItem.removeFromSuperview()
      self.items.append(view)
      self.addSubview(view)
      self.updateView(view,
        fromMetric: self.leadingMetric,
        toMetric: self.activeMetric,
        animated: false,
        completion: nil
      )
    }
  }

  // MARK: Private

  private func updateView(view: UIView,
    fromMetric: AnimatedStackMetric,
    toMetric: AnimatedStackMetric,
    animated: Bool,
    completion: (Bool -> Void)?
    ) {

      if animated {
        self.applyMetricForView(view, metric: fromMetric)

        UIView.animateWithDuration(self.animationMetric.duration,
          delay: self.animationMetric.delay,
          usingSpringWithDamping: self.animationMetric.damping,
          initialSpringVelocity: self.animationMetric.initialVelocity,
          options: self.animationMetric.options,
          animations: {
            self.applyMetricForView(view, metric: toMetric)
          }, completion: completion)

      } else {
        self.applyMetricForView(view, metric: toMetric)
        if let completion = completion {
          completion(true)
        }
      }
  }

  private func applyMetricForView(view: UIView, metric: AnimatedStackMetric) {
    view.frame = metric.frame(self.bounds)
    view.alpha = metric.alpha
    view.layer.transform = metric.transform
  }
  
}
