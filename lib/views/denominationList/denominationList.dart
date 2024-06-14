import 'package:denomination/views/homeScreen/homeScreenCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class DenominationList extends StatefulWidget {
  const DenominationList({super.key});

  @override
  State<DenominationList> createState() => _DenominationListState();
}

class _DenominationListState extends State<DenominationList> with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocBuilder<HomeScreenCubit, HomeState>(
      builder: (context, state) {
        var cubitData = context.read<HomeScreenCubit>();
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: (){
              Navigator.pop(context);
              },
              icon:Icon(Icons.arrow_back,
              size: size.width*0.06,
                color: Colors.white,
              ),
            ),
            title: Text("History",style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.05
            ),),
          ),
          body: ListView.builder(
            itemCount: state.denominationList!.length,
            itemBuilder: (context, index) {
              var item = state.denominationList![index];
              return Slidable(
                key: ValueKey(item),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {}),
                  children: [
                    SlidableAction(
                      onPressed: (value){
                        cubitData.deleteListItem(item.id,index);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                    ),
                    const SlidableAction(
                      onPressed: null,
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                    ),
                    SlidableAction(
                      onPressed: (v){
                        String shareData ="";
                        var data = state.calculationList!.map((e) => "${e.initialValue.indianRupeeFormat()} x ${e.inputValueController.text} = ${e.finalValue.indianRupeeFormat()}\n").toList();
                        shareData = "Denomination\n${item.category}\n${item.remark}\n${formatDateTime(item.dateTime,"dd MMM yyyy")}\n${formatDateTime(item.dateTime,"hh:mm a")}\n\n ${data.join(" ")}";

                        Share.share(shareData,subject: 'Denomination');
                      },
                      backgroundColor:Colors.green,
                      foregroundColor: Colors.white,
                      icon: Icons.share,
                    ),
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.01),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(.3),
                    borderRadius: BorderRadius.circular(size.width * 0.03),
                  ),
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.category,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.038
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            item.totalValue.indianRupeeFormat(),
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * 0.065
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatDateTime(item.dateTime, "dd MMM yyyy"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * 0.036
                                ),
                              ),
                              Text(
                                formatDateTime(item.dateTime, "hh:mm a"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * 0.036
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        item.remark,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.038
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String formatDateTime(DateTime dateTime, String dateFormat) {
    return DateFormat(dateFormat).format(dateTime);
  }
}
