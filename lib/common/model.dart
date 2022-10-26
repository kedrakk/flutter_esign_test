class Tabs {
  String tabName;
  int tabIndex;
  Tabs({
    required this.tabIndex,
    required this.tabName,
  });

  static List<Tabs> allTabs = [
    Tabs(tabIndex: 1, tabName: "Draw"),
    Tabs(tabIndex: 2, tabName: "Upload"),
  ];
}
