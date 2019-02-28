# Dart/Flutter 序列化 / 反序列化

## 参考资料
- https://flutterchina.club/json/
- http://doc.flutter-dev.cn/json/

## 序列化 / 反序列化 所依赖的 Packages
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
