import 'package:flutter/material.dart';

import '../../shared/clr.dart';
import '../../shared/layout.dart';
import '../../shared/txt.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
	TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
				elevation: layout.elevation,
        centerTitle: true,
        title: const Text(
          'Search Groups',
          style: txt.appBar,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: clr.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: layout.padding / 2,
              vertical: layout.padding / 2,
            ),
						child: Row(
							children: [
								Expanded(
									child: TextField(
										controller: searchController,
										style: txt.normal.copyWith(color: clr.light),
										decoration: InputDecoration(
											border: InputBorder.none,
											hintText: 'Search groups...',
											hintStyle: txt.small.copyWith(color: clr.light),	
										),

									),
								),
							],
						),
          ),
        ],
      ),
    );
  }
}
