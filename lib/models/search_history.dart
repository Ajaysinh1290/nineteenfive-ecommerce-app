class SearchHistory {

  late String  queryId;
  late  String  query;

  SearchHistory({required this.queryId, required this.query});

  SearchHistory.fromJson(Map<String,dynamic> data) {
    this.queryId = data['query_id'];
    this.query = data['query'];
  }

  Map<String,dynamic> toJson() {
    return {
      "query_id": this.queryId,
      "query" : this.query
    };
  }
}