import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:yemen_tourist_guide/customer/homePage/home_view/widgets/PlaceCard.dart';
import 'package:yemen_tourist_guide/customer/search/view/search_meta_data.dart';
import 'package:yemen_tourist_guide/customer/search/view/widgets/search_appbar.dart';
import '../../../../../core/utils/styles.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
   final int list=0;
   late FocusNode _focusNode;
   String? token;


   /// algolia setup
   final _searchTextController = TextEditingController();
   final _productsSearcher = HitsSearcher(
       applicationID: '2EUR1Y2RTW',
       apiKey: '23eb34d25462fee98acbf66c120b17d3',
       indexName: 'Places');

   Stream<SearchMetadata> get _searchMetadata =>
       _productsSearcher.responses.map(SearchMetadata.fromResponse);

   final PagingController<int, MyModel> _pagingController =
   PagingController(firstPageKey: 0);

   Stream<HitsPage> get _searchPage =>
       _productsSearcher.responses.map(HitsPage.fromResponse);

   final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();

   final _filterState = FilterState();

   late final _facetList = _productsSearcher.buildFacetList(
     filterState: _filterState,
     attribute: 'brand',
   );

   // Future<void> fetchToken()async{
   //   final mToken = await SharedPrefManager.getData(AppConstants.token);
   //   setState(() {
   //     token = mToken;
   //   });
   // }
   @override
   void initState() {
     super.initState();
     _focusNode = FocusNode();
     // Request focus when the widget is built
     WidgetsBinding.instance.addPostFrameCallback((_) {
       FocusScope.of(context).requestFocus(_focusNode);
     });

     // fetchToken();


     // Widget hits(BuildContext context) => PagedListView<int, MyModel>(
     //     pagingController: _pagingController,
     //     builderDelegate: PagedChildBuilderDelegate<MyModel>(
     //         noItemsFoundIndicatorBuilder: (_) => const Center(
     //           child: Text('No results found'),
     //         ),
     //         itemBuilder: (_, item, __) => Container(
     //           color: Colors.white,
     //           height: 80,
     //           padding: const EdgeInsets.all(8),
     //           child: Row(
     //             children: [
     //               // SizedBox(width: 50, child: Image.network(item)),
     //               const SizedBox(width: 20),
     //               Expanded(child: Text(jsonDecode(item.toString())))
     //             ],
     //           ),
     //         )));

     /// algolia setup
     _searchTextController.addListener(
           () => _productsSearcher.applyState(
             (state) => state.copyWith(
           query: _searchTextController.text,
           page: 0,
         ),
       ),
     );
     _searchPage.listen((page) {
       if (page.pageKey == 0) {
         _pagingController.refresh();
       }
       _pagingController.appendPage(page.items, page.nextPageKey);
     }).onError((error) => _pagingController.error = error);
     _pagingController.addPageRequestListener(
             (pageKey) => _productsSearcher.applyState(
                 (state) => state.copyWith(
               page: pageKey,
             )
         )
     );
     _productsSearcher.connectFilterState(_filterState);
     _filterState.filters.listen((_) => _pagingController.refresh());
   }

   @override
   void dispose() {
     _focusNode.dispose();
     super.dispose();
   }





  // bool isDesign1 = true;
  //
  // void showDesign1() {
  //   setState(() {
  //     isDesign1 = true;
  //   });
  // }
  //
  // void showDesign2() {
  //   setState(() {
  //     isDesign1 = false;
  //   });
  // }

   Widget hits(BuildContext context) => PagedGridView<int, MyModel>(
     pagingController: _pagingController,
     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
       crossAxisCount: 2, // Number of columns in the grid
       mainAxisSpacing: 20, // Spacing between rows
       crossAxisSpacing: 20, // Spacing between columns
       childAspectRatio: 3 / 4, // Aspect ratio of each grid item
     ),
     builderDelegate: PagedChildBuilderDelegate<MyModel>(
       noItemsFoundIndicatorBuilder: (_) => const Center(
         child: Text('No results found'),
       ),
       itemBuilder: (_, item, __) => Container(
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(10),
           boxShadow: [
             BoxShadow(
               color: Colors.grey.withOpacity(0.2),
               spreadRadius: 2,
               blurRadius: 5,
               offset: const Offset(0, 3), // Shadow position
             ),
           ],
         ),
         child: PlaceCard(
           title: item.data['place_name'],
           location: item.data['place_location'],
           rating: double.parse(item.data['rate_avg']),
           reviews: int.parse(item.data['review_num']),
           imagePath: item.data['place_image'][0],
           onTap: () {
             Get.toNamed('/placeDetailes', arguments: {
               'place':item.data['place_id']
             });
             // Handle tap on the card
           },
         ),
       ),
     ),
   );


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search'.tr,style: fontLargeBold,),
        centerTitle: true,

        leading:IconButton(
          style: IconButton.styleFrom(
            backgroundColor:Theme.of(context).cardColor,
          ),
          icon: const Icon(Icons.arrow_back_ios_new_outlined,size: 15,),
          onPressed: () => Navigator.pop(context),
        ) ,


      ),

      body:Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30,),
            Hero(
              tag: "search",
              child: TextField(
                controller: _searchTextController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffF5F4F8),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'search_here'.tr,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8), // Adjust the vertical padding as needed
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                      StreamBuilder<SearchMetadata>(
                                  stream: _searchMetadata,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    }
                                    return Wrap(
                                      children: [
                                        Text('have'.tr, style: fontMedium,),
                                        Text(" ${snapshot.data!.nbHits} ", style: fontMedium,),
                                        Text('places'.tr,
                                          style: fontMedium,)
                                      ],
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),

                  ],
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Expanded(child: hits(context))
          ],
        ),
      )


    );
  }

}


class HitsPage {
  const HitsPage(this.items, this.pageKey, this.nextPageKey);

  final List<MyModel> items;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(MyModel.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}


class MyModel {
  final Map<String, dynamic> data;

  MyModel({required this.data});

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(data: json);
  }

  Map<String, dynamic> toJson() {
    return data;
  }
}

