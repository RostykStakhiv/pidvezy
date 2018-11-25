
import UIKit

@IBDesignable class IBDesignableControl: UIControl {
    
    var viewToDraw: UIView!
    
    func xibSetup() {
        viewToDraw = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        viewToDraw.frame = bounds
        
        // Make the view stretch with containing view
        viewToDraw.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.addSubview(viewToDraw)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
}
