//
//  ViewController.swift
//  SliderCollectionView
//
//  Created by Nick luo on 2018/12/15.
//  Copyright © 2018 Nick luo. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate {
    
    var titleArray:[String] = ["苹果","香蕉","草莓","葡萄"]
   
    var topWidth:CGFloat = 80
    
     var selectIndex:Int = 0
    
    //collection约束
    lazy var collectionViewLayou: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0 //左右间隔
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    //collection
    lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 44)
        let collection = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayou)
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.alwaysBounceHorizontal = true
        collection.backgroundColor = UIColor.clear
        collection.register(SliderCollectionViewCells.self, forCellWithReuseIdentifier: "SliderCollectionViewCells")
        return collection
    }()
    
    
    /// 顶部分割线
    lazy var topView: UIView = {
        let frame = CGRect(x: 0, y: 64 - 0.5, width: UIScreen.main.bounds.size.width, height: 0.5)
        let view = UIView.init(frame: frame)
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    //指示线
    lazy var indicatorView: UIView = {
        let frame = CGRect(x: 0, y: 44 - 4 + 0.5, width: self.topWidth, height: 3)
        let view = UIView.init(frame: frame)
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    /// 底部分割线
    lazy var bottomView: UIView = {
        let frame = CGRect(x: 0, y: 64 + 44, width: UIScreen.main.bounds.size.width, height: 0.5)
        let view = UIView.init(frame: frame)
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    //视图容器
    lazy var sliderView: UIScrollView = {
        let frame = CGRect(x: 0, y: self.collectionView.frame.maxY + 0.5, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - self.collectionView.frame.maxY)
        let view = UIScrollView.init(frame: frame)
        view.backgroundColor = UIColor.white
        view.delegate = self
        view.isPagingEnabled = true
        view.bounces = false
        view.contentSize = CGSize.init(width: UIScreen.main.bounds.size.width * CGFloat(self.titleArray.count), height: UIScreen.main.bounds.size.height)
        view.showsHorizontalScrollIndicator = false

        return view
    }()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.titleArray.count < 4{
            self.topWidth = UIScreen.main.bounds.size.width/CGFloat(self.titleArray.count)
        }
        
        self.view.addSubview(self.topView)
        self.view.addSubview(self.bottomView)
        
        self.view.addSubview(self.self.collectionView)
        self.collectionView.addSubview(self.indicatorView)
        self.view.addSubview(self.sliderView)
        
        
        
        if self.titleArray.count > 0 {
            
            for (i,_) in self.titleArray.enumerated(){
                let vc:UIViewController = UIViewController()
                var newframe = vc.view.frame
                newframe.size.height = self.sliderView.frame.height
                newframe.origin.x = newframe.origin.x + (CGFloat(i) * self.sliderView.frame.width)
                newframe.origin.y = 0
                vc.view.frame = newframe
                
                self.addChild(vc)
                vc.didMove(toParent: self)
                
                if i == 2{
                    vc.view.backgroundColor = UIColor.gray
                }
                self.sliderView.addSubview(vc.view)
            }
        }
        
        
        
        
        if self.selectIndex > 0{
            
            self.silderWithIndex(index: self.selectIndex, isNeed: false)
            
        }
    
    }
    
    
    func silderWithIndex(index:Int,isNeed:Bool){

        self.selectIndex = index
        
        UIView.animate(withDuration: 0.3) {
            var newFrame = self.indicatorView.frame
            newFrame.origin.x = self.topWidth * CGFloat(index)
            self.indicatorView.frame = newFrame
        }
        
        if isNeed{
            self.collectionView.scrollToItem(at: NSIndexPath.init(row: index, section: 0) as IndexPath, at: .centeredHorizontally, animated: true)
        }else{
            self.sliderView.setContentOffset(CGPoint.init(x: UIScreen.main.bounds.size.width * CGFloat(index), y: 0), animated: true)
        }
        
        self.collectionView.reloadData()
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / UIScreen.main.bounds.size.width)
        
        if index != self.selectIndex{
            self.silderWithIndex(index: index, isNeed: true)
        }
    }
    
    
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCells", for: indexPath) as! SliderCollectionViewCells
        
        let label = UILabel.init(frame: CGRect(x: self.topWidth-0.5, y: 0, width: 0.5, height: cell.frame.height - 0.5))
        label.backgroundColor = UIColor.lightGray
        cell.insertSubview(label, at: cell.subviews.count - 1)
        
        
        cell.titleLable.text = self.titleArray[indexPath.row]
        

        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        self.silderWithIndex(index: indexPath.row, isNeed: false)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.topWidth, height: 44)
    }
    
}



