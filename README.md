# MinorDianping
This the final project of NJU Mobile Application 2017 Spring by Zhijian Jiang and Zhecheng Li.   

## 开发过程中的Swift笔记
### Bundle
* Swift中用于读取工程目录信息的类。
### 一些关键词
* guard：可以暂时理解为类似于if关键词，必须有else。

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

## 其他笔记
### Git
* git push [remote-name] [branch-name]
* [5.2 代码回滚：Reset、Checkout、Revert的选择](https://github.com/geeeeeeeeek/git-recipes/wiki/5.2-%E4%BB%A3%E7%A0%81%E5%9B%9E%E6%BB%9A%EF%BC%9AReset%E3%80%81Checkout%E3%80%81Revert%E7%9A%84%E9%80%89%E6%8B%A9)
    * 撤销commit：git reset改变commit历史，git revert不改变commit历史；所以git reset适用于私有，revert适用于公有。
    * 显示当前分支：git branch
### 常用命令
* 查看文件的编码方式：file命令。