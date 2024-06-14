import 'package:denomination/views/denominationList/denominationList.dart';
import 'package:denomination/views/homeScreen/homeScreenCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:spelling_number/spelling_number.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocBuilder<HomeScreenCubit, HomeState>(
      builder: (context, state) {
        var cubitData = context.read<HomeScreenCubit>();
        return true
            ? Scaffold(
                floatingActionButton: SpeedDial(
                    backgroundColor: Colors.blue,
                    icon: Icons.send,
                    children: [
                      SpeedDialChild(
                        child: const Icon(Icons.clear_all_rounded),
                        label: "Clear",
                        onTap: () {
                        },
                      ),
                      SpeedDialChild(
                        child: const Icon(Icons.save_alt),
                        label: "Save All",
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          saveDenominationAlertDialog(context, cubitData);
                        },
                      ),
                    ]),
                backgroundColor: Colors.black,
                body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 90.0,
                        pinned: true,
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PopupMenuButton(
                              constraints: BoxConstraints(
                                minWidth: size.width * 0.30,
                                maxWidth: size.width * 0.30,
                              ),
                              onSelected: (value) {},
                              itemBuilder: (BuildContext bc) {
                                return [
                                  const PopupMenuItem(
                                      value: 'history',
                                      child: Text("history")),
                                ];
                              },
                              child: PopupMenuButton(
                                  constraints: BoxConstraints(
                                    minWidth: size.width * 0.30,
                                    maxWidth: size.width * 0.30,
                                  ),
                                  onSelected: (value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const DenominationList()));
                                  },
                                  itemBuilder: (BuildContext bc) {
                                    return [
                                      const PopupMenuItem(
                                          value: 0,
                                          child: Text("History")),
                                    ];
                                  },
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ],
                        flexibleSpace: Stack(
                          children: <Widget>[
                            Positioned.fill(
                                child: Image.asset(
                              'assets/images/currency_banner.jpg',
                              fit: BoxFit.cover,
                            )),
                            Positioned(
                              top: 20,
                              left: 10,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.calculationList!
                                        .fold(
                                            0.0,
                                            (previousValue, element) =>
                                                previousValue +
                                                element.finalValue)
                                        .indianRupeeFormat(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.07,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${SpellingNumber().convert(state.calculationList!.fold(0.0, (previousValue, element) => previousValue + element.finalValue))} only /-",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: size.width * 0.03,
                                  )
                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                    ];
                  },
                  body: Padding(
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: ListView.builder(
                        itemCount: state.calculationList!.length,
                        itemBuilder: (context, index) {
                          var item = state.calculationList![index];
                          return Padding(
                            padding: EdgeInsets.all(size.width * 0.01),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Text(
                                      item.initialValue.indianRupeeFormat(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.width * 0.05),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.04,
                                    ),
                                    Text(
                                      "x",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.width * 0.05),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: TextFormField(
                                  controller: item.inputValueController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: size.width * 0.05),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.all(size.width * 0.02),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        item.inputValueController.text = "";
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                    ),
                                    suffixStyle:
                                        const TextStyle(color: Colors.grey),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    filled: true,
                                    fillColor: Colors.blueGrey.withOpacity(.3),
                                    // filled: true,
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.02),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.02),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.02),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.02),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey, width: 1),
                                      borderRadius: BorderRadius.circular(
                                          size.width * 0.02),
                                    ),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]"))
                                  ],
                                  onChanged: (value) {
                                    cubitData.updateValue(value, index);
                                  },
                                )),
                                SizedBox(
                                  width: size.width * 0.03,
                                ),
                                Text(
                                  "=",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: size.width * 0.05),
                                ),
                                SizedBox(
                                  width: size.width * 0.04,
                                ),
                                Expanded(
                                    child: Text(
                                  item.finalValue.indianRupeeFormat(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: size.width * 0.055),
                                )),
                              ],
                            ),
                          );
                        }),
                  ),
                ))
            : Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text("Denomination"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DenominationList()));
                        },
                        child: Text("History"))
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.calculationList!
                            .fold(
                                0.0,
                                (previousValue, element) =>
                                    previousValue + element.finalValue)
                            .indianRupeeFormat(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(SpellingNumber().convert(state.calculationList!.fold(
                          0.0,
                          (previousValue, element) =>
                              previousValue + element.finalValue))),
                      Expanded(
                        child: ListView.builder(
                            itemCount: state.calculationList!.length,
                            itemBuilder: (context, index) {
                              var item = state.calculationList![index];
                              return Padding(
                                padding: EdgeInsets.all(size.width * 0.01),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Row(
                                      children: [
                                        Text(
                                          item.initialValue.indianRupeeFormat(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: size.width * 0.05),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.04,
                                        ),
                                        Text(
                                          "x",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: size.width * 0.05),
                                        ),
                                      ],
                                    )),
                                    Expanded(
                                        child: TextFormField(
                                      controller: item.inputValueController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        suffixStyle:
                                            const TextStyle(color: Colors.grey),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        filled: true,
                                        fillColor:
                                            Colors.blueGrey.withOpacity(.3),
                                        // filled: true,
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blueGrey, width: 1),
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.02),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blueGrey, width: 1),
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.02),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blueGrey, width: 1),
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.02),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blueGrey, width: 1),
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.02),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blueGrey, width: 1),
                                          borderRadius: BorderRadius.circular(
                                              size.width * 0.02),
                                        ),
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9.]"))
                                      ],
                                      onChanged: (value) {
                                        cubitData.updateValue(value, index);
                                      },
                                    )),
                                    SizedBox(
                                      width: size.width * 0.03,
                                    ),
                                    Text(
                                      "=",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.width * 0.05),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.04,
                                    ),
                                    Expanded(
                                        child: Text(
                                      item.finalValue.indianRupeeFormat(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.width * 0.055),
                                    )),
                                  ],
                                ),
                              );
                            }),
                      ),
                      TextButton(onPressed: () {}, child: Text("Confirm"))
                    ],
                  ),
                ),
              );
      },
    );
  }

  saveDenominationAlertDialog(BuildContext context, HomeScreenCubit cubitData) {
    var size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: EdgeInsets.all(size.width * 0.03),
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.02),
                color: Colors.grey.shade300,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size.width * 0.02),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            CupertinoIcons.clear,
                            color: Colors.red,
                          )),
                    ),
                    TextFormField(
                      controller: cubitData.categoryController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.035),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(size.width * 0.02),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blue,
                          ),
                        ),
                        suffixStyle: const TextStyle(color: Colors.grey),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(.3),
                        // filled: true,
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.02),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                      ],
                    ),
                    SizedBox(
                      height: size.width * 0.05,
                    ),
                    TextFormField(
                      controller: cubitData.remarkController,
                      maxLines: 3,
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.035),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(size.width * 0.02),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(.3),
                        // filled: true,
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius:
                          BorderRadius.circular(size.width * 0.02),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius:
                          BorderRadius.circular(size.width * 0.02),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius:
                          BorderRadius.circular(size.width * 0.02),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius:
                          BorderRadius.circular(size.width * 0.02),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueGrey, width: 1),
                          borderRadius:
                          BorderRadius.circular(size.width * 0.02),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.width * 0.05,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          cubitData.saveDenomination(
                              cubitData.categoryController.text,
                              cubitData.remarkController.text);

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          // Text color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * 0.04),
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontSize: size.width * 0.04),
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
