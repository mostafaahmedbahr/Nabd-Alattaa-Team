import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/announcement_model.dart';

abstract class AnnouncementRepository {
  /// Returns all announcements in real time.
  Stream<Either<Failure, List<AnnouncementModel>>> getAnnouncements();

  /// Creates a new announcement and notifies all users.
  Future<Either<Failure, void>> createAnnouncement(AnnouncementModel announcement);
}