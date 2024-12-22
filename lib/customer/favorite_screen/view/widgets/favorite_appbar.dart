import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/utils/images.dart';
import '../../../../core/utils/styles.dart';

class FavoriteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavoriteAppBar({super.key, required this.onTap,required this.title,});
  final VoidCallback onTap;
  final String title;
  // final Icon icon;



  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title,style: fontLargeBold,),
        centerTitle: true,
        actions:[
          Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                  style: IconButton.styleFrom(fixedSize: const Size(70, 70),
                      backgroundColor:Theme.of(context).cardColor  ),
                  icon: SvgPicture.asset(Images.trushIcon,),

                  onPressed: (){
                    _deleteAllFavorite(context);
                  }
              )
          ),
        ]


    );

  }

  _deleteAllFavorite(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          color: Theme.of(context).cardColor,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Delete favorite",style: fontMediumBold,),
                const SizedBox(height: 10,),
                Text("Delete all favorite",style:fontMediumBold,),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: onTap,
                        child: Container(
                          height: 40,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color:Theme.of(context).colorScheme.onError,
                          ),
                          child: Text("Delete",style: fontSmallBold,),
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          //cancelDelete();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color:Theme.of(context).focusColor,
                          ),
                          child: Text("cancel",style: fontSmallBold,),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

// void cancelDelete() {
//
// }

}
