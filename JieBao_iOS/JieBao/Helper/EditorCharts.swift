//
//  EditorCharts.swift
//  ChartDemo
//
//  Created by zhoucan on 2016/12/19.
//  Copyright © 2016年 verfing. All rights reserved.
//

import UIKit

class EditorCharts: UIView {

    fileprivate var xValue:Array<Int>? //x轴
    var yValue:Array<CGFloat>?
    
    
    //闭包回调
    var callBackYValueArray:((_ yValue:Array<CGFloat>?)->())?
    
    fileprivate var maxHeight:CGFloat? //最高
    
    fileprivate let maxYValue:CGFloat = 100.0 //y轴最大值
    
    fileprivate var space:CGFloat? //x轴间隔
    
     var isChangeShowCircle:Bool = false//是否改变圆圈显示
    
    fileprivate var  isShowCircle = false //是否显示圆圈
    
    fileprivate var hasDrawCircle:Bool = false //只画一次
    
    var lineColor:UIColor = UIColor.orange //折线颜色
    
    fileprivate var ySpace:CGFloat? //y轴间隔
    
//    var tapTag:Int = 0
    
    let mainColor = UIColor.init(red: 235/255.0, green:  235/255.0, blue:  235/255.0, alpha: 1.0)
    let tColor = UIColor.init(red: 185/255.0, green:  185/255.0, blue:  185/255.0, alpha: 1.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        //x轴
        xValue = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
        
        //最大值
        self.maxHeight = frame.size.height
        //
        self.space = (frame.size.width - 20)/CGFloat(((xValue?.count)! - 1))
        
        self.ySpace = frame.size.height / 7.0
        
//        self.maxYValue = self.maxYValue / ySpace!
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        
        //是否显示圆圈
        if isChangeShowCircle {
        
            //先删除所有子视图
            for item in self.subviews {
                item.removeFromSuperview() //移除子视图
            }
            
            hasDrawCircle = false
            isChangeShowCircle = false
        }
        
       
        
        drawXYline() //画x,y
        
        drawValue()//画折现
        
        
        if hasDrawCircle == false {
            //是否重新添加lables
            
             hasDrawCircle = true
            for value in self.xValue! {
                
                
                let index = self.xValue?.index(of: value)
                //因为0点就是24点，最后一个数据不用管，直接return
                if index! != self.xValue!.count - 1{
                
                
                let circleLabel = UILabel.init(frame: CGRect.init(x:0, y: 0, width: 20, height: 20))
                circleLabel.center = CGPoint.init(x: 20 + CGFloat(self.xValue![index!]) * space!, y: ((1-(self.yValue![index!])/self.maxYValue)) * self.maxHeight!)
                circleLabel.layer.cornerRadius = 10
                circleLabel.layer.masksToBounds = true
                circleLabel.tag = 1000 + index!
                circleLabel.isUserInteractionEnabled = true
                circleLabel.backgroundColor = lineColor
                self.addSubview(circleLabel)
                    
                }
            }
            
           
        }
        
        
    }
    
    
    
    
  fileprivate  func drawValue()  {
        
        let path = UIBezierPath.init()
        lineColor.set()
        path.lineWidth = 1.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        let startPoint = CGPoint.init(x: 20 + CGFloat(self.xValue!.first!) * space!, y: ((1-(self.yValue!.first!)/self.maxYValue)) * self.maxHeight!)
        path.move(to: startPoint)
        
        for xValue  in self.xValue! {
            //index
            let index = self.xValue?.index(of: xValue)
            
            if index! == self.xValue!.count - 1 {return}
            
            
            
            if index! > 0 {
                //连线
                 let nextPoint = CGPoint.init(x: 20 + CGFloat(self.xValue![index!]) * space!, y: ((1-(self.yValue![index!])/self.maxYValue)) * self.maxHeight!)
                   path.addLine(to: nextPoint)
                   path.stroke()
            }
            
        }
        
        
        
        
//        for value in self.yValue! {
//            let index = self.yValue?.index(of: value)
//            let point = CGPoint.init(x: CGFloat((self.xValue?[index!])!) * space!, y: (value))
//            path.addLine(to: point)
//            path.stroke()
//        }
        
        
        
    }
   fileprivate func drawXYline()  {
        let path = UIBezierPath.init()
        mainColor.set()
        path.lineWidth = 1.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        for xvalue in self.xValue! {
          let index = self.xValue?.index(of: xvalue)
          let point1 = CGPoint.init(x: 20 + CGFloat(xvalue) * space!, y: 0)
          let point2 = CGPoint.init(x: 20 + CGFloat(xvalue) * space!, y: self.maxHeight!)
          path.move(to: point1)
          path.addLine(to: point2)
          path.stroke()
            
           let xlabel = UILabel.init(frame: CGRect.init(origin: CGPoint.init(x:20 + CGFloat(xvalue) * space!, y: self.maxHeight! + 5), size: CGSize.init(width: space!, height: 10)))
            let text = String(describing: self.xValue![index!])
            
            xlabel.text = text
            if index! == self.xValue!.count - 1 {
                xlabel.text = text + "h"
            }
            
            
            xlabel.font = UIFont.systemFont(ofSize: 11)
            xlabel.textColor = tColor
            self.addSubview(xlabel)
        }
        
        
        var yIndex = 8
        var index = 0
        while yIndex > 0 {
            
            
           
           let point1 = CGPoint.init(x: 20, y: ySpace! * CGFloat(yIndex-1))
            let point2 = CGPoint.init(x: frame.size.width, y: ySpace! * CGFloat(yIndex-1))
            
            path.move(to: point1)
            path.addLine(to: point2)
            path.stroke()

            
            //这里的xlabel是y值
            let xlabel = UILabel.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y:ySpace! * CGFloat(yIndex-1)), size: CGSize.init(width: 15, height: 10)))
            let text = String(describing: (5 * index))
            xlabel.textAlignment = .right
            xlabel.center = CGPoint.init(x: 0, y: ySpace! * CGFloat(yIndex-1))
            
            if yIndex != 8 {
                xlabel.text = text

            }
            
            
            xlabel.font = UIFont.systemFont(ofSize: 11)
            xlabel.textColor = tColor
            self.addSubview(xlabel)
            
            yIndex -= 1
            index  += 1
        }
        
    }
    

    
    
}


extension EditorCharts {
    
   open func showCircle(isShow:Bool)  {
        
        self.isShowCircle = isShow
        self.isChangeShowCircle = true
        self.setNeedsDisplay() //绘制
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touche = touches.first {
            let label = touche.view
            if (label?.isKind(of: UILabel.classForCoder()))! {
                //找到触摸的点
                let labels:UILabel = label as! UILabel
                
                let point  = touche.location(in: labels)
                
                //point y 范围【0-self.maxHeight】
                
                let tag = labels.tag - 1000 //对应数组下标
                
                var hv:CGFloat = 0.0
                
                
                
                if labels.center.y + point.y < 0 {
                    labels.center.y = 0
                    hv = maxYValue
                    
                }

                if labels.center.y + point.y >  self.maxHeight! {
                    labels.center.y = self.maxHeight!
                      hv = 0.0
                }

                if (labels.center.y + point.y) > 0 && (labels.center.y + point.y) < self.maxHeight! {
                     labels.center.y = labels.center.y + point.y
                     hv = maxYValue * (1-(labels.center.y/self.maxHeight!))
                    
                }
                
               print(hv)
               self.yValue?.remove(at: tag)
               self.yValue?.insert(hv, at: tag)
               
                
                
            }
            
            
        }

        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.setNeedsDisplay()
         callBackYValueArray!(yValue) //回调编辑后的yValue数组
    }
    
}


