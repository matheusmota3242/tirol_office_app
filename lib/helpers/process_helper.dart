class ProcessHelper {
  static List<String> extractResponse(String response) {
    var responseArray = <String>[];
    var indexSpace = response.indexOf(' -');
    var indexHifen = response.indexOf('-');
    responseArray.add(response.substring(0, indexSpace));
    responseArray.add(response.substring(indexHifen + 2, response.length));
    return responseArray;
  }
}
