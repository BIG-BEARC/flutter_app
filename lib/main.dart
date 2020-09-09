import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//主方法使用了胖箭头符号(=>)， 它是只有一行代码的函数和方法的简写形式。
void main() => runApp(MyApp());

//MyApp 继承了 StatelessWidget ,使得它自己成为了一个小组件，在Flutter中， 几乎所有东西都是一个组件，包括对其，填充和布局。
class MyApp extends StatelessWidget {
  //组件的主要共组是提供一个 build() 方法，这个方法描述了如何显示其他小组件
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Material 库中的 Scaffold 组件，提供了一个默认的 bar (顶栏)，title，和 body 属性，
      // Scaffold 为主屏幕保存了一组组件树。组件树可能会非常复杂。
      /*     home: Scaffold(
        appBar: AppBar(
          title: Text(" Welcome to Flutter"),
        ),
        body: Center(
          child: RandomWords(),
        ),
      ),*/
      title: "Startup Name Generator",
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  //在 Dart 中，以下划线开头的变量是私有的。
  final _suggestions = <WordPair>[];
  final _save = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    /* final wordPair = WordPair.random();
    return Text(wordPair.asPascalCase);*/
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],

      ),
      body: _buildSuggestions(),
    );
  }

  /**
   * 这个方法构造了显示单词对列表的 ListView 。
   */
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // itemBuilder 在每次生成一个单词对时被回调
        // 每一行都是用 ListTile 代表
        // 对于偶数行，这个回调函数都添加一个 ListTile 组件来保存单词对
        // 对于奇数行，这个回调函数会添加一个 Divider 组件来在视觉上分割单词对。
        // 注意，在小设备上看到分割物可能会非常困难
        itemBuilder: (context, i) {
          //  在 ListView 组件的每行之前，先添加一个像素高度的分割。
          if (i.isOdd) return Divider();
          // 这个"i ~/ 2"的表达式将i 除以 2，然后会返回一个整数结果。
          // 例： 1, 2, 3, 4, 5 会变成 0, 1, 1, 2, 2。
          // 这个表达式会计算 ListView 中单词对的真实数量
          final index = i ~/ 2;
          // 如果到达了单词对列表的结尾处...
          if (index >= _suggestions.length) {
            // ...然后生成10个单词对到建议的名称列表中。
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  /**
   * 使用 ListTile 组件显示每一个新的单词对
   */
  Widget _buildRow(WordPair pair) {
    final _alreadySaved = _save.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        //注:在Flutter的响应式框架中，调用setState() 会触发对 State 对象的 build() 方法的调用，从而导致UI的更新。
        setState(() {
          if (_alreadySaved) {
            _save.remove(pair);
          } else {
            _save.add(pair);
          }
        });
      },
    );
  }

//创建一个 route ，并将它添加到导航栈中，这个动作会使APP显示一个新界面。
//新界面的内容由 MaterialPageRoute 的 builder 属性构建，这个属性应该是一个匿名函数。
  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _save.map((pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided = ListTile.divideTiles(context: context, tiles: tiles).toList();
      return Scaffold(
        appBar: AppBar(
          title: Text('Text(context:context,)'),
        ),
        body: ListView(children: divided,),
      );
    }));
  }
}
