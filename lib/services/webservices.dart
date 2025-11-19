import 'package:http/http.dart' as http;
import 'package:lasgidi/models/gallery_model.dart';
import 'dart:convert';
import 'package:lasgidi/models/noa_model.dart';
import 'package:lasgidi/models/prog_schedule_model.dart';


Future<List> fetchWpPost() async {
  final response = await http.get(Uri.parse("https://lasgidifm.com/wp-json/wp/v2/posts?_embed"), headers: {"Accept":"application/json"});
  var convertDataToJson = jsonDecode(response.body);
  return convertDataToJson;
}

Future<List> fetchWpPostCategory(catNumber) async {
  final response = await http.get(Uri.parse("https://trafficradio961.ng/wp-json/wp/v2/posts?categories=$catNumber"), headers: {"Accept":"application/json"});
  var convertDataToJson = jsonDecode(response.body);
  return convertDataToJson;
}

Future<NowAndNext> nowOnAirData() async {
  try {
    print('Fetching now on air data for lasgidi901...');
    final response = await http.get(
      Uri.parse("https://noa.elektranbroadcast.com/api/programs/now-and-next?stationName=lasgidi901"), 
      headers: {"Accept":"application/json"}
    );
    
    print('Response status code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      var convertDataToJson = jsonDecode(response.body);
      print('API Response received successfully');
      print('Now On Air: ${convertDataToJson['nowOnAir']?['programName']}');
      print('Up Next: ${convertDataToJson['upNext']?['programName']}');
      
      final result = NowAndNext.fromJson(convertDataToJson);
      print('Parsed nowOnAir: ${result.nowOnAir?.programName}');
      print('Parsed upNext: ${result.upNext?.programName}');
      
      return result;
    } else {
      print('API Error: Status code ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load now on air data');
    }
  } catch (e, stackTrace) {
    print('Error fetching now on air: $e');
    print('Stack trace: $stackTrace');
    // Return empty NowAndNext object on error
    return NowAndNext(nowOnAir: null, upNext: null);
  }
}

Future<List<WelcomeGallery>> getGalleries(String gallery) async {
  final response = await http.get(Uri.parse("https://servoserver.com.ng/lasgidifm/api/get_oaps?businessLocation=$gallery"), headers: {"Accept":"application/json"});
  var convertDataToJson = jsonDecode(response.body);
  print('oap gallery: $convertDataToJson');
  return List<WelcomeGallery>.from((convertDataToJson).map((x) => WelcomeGallery.fromJson(x)));
}








