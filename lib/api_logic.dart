import 'package:dio/dio.dart';

class ApiService {
  String eventId = "6f182c87-901a-4a26-8310-7812b531ab7f";
  Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://api.ieee-bub.org",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<Map<dynamic, dynamic>> getAll() async {
    try {
      final responce = await dio.get('/api/admin/events/$eventId/attendees');
      return responce.data;
    } catch (e) {
      return {};
    }
  }

  Future<String> register(String? userId) async {
    if (userId == null || userId == "") {
      return "No ID";
    }
    try {
      final data = await getAll();
      List<dynamic> presentUsers = data["data"]["presentUsers"];
      bool isPresent = presentUsers.any((user) => user["id"] == userId);
      if (isPresent) {
        return "User registered before";
      }
    } catch (e) {
      return "Can't fetch data, check your internet connection";
    }

    try {
      final responce = await dio.post(
        '/api/admin/events/$eventId/attendees',
        data: {"userId": userId},
      );

      if (responce.data["status"] == "success") {
        return "Registered successfully";
      } else {
        return "dummy"; //Any text just to prevent errors (The body might complete normally, causing 'null' to be returned)
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.unknown) {
        return "Can't register, check your internet connection";
      } else {
        return "User is not registered for this event";
      }
    }
  }
}
