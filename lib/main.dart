import 'package:flutter/material.dart';

class Data {
  const Data({required this.title, required this.subDataList});

  final String title;
  final List<SubData> subDataList;
}

class SubData {
  const SubData({required this.title});

  final String title;
}

List<Data> dummyDataList = [];
void main() {
  dummyDataList.clear();
  for (int i = 0; i < 1000; i++) {
    List<SubData> dummySubDataList = [];
    for (int j = 0; j < 2000; j++) {
      dummySubDataList.add(SubData(title: 'SubData $j'));
    }
    dummyDataList.add(Data(title: 'Data $i', subDataList: dummySubDataList));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UnOptimized(),
    );
  }
}

class UnOptimized extends StatefulWidget {
  const UnOptimized({super.key});

  @override
  State<UnOptimized> createState() => _UnOptimizedState();
}

class _UnOptimizedState extends State<UnOptimized> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Un optimized'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return DummyDataExpandable(data: dummyDataList[index]);
        },
        itemCount: dummyDataList.length,
      ),
    );
  }
}

class DummyDataExpandable extends StatelessWidget {
  const DummyDataExpandable({super.key, required this.data});

  final Data data;

  @override
  Widget build(BuildContext context) {
    return MeGroupByAccordion(
      headingText: data.title,
      totalCount: data.subDataList.length,
      listViewWidget: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return DataTile(subData: data.subDataList[index]);
        },
        itemCount: data.subDataList.length,
      ),
    );
  }
}

class DataTile extends StatelessWidget {
  const DataTile({super.key, required this.subData});

  final SubData subData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(subData.title),
    );
  }
}

class MeGroupByAccordion extends StatefulWidget {
  const MeGroupByAccordion({
    super.key,
    required this.headingText,
    required this.totalCount,
    required this.listViewWidget,
    this.defaultEnabled = true,
  });

  final String headingText;
  final int totalCount;
  final Widget listViewWidget;
  final bool defaultEnabled;

  @override
  State<MeGroupByAccordion> createState() => _MeGroupByAccordionState();
}

class _MeGroupByAccordionState extends State<MeGroupByAccordion>
    with AutomaticKeepAliveClientMixin {
  late bool isEnabled;

  @override
  void initState() {
    isEnabled = widget.defaultEnabled;
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isEnabled = !isEnabled;
            });
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 11,
            ),
            margin: const EdgeInsets.only(
              bottom: 1,
            ),
            color: Colors.blue,
            child: Row(
              children: [
                Text(widget.headingText),
                const Spacer(),
                if (widget.totalCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(
                        4,
                      ),
                    ),
                    child: Text(
                      widget.totalCount.toString(),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (isEnabled) ...[widget.listViewWidget],
      ],
    );
  }
}
