//
//  Loader.swift
//  Samokat
//
//  Created by Daniyar on 7/14/20.
//  Copyright © 2020 MTI. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SpinnerView: UIView {
    static var isLoading = false
    static var spinnerView = SpinnerView()
    static var circleView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "circle")
        let spinner = SpinnerView()
        view.addSubview(spinner)
        spinner.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.size.equalTo(StaticSize.size(44))
        })
        return view
    }()
    
    static var view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let circleView: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named: "circle")
            let spinner = SpinnerView()
            view.addSubview(spinner)
            spinner.snp.makeConstraints({
                $0.center.equalToSuperview()
                $0.size.equalTo(StaticSize.size(44))
            })
            return view
        }()
        view.addSubview(circleView)
        circleView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.size.equalTo(StaticSize.size(60))
        })
        return view
    }()
    
    static func showSpinnerView(view: UIView? = nil){
        if let view = view{
            view.showSpinnerViewCenter()
        } else if let vc = UIApplication.topViewController() {
            vc.view.showSpinnerViewFull()
        }
    }
    
    static func removeSpinnerView(){
        SpinnerView.view.removeFromSuperview()
        SpinnerView.circleView.removeFromSuperview()
    }
    
    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.customPurple.cgColor
        layer.lineWidth = 3
        setPath()
    }

    override func didMoveToWindow() {
        animate()
    }

    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }

    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }

    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7),
            ]
        }
    }

    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }

        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }

        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)
    }

    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
}
