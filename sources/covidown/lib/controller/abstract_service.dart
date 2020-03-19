//
import 'package:covidown/controller/abstract_dao.dart';
import 'package:covidown/model/abstract_entity.dart';

abstract class AbstractSevice<U extends AbstractDAO<T>, T extends AbstractEntity> {

  Future<U> getDAO();

}