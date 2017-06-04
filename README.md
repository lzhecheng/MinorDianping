# MinorDianping
This the final project of NJU Mobile Application 2017 Spring by Zhijian Jiang and Zhecheng Li.   

## 开发过程中的Swift笔记
### Bundle
* Swift中用于读取工程目录信息的类。
### 一些关键词
* guard：可以暂时理解为类似于if关键词，必须有else。
* inout：意味着传入函数的参数是[被引用的](https://swiftcafe.io/2016/05/05/swift3-var/)。

### 泛型
#### 类型约束
```
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
    // function body goes here
}
```

### 常用技术
#### 从文件中读取内容
1. 将想要读取的文件添加到xcode的工程目录中，也就是添加到Bundle中。
2. 编写代码，以csv文件为例：
```
    guard let filepath = Bundle.main.path(forResource: file, ofType: "csv")
        else{
            return nil
    }
    do {
        let contents = try String(contentsOfFile: filepath, encoding: String.Encoding.utf8)
        return contents
    } catch {
        print("File Read Error")
        return nil
    }
```

#### Core Data
* [Swift 3 Core Data Delete Object](ttps://stackoverflow.com/questions/38017449/swift-3-core-data-delete-object)
* [Core Data: Relationship 总结](http://www.jianshu.com/p/8e3b64f16fc3)

#### 错误处理

#### if let和guard语法糖
```
if let v = str{
// use v to do something
}

guard v = str else {return}
// use v to do something
```

#### for循环
```
for i in 0 ... 5
```
从0开始包括5；
```
for i in 0 ..< 5
```
从0开始不包括5。

### 各种报错信息
* [Cannot explicitly specialize a generic function](http://stackoverflow.com/questions/27965439/cannot-explicitly-specialize-a-generic-function)
* [Ambiguous use of 'fetchRequest()'](https://stackoverflow.com/questions/39495199/subclass-fetchrequest-swift-3-0-extension-not-really-helping-100)
* [Cannot explicitly specialize a generic function](https://www.iphonelife.com/blog/31369/swift-programming-101-generics-practical-guide)
    * Swift中，泛型的调用方式是在变量声明的时候，如
    ```
    var personEntity: PersonEntity = p.createEntity()
    ```
* Error Domain=NSCocoaErrorDomain Code=134140
    * 修改core data中attribute的数据类型时，先删除该attribute，再添加就可以避免此错误。
* [Generic Parameter 'G' is not used in function signature](https://stackoverflow.com/questions/32407661/how-to-use-a-generic-inside-of-a-function-but-not-in-the-signature-swift-2)
* ['***' is ambiguous for type lookup in this context](https://forums.raywenderlich.com/t/dog-is-ambiguous-for-type-lookup-in-this-context/22280)
* [Swift 3 URLSession.shared() Ambiguous reference to member 'dataTask(with:completionHandler:) error (bug)](https://stackoverflow.com/questions/37812286/swift-3-urlsession-shared-ambiguous-reference-to-member-datataskwithcomplet)
    * it was declared earlier as URLRequest instead of NSMutableURLRequest: ```var request = URLRequest(url:myUrl!)```

## 其他笔记
### Git
* git push [remote-name] [branch-name]
* [5.2 代码回滚：Reset、Checkout、Revert的选择](https://github.com/geeeeeeeeek/git-recipes/wiki/5.2-%E4%BB%A3%E7%A0%81%E5%9B%9E%E6%BB%9A%EF%BC%9AReset%E3%80%81Checkout%E3%80%81Revert%E7%9A%84%E9%80%89%E6%8B%A9)
    * 撤销commit：git reset改变commit历史，git revert不改变commit历史；所以git reset适用于私有，revert适用于公有。
    * 显示当前分支：git branch
### 常用命令
* 查看文件的编码方式：file命令。
* [如何计算代码行数](https://stackoverflow.com/questions/316590/how-to-count-lines-of-code-including-sub-directories)：```find . -name "*.c" -print0 | xargs -0 wc -l```