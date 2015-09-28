import Foundation
import Quick
import Nimble
@testable import AnimatedStackView

class AnimatedStackViewSpec: QuickSpec {
  
  override func spec() {
    
    describe("AnimatedStackView") {
      
      var stackView: AnimatedStackView!
      let firstView = UIView(frame: .zero)
      let secondView = UIView(frame: .zero)
      
      describe("when an array of views is set") {
        
        beforeEach {
          stackView = AnimatedStackView(frame: .zero)
          stackView.setViews([firstView, secondView])
        }
        
        it("adds the views to the stack") {
          expect(stackView.stack).to(equal([firstView, secondView]))
        }
        
        it("sets the last view as the active") {
          expect(firstView.superview).to(beNil())
          expect(secondView.superview).to(equal(stackView))
        }
        
      }
      
      describe("when a view is pushed") {
        
        beforeEach {
          stackView = AnimatedStackView(frame: .zero)
          stackView.setViews([firstView])
          stackView.push(secondView)
        }
        
        it("sets the view as active") {
          expect(secondView.superview).to(equal(stackView))
          expect(stackView.stack.last).to(equal(secondView))
        }
        
        it("removes the previous view") {
          expect(stackView.removalStack).to(equal([firstView]))
          
          // Simulate animation callback
          stackView.handleAnimationCallback()
          
          expect(firstView.superview).to(beNil())
          expect(stackView.removalStack).to(equal([]))
        }
        
      }
      
      describe("when the active view gets pushed twice") {
        
        beforeEach {
          stackView = AnimatedStackView(frame: .zero)
          stackView.setViews([firstView])
          stackView.push(secondView)
          stackView.push(secondView)
        }
        
        it("sets the view as active") {
          expect(secondView.superview).to(equal(stackView))
          expect(stackView.stack.last).to(equal(secondView))
        }
        
        it("does not remove the active view") {
          expect(stackView.stack).to(equal([firstView, secondView, secondView]))
          expect(stackView.removalStack).to(equal([firstView, secondView]))
          
          // Simulate animation callback for both pushes
          stackView.handleAnimationCallback()
          stackView.handleAnimationCallback()
          
          expect(stackView.removalStack).to(equal([]))
          expect(secondView.superview).to(equal(stackView))
          expect(stackView.stack.last).to(equal(secondView))
        }
        
      }
      
      describe("when a view is popped") {
        
        beforeEach {
          stackView = AnimatedStackView(frame: .zero)
          stackView.setViews([firstView, secondView])
          stackView.pop()
        }
        
        it("sets the previous view as active") {
          expect(stackView.stack.last).to(equal(firstView))
        }
        
        it("removes the top view") {
          expect(stackView.removalStack).to(equal([secondView]))
          
          // Simulate animation callback
          stackView.handleAnimationCallback()
          
          expect(secondView.superview).to(beNil())
          expect(stackView.removalStack).to(equal([]))
        }
        
        describe("when there is one view on the stack") {
          
          beforeEach {
            stackView = AnimatedStackView(frame: .zero)
            stackView.setViews([firstView])
            stackView.pop()
          }
          
          it("does not remove the view") {
            expect(stackView.stack.count).to(equal(1))
            expect(stackView.stack.last).to(equal(firstView))
          }
          
        }
        
      }
      
      describe("when a view is updated") {
        
        beforeEach {
          stackView = AnimatedStackView(frame: .zero)
          stackView.setViews([firstView])
          stackView.update(secondView)
        }
        
        it("replaces the previous view with the new view") {
          expect(stackView.stack.count).to(equal(1))
          expect(stackView.stack.last).to(equal(secondView))
        }
        
      }
      
    }
    
  }
  
}
