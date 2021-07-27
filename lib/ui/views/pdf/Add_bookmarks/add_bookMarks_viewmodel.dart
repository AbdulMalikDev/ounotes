import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/models/notes.dart';
import 'package:FSOUNotes/services/state_services/subjects_service.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BookMarkBottomSheetViewModel extends BaseViewModel {
  bool _isNextPressed = false;
  Note _note;
  SubjectsService _subjectsService = locator<SubjectsService>();
  Box box;
  SfRangeValues _sfValues = SfRangeValues(2.0, 4.0);
  Map<int, bool> _units = {
    1: false,
    2: true,
    3: false,
    4: true,
    5: false,
  };
  Map<int, String> _unitTitles = {
    1: "Unit 1",
    2: "Unit 2",
    3: "Unit 3",
    4: "Unit 4",
    5: "Unit 5",
  };
  Map<int, String> _unitPageNos = {
    1: "",
    2: "",
    3: "",
    4: "",
    5: "",
  };
  Map<String, int> _bookmarks = {};

  setUnitTitles(
    int index,
    String val,
  ) {
    _unitTitles[index] = val;
    notifyListeners();
  }

  setUnitPageNos(
    int index,
    String val,
  ) {
    _unitPageNos[index] = val;
    notifyListeners();
  }

  set setNote(Note note) {
    _note = note;
  }

  set setIsNextPressed(bool isNextPressed) {
    _isNextPressed = isNextPressed;
    notifyListeners();
  }

  set setSfValues(SfRangeValues values) {
    for (int i = 1; i <= _units.length; i++) {
      if (i >= values.start.toInt() && i <= values.end.toInt()) {
        _units[i] = true;
      } else {
        _units[i] = false;
      }
    }
    print(_units);
    _sfValues = values;

    notifyListeners();
  }

  setUnitsToService() {
    _note.units = _units;
    setNoteToService();
  }

  Map<int, bool> get units => _units;
  Map<int, String> get unitTitles => _unitTitles;
  Map<int, String> get unitPageNos => _unitPageNos;
  Map<String, int> get bookmarks => _bookmarks;
  Note get note => _note;
  bool get isNextPressed => _isNextPressed;
  SfRangeValues get sfValues => _sfValues;

  init(bool isInitial) async {
    setBusy(true);
    if (_subjectsService.documentHiveBox.get('bottomsheet') == null) return;
    if (isInitial) {
      if (_subjectsService.documentHiveBox.get("bottomsheet") != null) {
        _subjectsService.documentHiveBox.delete("bottomsheet");
      }
    }
    Map<String, dynamic> bottomsheet =
        _subjectsService.documentHiveBox.get('bottomsheet');
    _isNextPressed = bottomsheet["NextPressed"] ?? false;
    int start = bottomsheet["start"].toInt();
    int end = bottomsheet['end'].toInt();
    _unitTitles = bottomsheet['unitTitles'] as Map<int, String>;
    _unitPageNos = bottomsheet['unitPageNos'] as Map<int, String>;
    log.i(_unitPageNos.toString() + "sdsdsdsd");
    _sfValues = SfRangeValues(start, end);
    for (int i = 1; i <= units.length; i++) {
      if (i >= start && i <= end) {
        units[i] = true;
      } else {
        units[i] = false;
      }
    }
    setBusy(false);
    notifyListeners();
  }

  initialize() async {
    setBusy(true);
    box = await Hive.openBox("bottomSheet");
    _subjectsService.setBox(box);
    setBusy(false);
  }

  saveDataLocally() async {
    Map<String, dynamic> bottomsheet = {
      "NextPressed": _isNextPressed,
      "start": _sfValues.start,
      "end": _sfValues.end,
      "unitTitles": _unitTitles,
      "unitPageNos": _unitPageNos,
    };
    _subjectsService.documentHiveBox.put("bottomsheet", bottomsheet);
  }

  void setNoteToService() {
    _subjectsService.note = this.note;
  }
}
