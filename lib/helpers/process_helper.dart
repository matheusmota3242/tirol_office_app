class ProcessHelper {
  static List<String> extractResponse(String response) {
    var responseArray = <String>[];
    var indexSpace = response.indexOf(' ');
    var indexHifen = response.indexOf('-');
    responseArray[0] = response.substring(0, indexSpace - 1);
    responseArray[1] = response.substring(indexHifen + 1, response.length);
    return responseArray;
  }
}
