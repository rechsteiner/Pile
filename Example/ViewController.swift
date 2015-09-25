import UIKit
import AnimatedStackView

func rotationTransform(angle: Double) -> CATransform3D {
  var perspective = CATransform3DIdentity
  perspective.m34 = 1.0 / -1000
  let rotation = CATransform3DMakeRotation(CGFloat(angle), 0, 1, 0)
  return CATransform3DConcat(perspective, rotation)
}

struct CustomActiveMetric: AnimatedStackMetric {
  let alpha: CGFloat = 1
  let transform = rotationTransform(0)

  func frame(view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds
  }
}

struct CustomLeadingMetric: AnimatedStackMetric {
  let alpha: CGFloat = 0
  let transform = rotationTransform(M_PI_2)

  func frame(view: UIView, stackViewBounds: CGRect) -> CGRect {
    return CGRectOffset(stackViewBounds, stackViewBounds.height, 0)
  }
}

struct CustomTrailingMetric: AnimatedStackMetric {
  let alpha: CGFloat = 0
  let transform = rotationTransform(-M_PI_2)

  func frame(view: UIView, stackViewBounds: CGRect) -> CGRect {
    return CGRectOffset(stackViewBounds, -stackViewBounds.height, 0)
  }
}

struct CustomAnimationMetric: AnimationMetric {
  let duration: CFTimeInterval = 1.5
  let delay: CFTimeInterval = 0
  let damping: CGFloat = 0.5
  let initialVelocity: CGFloat = 0
  let options = UIViewAnimationOptions.BeginFromCurrentState
}

class ViewController: UIViewController {

  let titles = ["Contacts", "Videoes", "Pictures", "Activity"]
  let firstStackView: AnimatedStackView
  let secondStackView: AnimatedStackView
  var currentSliderValue: Float = 0
  @IBOutlet var containerView: UIView!

  required init?(coder: NSCoder) {

    self.firstStackView = AnimatedStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    self.secondStackView = AnimatedStackView(frame: CGRect(x: 0, y: 70, width: 100, height: 30),
      activeMetric: CustomActiveMetric(),
      leadingMetric: CustomLeadingMetric(),
      trailingMetric: CustomTrailingMetric(),
      animationMetric: CustomAnimationMetric())

    super.init(coder: coder)

  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.containerView.addSubview(self.firstStackView)
    self.containerView.addSubview(self.secondStackView)

    let firstTitleLabel = self.createTitleLabel("Hi")
    let secondTitleLabel = self.createTitleLabel("Hi")

    self.firstStackView.push(firstTitleLabel, animated: false)
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
