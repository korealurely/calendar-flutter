import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPage extends ConsumerWidget{
  const MyPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("我的",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Color(0xFF1F1F1F)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildCard(
                "清除缓存",
                onTap: (){
                  //实现点击方法
                }
              ),
              _buildCard(
                  "清除缓存",
                  onTap: (){
                    //实现点击方法
                  }
              ),
              _buildCard(
                  "清除缓存",
                  onTap: (){
                    //实现点击方法
                  }
              ),
              _buildCard(
                  "清除缓存",
                  onTap: (){
                    //实现点击方法
                  }
              ),
            ],
          )
      ),
    );
  }

  Widget _buildCard(String title,{VoidCallback? onTap}){
    return Container(
      margin: const EdgeInsets.only(top: 8,left: 8,right: 8),
      //padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4)
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.black.withValues(alpha: 0.04),
              width: 0.8
            )
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18,horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,style: TextStyle(fontSize: 16,color: Colors.black87)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

