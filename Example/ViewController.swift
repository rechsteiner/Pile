import UIKit
import AnimatedStackView

func rotationTransform(angle: Double) -> CATransform3D {
  var perspective = CATransform3DIdentity
  perspective.m34 = 1.0 / -1000
  let rotation = CATransform3DMakeRotation(CGFloat(angle), 0, 1, 0)
  return CATransform3DConcat(perspective, rotation)
}

struct CustomAnimationMetric: AnimationMetric {
  let duration: CFTimeInterval = 1
  let delay: CFTimeInterval = 0
  let damping: CGFloat = 0.8
  let initialVelocity: CGFloat = 0
  let options = UIViewAnimationOptions.BeginFromCurrentState
}

class ViewController: UIViewController {

  let titles = ["Tokyo", "New York", "Sao Paulo", "Seoul"]
  let firstStackView: AnimatedStackView
  let secondStackView: AnimatedStackView
  var currentSliderValue: Float = 0
  @IBOutlet var containerView: UIView!

  required init?(coder: NSCoder) {

    self.firstStackView = AnimatedStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    self.secondStackView = AnimatedStackView(
      frame: CGRect(x: 0, y: 70, width: 100, height: 30),
      animationMetric: CustomAnimationMetric())
    
    super.init(coder: coder)

    self.secondStackView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.containerView.addSubview(self.firstStackView)
    self.containerView.addSubview(self.secondStackView)

    let firstTitleLabel = self.createTitleLabel(titles.first!)
    let secondTitleLabel = self.createTitleLabel(titles.first!)

    self.firstStackView.push(firstTitleLabel)
    self.secondStackView.push(secondTitleLabel, animated: false)

  }

  @IBAction func push(sender: AnyObject) {
    let randomIndex = Int(arc4random_uniform(UInt32(self.titles.count)))
    let firstTitleLabel = self.createTitleLabel(self.titles[randomIndex])
    let secondTitleLabel = self.createTitleLabel(self.titles[randomIndex])
    self.firstStackView.push(firstTitleLabel)
    self.secondStackView.push(secondTitleLabel)
  }

  @IBAction func pop(sender: AnyObject) {
    self.firstStackView.pop()
    self.secondStackView.pop()
  }

  @IBAction func handleSliderUpdate(slider: UISlider) {
    if slider.value > 0.5 && currentSliderValue <= 0.5 {
      self.push(self)
      self.currentSliderValue = slider.value
    } else if slider.value <= 0.5 && currentSliderValue > 0.5 {
      self.pop(self)
      self.currentSliderValue = slider.value
    }
  }

  private func createTitleLabel(title: String) -> UILabel {
    let titleLabel = UILabel(frame: .zero)
    titleLabel.textAlignment = .Center
    titleLabel.font = UIFont.boldSystemFontOfSize(15)
    titleLabel.textColor = UIColor.whiteColor()
    titleLabel.text = title
    return titleLabel
  }

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
}

extension ViewController: AnimatedStackViewDelegate {
  
  func animatedStackView(animatedStackView: AnimatedStackView,
    activeMetricForView: UIView) -> AnimatedStackMetric {
    return AnimatedStackMetric(
      alpha: 1,
      transform: rotationTransform(0),
      frame: animatedStackView.bounds)
  }
  
  func animatedStackView(animatedStackView: AnimatedStackView,
    leadingMetricForView: UIView) -> AnimatedStackMetric {
    return AnimatedStackMetric(
      alpha: 0,
      transform: rotationTransform(M_PI_2),
      frame: animatedStackView.bounds.offsetBy(dx: animatedStackView.bounds.midX, dy: 0))
  }
  
  func animatedStackView(animatedStackView: AnimatedStackView,
    trailingMetricForView: UIView) -> AnimatedStackMetric {
    return AnimatedStackMetric(
      alpha: 0,
      transform: rotationTransform(-M_PI_2),
      frame: animatedStackView.bounds.offsetBy(dx: -animatedStackView.bounds.midX, dy: 0))
  }
  
}
