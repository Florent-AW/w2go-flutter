// core/domain/ports/search/recent_terms_port.dart

abstract class RecentTermsPort {
  Future<List<String>> getRecentTerms({int limit = 8});
  Future<void> addRecentTerm(String term, {int maxEntries = 8});
  Future<void> clear();
}
