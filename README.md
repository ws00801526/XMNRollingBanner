# XMNRollingBanner
基于UICollectionView封装的无限循环滚动的BannerView


### 安装说明
----

#### 1. CocoaPods

`pod  'XMNRollingBanner'`

#### 2. 直接拖拽文件夹`XMNBanner`到工程内


### 属性说明

|属性 | 说明
| ----- |
|rollingDirection|banner滚动方向,支持水平滚动,垂直滚动|
|duration|滚动时间间隔,最低1s|
|reverseRollingDirection|是否逆向滚动|
|autoReverseRollingDirection|是否当滚动到最后条,第一条记录后 自动逆向滚动|
|currentIndex|当前index|
|images|展示的图片数组|
|placeholderImage|加载网络图片,或者未传入images显示的默认图片|
|pageControl|自定义个pageControl,默认使用UIPageControl|
|tapBlock|点击的block回调|
|loadRemoteImageBlock|加载远程图片的block|