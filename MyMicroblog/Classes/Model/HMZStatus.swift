//
//  HMZStatus.swift
//  MyMicroblog
//
//  Created by 赵志丹 on 15/12/14.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

import UIKit

class HMZStatus: NSObject {
    /// 微博Id
    var id: Int = 0
    /// 字符串型的微博ID
    var idstr: String?
    /// 微博信息内容
    var text: String?
    
    /// 微博创建时间
    var created_at: String?
    /// 微博来源
    var source: String?
    /// 微博作者的用户信息字段 详细
    var user: HMZUser?
    /// 转发数
    var reposts_count:Int = 0
    ///	int	评论数
    var comments_count:Int = 0
    ///	表态数
    var attitudes_count:Int = 0
    
    
    /// 临时处理微博配图的计算属性
    var imageURLs: [NSURL]?
    ///  pic_ids	微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
    var pic_urls: [[String: String]]? {
        didSet {
            guard let urls = pic_urls else{
                return
            }
            imageURLs = [NSURL]()
            for item in urls {
                let urlString = item["thumbnail_pic"]
                let largeString = urlString?.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
                let url = NSURL(string: largeString!)!
                imageURLs?.append(url)
            }
        }
    }
    
    /// 这才是微博配图真正要用的属性,他是原创微博的配图 或者 是转发微博的配图, 只能是其一
    var pictureURLs: [NSURL]?{
        if retweeted_status != nil {
            return retweeted_status?.imageURLs
        }
        return imageURLs
    }
    
    /// 被转发的原微博信息字段，当该微博为转发微博时返回 详细
    var retweeted_status: HMZStatus?
    
    
    /// KVC初始化
    init(dict: [String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
            if let dict = value as? [String: AnyObject] {
                user = HMZUser(dict: dict)
                return
            }
        }else if key == "retweeted_status" {
            if let dict = value as? [String: AnyObject] {
                retweeted_status = HMZStatus(dict: dict)
                return
            }
        }
        
        //一定要注意 需要调用super  ,原因是,当上面两个条件都不满足时,继续走下面的为其他 key 赋值
        super.setValue(value, forKey: key)
    }
    
    ///  过滤不需要的字段
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
    override var description: String {
        let keys = ["created_at", "text", "idstr", "source"]
        return dictionaryWithValuesForKeys(keys).description
    }
    
    /**
    created_at	string	微博创建时间
    id	int64	微博ID
    mid	int64	微博MID
    idstr	string	字符串型的微博ID
    text	string	微博信息内容
    source	string	微博来源
    favorited	boolean	是否已收藏，true：是，false：否
    truncated	boolean	是否被截断，true：是，false：否
    in_reply_to_status_id	string	（暂未支持）回复ID
    in_reply_to_user_id	string	（暂未支持）回复人UID
    in_reply_to_screen_name	string	（暂未支持）回复人昵称
    thumbnail_pic	string	缩略图片地址，没有时不返回此字段
    bmiddle_pic	string	中等尺寸图片地址，没有时不返回此字段
    original_pic	string	原始图片地址，没有时不返回此字段
    geo	object	地理信息字段 详细
    user	object	微博作者的用户信息字段 详细
    retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细
    reposts_count	int	转发数
    comments_count	int	评论数
    attitudes_count	int	表态数
    mlevel	int	暂未支持
    visible	object	微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号
    pic_ids	object	微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
    ad	object array	微博流内的推广微博ID
    
    */
    
    
}