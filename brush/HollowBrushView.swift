import UIKit

class HollowBrushView: UIView {
    
    // Properties
    private var brushPath: UIBezierPath!
    private var brushLayer: CAShapeLayer!
    private var brushWidth: CGFloat!
    private var brushColor: UIColor!
    private var lastPoint: CGPoint!
    private var previousPoint: CGPoint!
    private var touch: UITouch!
    private var touchForce: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        brushPath = UIBezierPath()
        brushLayer = CAShapeLayer()
        brushWidth = 35
        brushColor = .red
        layer.addSublayer(brushLayer)
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first
        lastPoint = touch.location(in: self)
        previousPoint = lastPoint
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first
        touchForce = touch.force / touch.maximumPossibleForce
        if (touchForce == 0) {
            touchForce=0.4;
        }
        let currentPoint = touch.location(in: self)
        let brushSize = brushWidth * touchForce
        
        brushPath.move(to: previousPoint)
        brushPath.addLine(to: currentPoint)
        
        let midPoint = midPointForPoints(p1: lastPoint, p2: currentPoint)
        let controlPoint = controlPointForPoints(p1: midPoint, p2: previousPoint)
        brushPath.addQuadCurve(to: midPoint, controlPoint: controlPoint)
        
        brushLayer.fillColor = UIColor.clear.cgColor
        brushLayer.strokeColor = brushColor.cgColor
        brushLayer.lineWidth = brushSize
        brushLayer.shadowOpacity = 0.8
        brushLayer.shadowRadius = 3
        brushLayer.shadowOffset = CGSize(width: 2, height: 2)
        brushLayer.path = brushPath.cgPath
        brushLayer.frame = bounds
        
        previousPoint = currentPoint
        lastPoint = currentPoint
    }
    
    private func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    private func controlPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var controlPoint = midPointForPoints(p1: p1, p2: p2)
        let diffY = abs(p2.y - controlPoint.y)
        
        if p1.y < p2.y {
            controlPoint.y += diffY
        } else if p1.y > p2.y {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        brushPath.removeAllPoints()
        brushLayer.path = brushPath.cgPath
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
}
