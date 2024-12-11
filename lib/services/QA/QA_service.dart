import 'dart:convert';
import'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:jkmapp/utils/localStorage.dart';
import 'package:jkmapp/constants.dart';

class QAService{
  //儲存到資料庫
  Future<bool> saveQAData(
        String question,
        String answer,{
        String? type,
        Uint8List? selectedImageBytes,
        File? selectedImageFile,
        String? imageFileName,
        required String userId,
      }) async {
      try {
        // 建構 multipart/form-data 请求
        var request = http.MultipartRequest(//多部分請求
          'POST',
          Uri.parse('$baseUrl/savedata'),
        );

        // 加入表單欄位
        request.fields['question'] = question;
        request.fields['answer'] = answer;
        request.fields['user_id'] = userId;
        if (type != null) {
          request.fields['type'] = type;
        }


        //上傳圖片
        if (selectedImageBytes != null) {
         //web
          request.files.add(http.MultipartFile.fromBytes(
            'image',
            selectedImageBytes,
            filename: imageFileName ?? 'default_image.png', // 使用默认文件名
          ));
        } else if (selectedImageFile != null) {
          // 處理app上傳
          var multipartFile = await http.MultipartFile.fromPath(
            'image',
            selectedImageFile.path,
            filename: imageFileName ?? selectedImageFile.path.split('/').last, // 使用原始文件名
          );
          request.files.add(multipartFile);
        }

        // 發生請求並獲得回應
        var response = await request.send();
        // 检查是否成功
        if (response.statusCode == 200) {
          print('Data saved successfully');
          return true;
        } else {
          print('Failed to save data');
          return false;
        }
      } catch (e) {
        print('Error occurred while saving data: $e');
        return false;
      }
   }

     //加載QA
     Future<List<Map<String, dynamic>>> fetchQA(String userId) async {
       final response =await http.get(
           Uri.parse('$baseUrl/getqa?user_id=$userId'),
           headers: {'Content-Type':'application/json'},
         );
         if(response.statusCode==200){
            List<Map<String,dynamic>>qalist = List<Map<String,dynamic>>.from(jsonDecode(response.body));
            return qalist;
         }else{
           throw Exception('Failed to load QA data');
         }
     }

     //載入QA資訊
     Future<List<Map<String, dynamic>>> fetchQAByqaid(String qaId) async {
       final response =await http.get(
         Uri.parse('$baseUrl/getqabyqaid/$qaId'),
         headers: {'Content-Type':'application/json'},
       );
       if(response.statusCode==200){
         List<Map<String,dynamic>>qalist = List<Map<String,dynamic>>.from(jsonDecode(response.body));
         return qalist;
       }else{
         throw Exception('Failed to load QA data');
       }
     }
     //更新QA
     Future<void> updatedata({
       required String qaId,
       required String question,
       required String answer,
       String? type,
       String? image,
     }) async {
       final response = await http.post(
         Uri.parse('$baseUrl/updatedata/$qaId'),
         headers: {'Content-Type': 'application/json'},
         body: jsonEncode({
           'question': question,
           'answer': answer,
           'type': type,
           'image': image,
         }),
       );
       if (response.statusCode != 200) {
         throw Exception('Failed to update QA data');
       }
     }

      //從資料庫中刪除
     Future<bool>deleteData(String qaId)async{
       try{
          final response =await http.delete(
               Uri.parse('$baseUrl/deletedata/$qaId'),
               headers: {'Content-Type': 'application/json'},
          );
          return response.statusCode == 200;
       }catch(e){
          print('Error deleting QA data:$e');
          return false;
       }
     }

     //發送問題-得到答案
     Future<String>fetchanswer(String question)async{
       final userId = await StorageHelper.getUserId();
        try{
            final response = await http.post(
                Uri.parse('$baseUrl/query_qa'),
                headers:{"Content-Type":"application/json"},
                body: jsonEncode({
                  "user_id":userId,
                  "question":question}),
            );
            if(response.statusCode==200){
               final responseData=jsonDecode(response.body);
               return responseData['answer']??"抱歉，目前無法回答您這個問題";
            }else{
               return "無法取得回應，請稍後再試";
            }
        }catch(e){
            return "發生錯誤，請檢查網路連線";
        }
     }

     //加載未解答的問題表
     static Future<List<Map<String, dynamic>>>fetchUnanswered()async {
       final userId = await StorageHelper.getUserId();
       try {
         final response = await http.get(
             Uri.parse('$baseUrl/unanswered_questions?user_id=$userId')
         );
         if (response.statusCode == 200) {
           final data = json.decode(response.body) as List;
           return data.map((item) {
             return {
               "id": item["id"],
               "question": item["question"],
               "count": item["occurence_count"],
             };
           }).toList();
         } else {
           throw Exception("Failed to load unanswered questions");
         }
       } catch (e) {
         print("Error fetching unanswered questions: $e");
         return [];
       }
     }

}