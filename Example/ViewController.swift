import UIKit
import AnimatedStackView

func rotationTransform(_ angle: Double) -> CATransform3D {
  var perspective = CATransform3DIdentity
  perspective.m34 = 1.0 / -1000
  let rotation = CATransform3DMakeRotation(CGFloat(angle), 0, 1, 0)
  return CATransform3DConcat(perspective, rotation)
}

struct CustomActiveMetric: AnimatedStackMetric {
  let alpha: CGFloat = 1
  let transform = rotationTransform(0)

  func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds
  }
}

struct CustomLeadingMetric: AnimatedStackMetric {
  let alpha: CGFloat = 0
  let transform = rotationTransform(.pi / 2)

  func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds.offsetBy(dx: stackViewBounds.midX, dy: 0)
  }
}

struct CustomTrailingMetric: AnimatedStackMetric {
  let alpha: CGFloat = 0
  let transform = rotationTransform(-.pi / 2)

  func frame(_ view: UIView, stackViewBounds: CGRect) -> CGRect {
    return stackViewBounds.offsetBy(dx: -stackViewBounds.midX, dy: 0)
  }
}

struct CustomAnimationMetric: AnimationMetric {
  let duration: CFTimeInterval = 1
  let delay: CFTimeInterval = 0
  let damping: CGFloat = 0.8
  let initialVelocity: CGFloat = 0
  let options = UIViewAnimationOptions.beginFromCurrentState
}

class ViewController: UIViewController {

  let titles = ["Tokyo", "New York", "Sao Paulo", "Seoul"]
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

    let firstTitleLabel = self.createTitleLabel(titles.first!)
    let secondTitleLabel = self.createTitleLabel(titles.first!)

    self.firstStackView.push(firstTitleLabel)
    self.secondStackView.push(secondTitleLabel, animated: false)

  }

  @IBAction func push(_ sender: AnyObject) {
    let randomIndex = Int(arc4random_uniform(UInt32(self.titles.count)))
    let firstTitleLabel = self.createTitleLabel(self.titles[randomIndex])
    let secondTitleLabel = self.createTitleLabel(self.titles[randomIndex])
    self.firstStackView.push(firstTitleLabel)
    self.secondStackView.push(secondTitleLabel)
  }

  @IBAction func pop(_ sender: AnyObject) {
    self.firstStackView.pop()
    self.secondStackView.pop()
  }

  @IBAction func handleSliderUpdate(_ slider: UISlider) {
    if slider.value > 0.5 && currentSliderValue <= 0.5 {
      self.push(self)
      self.currentSliderValue = slider.value
    } else if slider.value <= 0.5 && currentSliderValue > 0.5 {
      self.pop(self)
      self.currentSliderValue = slider.value
    }
  }

  fileprivate func createTitleLabel(_ title: String) -> UILabel {
    let titleLabel = UILabel(frame: .zero)
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
    titleLabel.textColor = UIColor.white
    titleLabel.text = title
    return titleLabel
  }

  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
  
}
