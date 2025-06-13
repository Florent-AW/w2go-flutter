// core/domain/filters/filter_chain.dart

import 'activity_filter.dart';
import '../../models/trip_designer/processing/activity_processing_model.dart';

class FilterChain {
  final List<ActivityFilter> _filters = [];

  void addFilter(ActivityFilter filter) => _filters.add(filter);

  Future<List<ActivityForProcessing>> apply(List<ActivityForProcessing> activities) async {
    var filtered = activities;
    for (var filter in _filters) {
      filtered = await filter.apply(filtered);
    }
    return filtered;
  }
}