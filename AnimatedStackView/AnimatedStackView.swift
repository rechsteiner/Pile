import UIKit

public protocol AnimatedStackViewDelegate: class {
  func animatedStackView(animatedStackView: AnimatedStackView, activeMetricForView: UIView) -> AnimatedStackMetric
  func animatedStackView(animatedStackView: AnimatedStackView, leadingMetricForView: UIView) -> AnimatedStackMetric
  func animatedStackView(animatedStackView: AnimatedStackView, trailingMetricForView: UIView) -> AnimatedStackMetric
}

/// AnimatedStackView allows you to transition between views
/// using your own custom animations. You can push views onto
/// the stack and the framework will animate between the
/// animation metrics defined. When the animation completes
/// it will remove any hidden views.
public class AnimatedStackView: UIView {

  var stack = [UIView]()
  var removalStack = [UIView]()
  let animationMetric: AnimationMetric
  public weak var delegate: AnimatedStackViewDelegate?

  /// Initialize a new AnimatedStackView.
  ///
  /// :param: frame The frame for the AnimatedStackView
  /// :param: animationMetric The metric for configuring animation details
  public init(frame: CGRect, animationMetric: AnimationMetric = DefaultAnimationMetric()) {
    self.animationMetric = animationMetric
    super.init(frame: frame)
    self.delegate = self
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func currentView() -> UIView? {
    return self.stack.last
  }
  
  /// Pushes a new view onto the stack. This will add the view
  /// as a subview and remove the previous view when the
  /// animation completes.
  public func push(view: UIView, animated animate: Bool = true) {
    guard let delegate = self.delegate else { return }
    
    if let lastView = self.stack.last {
      self.removalStack.append(lastView)
      self.updateView(lastView,
        fromMetric: delegate.animatedStackView(self, activeMetricForView: view),
        toMetric: delegate.animatedStackView(self, trailingMetricForView: view),
        animated: animate) { _ in
          self.handleAnimationCallback()
      }
    }
    
    self.addSubview(view)
    self.stack.append(view)
    self.updateView(view,
      fromMetric: delegate.animatedStackView(self, leadingMetricForView: view),
      toMetric: delegate.animatedStackView(self, activeMetricForView: view),
      animated: animate,
      completion: nil
    )
  }

  /// Pop the currently active view off the stack and remove
  /// it from view. Add the next available view in the stack
  /// as a subview and animate it into view.
  public func pop(animated animate: Bool = true) {
    guard let delegate = self.delegate else { return }
    
    if self.stack.count > 1 {
      
      let lastView = self.stack.removeLast()
      self.removalStack.append(lastView)
      self.updateView(lastView,
        fromMetric: delegate.animatedStackView(self, activeMetricForView: lastView),
        toMetric: delegate.animatedStackView(self, leadingMetricForView: lastView),
        animated:  animate) { _ in
          self.handleAnimationCallback()
      }
      
      if let newLastView = self.stack.last {
        self.addSubview(newLastView)
        self.updateView(newLastView,
          fromMetric: delegate.animatedStackView(self, trailingMetricForView: newLastView),
          toMetric: delegate.animatedStackView(self, activeMetricForView: newLastView),
          animated:  animate,
          completion: nil)
      }
      
    }
  }
  
  /// Replace the entire stack with a new array of views
  public func setViews(views: [UIView]) {
    guard let delegate = self.delegate else { return }
    
    let lastView = self.stack.last
    lastView?.removeFromSuperview()
    self.stack = views
    if let lastItem = self.stack.last {
      self.addSubview(lastItem)
      self.updateView(lastItem,
        fromMetric: delegate.animatedStackView(self, leadingMetricForView: lastItem),
        toMetric: delegate.animatedStackView(self, activeMetricForView: lastItem),
        animated: false,
        completion: nil
      )
    }
  }

  /// Replace the currently active view. This will remove the
  /// old view and add the new as a subview without any animation.
  public func update(view: UIView) {
    guard let delegate = self.delegate else { return }
    
    if self.stack.count > 0 {
      let lastItem = self.stack.removeLast()
      lastItem.removeFromSuperview()
      self.stack.append(view)
      self.addSubview(view)
      self.updateView(view,
        fromMetric: delegate.animatedStackView(self, leadingMetricForView: view),
        toMetric: delegate.animatedStackView(self, activeMetricForView: view),
        animated: false,
        completion: nil
      )
    }
  }
  
  override public func layoutSubviews() {
    guard let delegate = self.delegate else { return }
    super.layoutSubviews()
    if let lastView = self.stack.last {
      self.updateView(lastView,
        fromMetric: delegate.animatedStackView(self, leadingMetricForView: lastView),
        toMetric: delegate.animatedStackView(self, activeMetricForView: lastView),
        animated: false,
        completion: nil)
    }
  }
  
  // MARK: Internal
  
  func handleAnimationCallback() {
    if self.removalStack.isEmpty == false {
      let view = self.removalStack.removeFirst()
      if view != self.stack.last {
        view.removeFromSuperview()
      }
    }
  }

  func updateView(view: UIView,
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

  func applyMetricForView(view: UIView, metric: AnimatedStackMetric) {
    view.frame = metric.frame
    view.alpha = metric.alpha
    view.layer.transform = metric.transform
  }
  
}

extension AnimatedStackView: AnimatedStackViewDelegate {

  public func animatedStackView(animatedStackView: AnimatedStackView,
    activeMetricForView: UIView) -> AnimatedStackMetric {
    return AnimatedStackMetric(
      alpha: 1,
      transform: CATransform3DIdentity,
      frame: animatedStackView.bounds)
  }
  
  public func animatedStackView(animatedStackView: AnimatedStackView,
    leadingMetricForView: UIView) -> AnimatedStackMetric {
    return AnimatedStackMetric(
      alpha: 0,
      transform: CATransform3DIdentity,
      frame: animatedStackView.bounds.offsetBy(dx: 0, dy: -animatedStackView.bounds.height))
  }
  
  public func animatedStackView(animatedStackView: AnimatedStackView,
    trailingMetricForView: UIView) -> AnimatedStackMetric {
    return AnimatedStackMetric(
      alpha: 0,
      transform: CATransform3DIdentity,
      frame: animatedStackView.bounds.offsetBy(dx: 0, dy: animatedStackView.bounds.height))
  }
  
}
