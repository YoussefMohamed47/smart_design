enum TabType {
  TAB_TYPE_DEFINITION,
  TAB_TYPE_AUTHOR,
  TAB_TYPE_CONTENT,
  TAB_TYPE_COURSE
}
class TabTypeEnum {
  static Map<TabType, int> toInt = {
    TabType.TAB_TYPE_DEFINITION: 1,
    TabType.TAB_TYPE_AUTHOR: 2,
    TabType.TAB_TYPE_CONTENT: 3,
    TabType.TAB_TYPE_COURSE: 4,
  };

  static Map<int, TabType> toEnum = {
    1: TabType.TAB_TYPE_DEFINITION,
    2: TabType.TAB_TYPE_AUTHOR,
    3: TabType.TAB_TYPE_CONTENT,
    4: TabType.TAB_TYPE_COURSE
  };
}



enum AlamaryiyaatFilter {
  CLASSIFICATION,
  AUTHOR,
  CHANNELS,
  DATE
}
class AlamaryiyaatFilterEnum {
  static  const  Map<AlamaryiyaatFilter, int> toInt = {
    AlamaryiyaatFilter.CLASSIFICATION: 0,
    AlamaryiyaatFilter.AUTHOR: 1,
    AlamaryiyaatFilter.CHANNELS: 2,
    AlamaryiyaatFilter.DATE: 3,
  };

  static Map<int, AlamaryiyaatFilter> toEnum = {
    0: AlamaryiyaatFilter.CLASSIFICATION,
    1: AlamaryiyaatFilter.AUTHOR,
    2: AlamaryiyaatFilter.CHANNELS,
    3: AlamaryiyaatFilter.DATE
  };
}

class AppEnums {
  static const Map<String, int> SubscriptionStatus = const {
    'UnPaid': 29,
    'Paid': 30,
    'Active': 31,
    'Canceled': 32,
  };

  static const Map<String, int> PreferedNumberOfMeals = const {
    'Two': 2,
    'Three': 3,
    'Four': 4,
    'Five': 5,
  };
}