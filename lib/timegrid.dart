import 'package:flutter/material.dart';
import 'taskview.dart';
import 'tasks.dart';

class TimeGrid extends StatefulWidget {
  final TaskList taskList;

  TimeGrid({Key? key, required this.taskList}) : super(key: key);

  @override
  State<TimeGrid> createState() => _TimeGridState();
}

class _TimeGridState extends State<TimeGrid> {
  final key = GlobalKey<ScaffoldState>();
  List<String> itemsList = [];
  List<String> itemsListSearch = [];
  final FocusNode _textFocusNode = FocusNode();
  final TextEditingController _searchQuery = TextEditingController();

  // @override
  // void dispose() {
  //   _textFocusNode.dispose();
  //   _searchQuery!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    itemsList = widget.taskList.getTasks().map((e) => e.getName()).toList();

    return Column(children: [
      TextField(
        controller: _searchQuery,
        focusNode: _textFocusNode,
        cursorColor: Colors.white,
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            prefixIconColor: Colors.white30,
            hintText: "Search tasks",
            hintStyle: TextStyle(color: Colors.white12),
            fillColor: Colors.white,
            border: InputBorder.none),
        onChanged: (value) {
          setState(() {
            itemsListSearch = itemsList
                .where((element) =>
                    element.toLowerCase().contains(value.toLowerCase()))
                .toList();
            if (_searchQuery.text.isNotEmpty && itemsListSearch.isEmpty) {}
          });
        },
      ),
      _searchQuery.text.isNotEmpty && itemsListSearch.isEmpty
          ? const Text("No results found")
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
                childAspectRatio: (2 / 1),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              padding: const EdgeInsets.all(20),
              shrinkWrap: true,
              itemCount: _searchQuery.text.isNotEmpty
                  ? itemsListSearch.length
                  : itemsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TaskScreen(task: widget.taskList.get(index)))),
                    child: GridTile(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.taskList.get(index).getTime(0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36.0,
                                fontWeight: FontWeight.w600,
                              )),
                          Text(
                              _searchQuery.text.isNotEmpty
                                  ? itemsListSearch[index]
                                  : itemsList[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
                        ],
                      ),
                    )));
              }),
    ]);
  }
}
