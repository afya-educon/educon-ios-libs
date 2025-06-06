//
//  MXScrollViewController.swift
//  MXParallaxHeader
//
//  Created by Hien Pham on 22/05/2021.
//

import UIKit

private var parallaxHeaderKey: UInt8 = 0

/**
 The MXScrollViewController class.
 */
open class MXScrollViewController: UIViewController {
    static var KVOContext = "kDMScrollViewControllerKVOContext"

    /**
     The scroll view container.
     */
    var _scrollView: MXScrollView?
    public var scrollView: MXScrollView {
        if _scrollView == nil {
            _scrollView = MXScrollView(frame: .zero)
            _scrollView?.parallaxHeader.addObserver(self,
                                                   forKeyPath:#keyPath(MXParallaxHeader.minimumHeight),
                                                   options: .new,
                                                   context: &MXScrollViewController.KVOContext)
        }
        return _scrollView!
    }

    /**
     The parallax header view controller to be added to the scroll view.
     */
    public var headerViewController: UIViewController? {
        didSet {
            if (oldValue?.parent == self) {
                oldValue?.willMove(toParent: nil)
                oldValue?.view.removeFromSuperview()
                oldValue?.removeFromParent()
                oldValue?.didMove(toParent: nil)
            }

            if let headerViewController = headerViewController {
                headerViewController.willMove(toParent: self)
                addChild(headerViewController)

                //Set parallaxHeader view
                objc_setAssociatedObject(headerViewController, &parallaxHeaderKey,
                                         scrollView.parallaxHeader, .OBJC_ASSOCIATION_RETAIN)

                scrollView.parallaxHeader.view = headerViewController.view
                headerViewController.didMove(toParent: self)
            }
        }
    }
    
    /**
     The child view controller to be added to the scroll view.
     */
    public var childViewController: UIViewController? {
        didSet {
            if oldValue?.parent == self {
                oldValue?.willMove(toParent: nil)
                oldValue?.view.removeFromSuperview()
                oldValue?.removeFromParent()
                oldValue?.didMove(toParent: nil)
            }

            if let childViewController = childViewController {
                childViewController.willMove(toParent: self)
                addChild(childViewController)

                // Set UIViewController's parallaxHeader property
                objc_setAssociatedObject(childViewController, &parallaxHeaderKey,
                                         scrollView.parallaxHeader, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

                scrollView.addSubview(childViewController.view)

                // Set child's constraints
                childViewController.view.translatesAutoresizingMaskIntoConstraints = false

                childViewController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
                childViewController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
                childViewController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

                childViewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
                childViewController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

                childHeightConstraint = childViewController.view.heightAnchor
                    .constraint(equalTo: scrollView.heightAnchor, constant: -headerMinimumHeight)
                childHeightConstraint?.isActive = true

                childViewController.didMove(toParent: self)
            }
        }
    }

    @IBOutlet public weak var headerView: UIView?
    @IBInspectable public var headerHeight: CGFloat {
        get {
            return scrollView.parallaxHeader.height
        }
        set {
            scrollView.parallaxHeader.height = newValue
        }
    }
    @IBInspectable public var headerMinimumHeight: CGFloat {
        get {
            return scrollView.parallaxHeader.minimumHeight
        }
        set {
            childHeightConstraint?.constant = -newValue
            scrollView.parallaxHeader.minimumHeight = newValue
        }
    }
    weak var childHeightConstraint: NSLayoutConstraint?
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = headerHeight
        scrollView.parallaxHeader.minimumHeight = headerMinimumHeight

        //Hack to perform segues on load
        let templates: [AnyObject] = (value(forKey: "storyboardSegueTemplates") as? [AnyObject]) ?? []
        for template in templates {
            let segueClassName = template.value(forKey: "_segueClassName") as? String
            if (segueClassName?.contains(String(describing: MXScrollViewControllerSegue.self)) ?? false) ||
                (segueClassName?.contains(String(describing: MXParallaxHeaderSegue.self)) ?? false) {
                if let identifier = template.value(forKey: "identifier") as? String {
                    performSegue(withIdentifier: identifier, sender: self)
                }
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            return
        }
        
        if automaticallyAdjustsScrollViewInsets {
            headerMinimumHeight = topLayoutGuide.length
        }
    }

    @available(iOS 11.0, *)
    open override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        if scrollView.contentInsetAdjustmentBehavior != .never {
            headerMinimumHeight = view.safeAreaInsets.top
            
            var safeAreaInset = UIEdgeInsets.zero
            safeAreaInset.bottom = view.safeAreaInsets.bottom
            childViewController?.additionalSafeAreaInsets = safeAreaInset
        }
    }
    
    /*
     *  MARK: - KVO
     */
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard context == &MXScrollViewController.KVOContext else {
            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        if childViewController != nil && keyPath == #keyPath(MXParallaxHeader.minimumHeight) {
            self.childHeightConstraint?.constant = -self.scrollView.parallaxHeader.minimumHeight;
        }
    }
    
    deinit {
        scrollView.parallaxHeader.removeObserver(self, forKeyPath: #keyPath(MXParallaxHeader.minimumHeight))
    }
}

/**
 UIViewController category to let childViewControllers easily access their parallax header.
 */
public extension UIViewController {
    /**
     The parallax header.
     */
    var parallaxHeader: MXParallaxHeader? {
        if let parallaxHeader =
            objc_getAssociatedObject(self, &parallaxHeaderKey) as? MXParallaxHeader {
            return parallaxHeader
        } else if let parent = parent {
            return parent.parallaxHeader
        }
        return nil
    }

}

/**
 The MXParallaxHeaderSegue class creates a segue object to get the parallax header view controller from storyboard.
 */
open class MXParallaxHeaderSegue : UIStoryboardSegue {
    open override func perform() {
        if let svc = source as? MXScrollViewController {
            svc.headerViewController = destination
        }
    }
}

/**
 The MXScrollViewControllerSegue class creates a segue object to get the child view controller from storyboard.
 */
open class MXScrollViewControllerSegue : UIStoryboardSegue {
    open override func perform() {
        if let svc = source as? MXScrollViewController {
            svc.childViewController = destination
        }
    }
}
