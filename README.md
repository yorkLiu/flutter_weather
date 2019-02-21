# Flutter 实现 天气预报

## 效果如下
![](./screenshots/demo.gif.gif)


## 更多关于 Flutter 的plugin, Idea, 用法
[请参见 awesome-flutter](awesome-flutter.md)

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

## Dart/Flutter 序列化 / 反序列化
### 序列化 / 反序列化 所依赖的 Packages
- [json_annotation](https://pub.dartlang.org/packages/json_annotation)
- [json_serializable](https://pub.dartlang.org/packages/json_serializable)

如果你要使用 `Dart`自动的『序列 / 反序列化』还需要 **1** 个额外的 `Dependency`
- [build_runner](https://pub.dartlang.org/packages/build_runner) 用来生成 『序列 / 反序列化』 文件的

### Example 『序列 / 反序列化』
1. Create Class
```dart
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';  // 这里IDEA会提示报错，暂不用管，因为这个文件目前还不存在，这个文件是交给dart自动生成的

@JsonSerializable()  // 为Class 添加 Json 序列化 annotation
Class Data {
    // 定义 class的构造方法
    Data({this.name, this.email});

    String name;
    String email;
}
```
2. Run Command
- `flutter packages pub run build_runner build`  每次手动生成，假如 Data Class中增加或者删除了property, 则需要手动运行改命令
- `flutter packages pub run build_runner watch`  使用_watcher_可以使我们的源代码生成的过程更加方便。它会监视我们项目中文件的变化，并在需要时自动构建必要的文件; 只需启动一次观察器，然后并让它在后台运行，这是安全的.

3. Run 完command之后，在 `data.dart`文件同级的下，会自动成一个名为 `data.g.dart`的文件
`data.g.dart` 文件中就是定义的是 Json 序列化及反序列化的方法
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Today(
      name: json['name'] as String,
      email: json['email'] as String);
  }

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
  };
```

4. 在 `data.dart` 中的 `Data` class中添加『序列 / 反序列』两个方法
```dart
// 反序列化 json => dart object
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  // 序列化 dart object => json
  Map<String, dynamic> toJson() => _$DataToJson(this);
```
`_$DataFromJson`及 `_$DataToJson` 两个方法都是 `data.g.dart`文件中自动生成的!

```dart
import 'package:json_annotation/json_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
Class Data {
    // 定义 class的构造方法
    Data({this.name, this.email});

    String name;
    String email;

    // 反序列化 json => dart object
    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

    // 序列化 dart object => json
    Map<String, dynamic> toJson() => _$DataToJson(this);
}
```

4. 使用 反序列 将  Json => Object
```dart
Data data = Data.fromJson(json.decode(jsonValue));
```

5. 更多关于Dart『序列/反序列』的使用，请参考
- [Flutter中文网](https://flutterchina.club/json)
- [Flutter Json自动反序列化——json_serializable](https://juejin.im/post/5b5f00e7e51d45190571172f)

## Dependency Packages
- [dio](https://github.com/flutterchina/dio)
- [json_annotation](https://pub.dartlang.org/packages/json_annotation)
- [json_serializable](https://pub.dartlang.org/packages/json_serializable)
- [build_runner](https://pub.dartlang.org/packages/build_runner)


# Flutter 学习资源

## Flutter 网站
* [官网](http://flutter.io/)
* [Flutter 中文网](https://flutterchina.club/)
* [Medium Flutter](https://medium.com/flutter-io)
* [Dart 语言中文论坛](http://www.cndartlang.com/)
* [Flutter 中文论坛](http://flutter-dev.cn)
* [官网中文版](http://doc.flutter-dev.cn)
* [从环境搭建到进阶系列教程](http://flutter-dev.com/bbs/topic/12)

## Flutter资源
* [awesome-flutter](https://github.com/Solido/awesome-flutter) 收集得太全了
* [官方插件](https://github.com/flutter/plugins)
* [FlutterExampleApps](https://github.com/iampawan/FlutterExampleApps) 这里有不少Flutter写的项目【英文】
* [Flutter写的开源中国客户端 FlutterOSC](https://github.com/yubo725/FlutterOSC) UI看起来还不错 【中文】
* [DroidKaigi 2018 Flutter App](https://github.com/konifar/droidkaigi2018-flutter) 也是一个开源的客户端 日本的
* [官方的Plugins](https://github.com/flutter/plugins) [英文]
* [生成二维码的一个库](https://github.com/lukef/qr.flutter) [英文]
* [Google charts](https://github.com/google/charts) 一个图表库 【英文】
* [Section Header 悬停的ListView](https://github.com/itsJoKr/sticky_header_list) [英文]
* [轮播组件](https://github.com/gbrvalerio/carousel) [英文]
* [Tensorflow flutter 接口](https://github.com/kashifmin/flutter_tensorflow_lite) [英文]
* [Markdown 组件](https://github.com/flutter/flutter_markdown) 用了一下，功能不是太完善.不过基本上够用了，可以完全定制
* [Readhub Flutter 客户端](https://github.com/flyou/readhub_flutter) 【中文】
* [RXDart](https://github.com/ReactiveX/rxdart) RxSwift用起来很爽，dart不知道怎么样。
* [又是一个Examples集合](https://github.com/nisrulz/flutter-examples)这个里面例子都是比较简单的
* [menu_flutter](https://github.com/braulio94/menu_flutter) 一个flutter app，UI不错
* [flutter_launcher_icons](https://github.com/franzsilva/flutter_launcher_icons) flutter的启动页面
* [conference_app](https://github.com/dart-lang/conference_app) 又是一个app
* [inKino](https://github.com/roughike/inKino) 一个app
* [TodoMVC](https://github.com/brianegan/flutter_architecture_samples) TodoMVC 这个可以去看一下
* [udacity-course github代码](https://github.com/flutter/udacity-course) udacity上的Flutter课程，Google开发的[课程地址](https://www.udacity.com/course/build-native-mobile-apps-with-flutter--ud905)
* [仿知乎的UI](https://github.com/HackSoul/zhihu-flutter)
* [fluro 路由库](https://github.com/theyakka/fluro) 很早就用过了
* [更多关于 Flutter 的plugin, Idea, 用法 请参见 awesome-flutter](awesome-flutter.md)

## 每日关注
* [github dart trending](https://github.com/trending/dart?since=daily)
