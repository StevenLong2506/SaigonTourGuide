import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saigon_tour_guide/core/api_client.dart';
import 'package:saigon_tour_guide/core/date_formats.dart';
import 'package:saigon_tour_guide/model/chat_session.dart';

class ChatListScreen extends StatefulWidget{
  const ChatListScreen({super.key});
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>{
  List<ChatSession> _sessions=[];
  bool _loading = true;
  String? _error;
  
  Future<void> _load() async{
    setState(() {
      _loading = true;
      _error = null;
    });
    try{
      final res = await context.read<ApiClient>().dio.get('/chat/sessions');
      final items = (res.data as List).map((e)=> ChatSession.fromJson(e as Map<String,dynamic>)).toList();
      if(!mounted) return;
      setState(() => _sessions = items);
    }
    catch(e){
      if(!mounted) return;
      setState(() => _error = 'Lỗi hiển thị lịch sử chat');
    }
    finally{
      if(mounted) setState(() => _loading=false);
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử chat')),
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : _error != null 
          ? Center(child: Text(_error!))
          : _sessions.isEmpty 
            ? const Center(child: Text('Chưa có cuộc trò chuyện nào'))
            : RefreshIndicator(
              onRefresh: _load, 
              child: ListView.separated(
                padding: const EdgeInsets.all(12),            
                separatorBuilder: (_,__) => const Divider(height: 1), 
                itemCount: _sessions.length,
                itemBuilder: (context, idx) {
                  final s = _sessions[idx];
                  return ListTile(
                    leading: const Icon(Icons.chat_bubble_outline_rounded),
                    title: Text(s.title ?? 'Cuộc trò chuyện #${s.id}'),
                    subtitle: Text(AppDateFormat.displayWithTime.format(s.updatedAt)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: ()=> Navigator.pop(context, s.id),
                  );
                },
              )
            )
    );
  }
}