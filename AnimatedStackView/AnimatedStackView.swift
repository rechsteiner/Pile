import UIKit

public class AnimatedStackView: UIView {

  var stack = [UIView]()
  var removalStack = [UIView]()
  
  let activeMetric: AnimatedStackMetric
  let leadingMetric: AnimatedStackMetric
  let trailingMetric: AnimatedStackMetric
  let animationMetric: AnimationMetric

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

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func push(view: UIView, animated animate: Bool = true) {

    if let lastView = self.stack.last {
      self.removalStack.append(lastView)
      self.updateView(lastView,
        fromMetric: self.activeMetric,
        toMetric: self.trailingMetric,
        animated: animate) { _ in
        self.handleAnimationCallback()
      }
    }

    self.addSubview(view)
    self.stack.append(view)
    self.updateView(view,
      fromMetric: self.leadingMetric,
      toMetric: self.activeMetric,
      animated: animate,
      completion: nil
    )
  }

  public func pop(animated animate: Bool = true) {

    if self.stack.count > 1 {

      let lastView = self.stack.removeLast()
      self.removalStack.append(lastView)
      self.updateView(lastView,
        fromMetric: self.activeMetric,
        toMetric: self.leadingMetric,
        animated:  animate) { _ in
          self.handleAnimationCallback()
      }

      if let newLastView = self.stack.last {
        self.addSubview(newLastView)
        self.updateView(newLastView,
          fromMetric: self.trailingMetric,
          toMetric: self.activeMetric,
          animated:  animate,
          completion: nil)
      }

    }
  }

  public func setViews(views: [UIView]) {
    let lastView = self.stack.last
    lastView?.removeFromSuperview()
    self.stack = views
    if let lastItem = self.stack.last {
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
    if self.stack.count > 0 {
      let lastItem = self.stack.removeLast()
      lastItem.removeFromSuperview()
      self.stack.append(view)
      self.addSubview(view)
      self.updateView(view,
        fromMetric: self.leadingMetric,
        toMetric: self.activeMetric,
        animated: false,
        completion: nil
      )
    }
  }
  
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
    view.frame = metric.frame(view, stackViewBounds: self.bounds)
    view.alpha = metric.alpha
    view.layer.transform = metric.transform
  }
  
}
