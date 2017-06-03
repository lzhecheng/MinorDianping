# MinorDianping
This the final project of NJU Mobile Application 2017 Spring by Zhijian Jiang and Zhecheng Li.  

## 开发经验总结
### Core Data开发经验
#### 有用的资料
* [**（最有用）iOS Core Data with Swift 3 -- youtube**](https://www.youtube.com/watch?v=da6W7wDh0Dw)
* [Getting Started with Core Data Tutorial -- raywenderlich](https://www.raywenderlich.com/145809/getting-started-core-data-tutorial)
* [「死磕」Core Data——入门 -- 简书](http://www.jianshu.com/p/e43edd2a8be2)

#### 开发步骤
1. Step 1 创建项目
2. Step 2 创建Core Data模型和对应的类
3. Step 3 编写Core Data模型的控制器
4. Step 4 在ViewController中调用Core Data模型类的方法函数

### CSV文件读取
#### 有用的资料
* [Reading from txt file in Swift 3 -- stackoverflow](http://stackoverflow.com/questions/40822170/reading-from-txt-file-in-swift-3)
* [READING AND WRITING TEXT AND CSV FILES IN SWIFT -- makeapppie](https://makeapppie.com/2016/05/23/reading-and-writing-text-and-csv-files-in-swift/)   
第一个链接提供了读取文件的方法，第二个链接提供了如何处理从csv读取到的字符串的方法。
#### 注意事项
* 读取文件内容前，需要使用Bundle.main.path()函数读取文件路径，所以需要**将csv文件添加到Bundle，即添加到项目目录中**。

### MySQL开发经验
#### 有用的资料
* [iOS Social App - Swift, PHP, MySQL, HTML](https://www.youtube.com/playlist?list=PLPvpSMth5DlALpnXncMEs9czd3c5odlhr)
* [Host your Application in the Google Cloud with XAMPP and Bitnami](https://www.apachefriends.org/docs/hosting-xampp-on-google.html)
* [How To Access PhpMyAdmin?](https://docs.bitnami.com/google/components/phpmyadmin/?utm_source=bitnami&utm_medium=cloudimage&utm_campaign=google): If successful, the above commands will create an SSH tunnel but **will not display any output** on the server console.
