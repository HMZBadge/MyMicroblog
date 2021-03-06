//
//  HMZBaseTableViewController.swift
//  MyMicroblog
//
//  Created by 赵志丹 on 15/12/12.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

import UIKit

class HMZBaseTableViewController: UITableViewController,HMZVisitorLoginViewDelegate {
    
    /// 用户登录标识
    var userLoginState =  HMZUserAccountViewModel.shareViewModel.userLoginState
    
    var visitorLoginView: HMZVisitorLoginView?
    
    override func loadView() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSuccess:", name: HMZSwitchRootVCNotificationKey, object: nil)
        
        if userLoginState {
            //登录成功 跳到首页
            super.loadView()
        }else{
            //未登录  跳到访客视图
            setupVisitorLoginView()
        }
    }
    
    ///  解决登陆成功后,访客视图还在,加载网络完成后 reloadData时,因为不是UITableView,造成的程序崩溃.
    @objc private func loginSuccess(n: NSNotification) {
        let stateStr = n.object as? String
        print("loginState =" + (stateStr ?? ""))
        if let state = stateStr where state == "loginSuccess" {
            view = UITableView()
        }
    }
    
    
    func setupVisitorLoginView(){
        visitorLoginView = HMZVisitorLoginView()
        
        view = visitorLoginView
        
        //设置代理
        visitorLoginView?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: "userWillLogin")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: "userWillRegister")
    }
    
   func userWillLogin() {
        let nav = UINavigationController(rootViewController: HMZOAuthViewController())
        //一般像登录,注册这类的和程序的主题框架不同的控制器,要Modal出来.
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func userWillRegister() {
        print(__FUNCTION__)
    }
    
    

}
