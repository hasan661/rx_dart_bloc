import 'dart:async';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final _dataSubject = BehaviorSubject<List<String>>();

  final _buttonEnabled = BehaviorSubject<bool>.seeded(false);

  Stream<List<String>> get dataStream => _dataSubject.stream;
  Stream<bool> get buttonStream => _buttonEnabled.stream;


  void buttonEnabled(String item){
    _buttonEnabled.add(item==""?false:true);
  }
  

  void fetchData() {
    _dataSubject.add([]);
  }

  void addData(String newItem) {
    _dataSubject.add([..._dataSubject.value, newItem]);
  }

  void removeData(int indexToBeRemoved) {
    List<String> currentList = _dataSubject.value;
    currentList.removeAt(indexToBeRemoved);
    _dataSubject.add(currentList);
  }

  void dispose() {
    _dataSubject.close();
  }
}
