// // ステップ3までのコード  
// import 'package:flutter/material.dart';
// // <3>下の2行追加
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../services/category.dart';

// class CategoryFormScreen extends StatelessWidget {
//   const CategoryFormScreen({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('カテゴリ追加'),
//       ),
//       body: const _CategoryFormBody(),
//     );
//   }
// }

// // <3>ConsumerStatefulWidgetに変更
// class _CategoryFormBody extends ConsumerStatefulWidget {
//   const _CategoryFormBody();

//   @override
//   _CategoryFormBodyState createState() => _CategoryFormBodyState();
// }

// // <3>ConsumerStateに変更
// class _CategoryFormBodyState extends ConsumerState<_CategoryFormBody> {

//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   // <3> _saveCategory()メソッド 
//   Future<void> _saveCategory() async {
//     // 入力が空っぽなら falseの逆(!)→trueで、return(プログラム中止)
//     if (!(_formKey.currentState?.validate() ?? false)) {
//       return;
//     }

//     try {
//       await CategoryService().create(_nameController.text);
//       print('成功');
//     //tryの途中でエラーが発生した場合、プログラムはprintを無視して、この catchを実行
//     } catch (e) {
//       // SnackBar()画面下にメッセージバーを表示するウィジェット
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('エラーが発生しました: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: _nameController,
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'カテゴリ名を入力してください';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               //<3> 処理を書き換え
//               onPressed: () => _saveCategory(),
//               child: const Text('追加'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../providers/category.dart';
import '../services/category.dart';

class CategoryFormScreen extends StatelessWidget {
  const CategoryFormScreen({
    super.key,
    this.category,
  });

  final Category? category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category == null ? 'カテゴリ追加' : 'カテゴリ編集'),
      ),
      body: _CategoryFormBody(category: category),
    );
  }
}

class _CategoryFormBody extends ConsumerStatefulWidget {
  const _CategoryFormBody({
    this.category,
  });

  final Category? category;

  @override
  _CategoryFormBodyState createState() => _CategoryFormBodyState();
}

class _CategoryFormBodyState extends ConsumerState<_CategoryFormBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category?.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      if (widget.category == null) {
        await CategoryService().create(_nameController.text);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('カテゴリが正常に作成されました')),
        );
      } else {
        final updatedCategory = widget.category!.copyWith(
          name: _nameController.text,
        );
        await CategoryService().update(updatedCategory);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('カテゴリが正常に更新されました')),
        );
      }

      ref.invalidate(categoryProvider);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'カテゴリ名',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'カテゴリ名を入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _saveCategory(),
                child: Text(widget.category == null ? '追加' : '更新'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}