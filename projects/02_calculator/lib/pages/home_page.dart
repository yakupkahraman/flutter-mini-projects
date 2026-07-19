import 'package:calculator/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String operation = "";
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text("Calculator"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  width: deviceWidth,
                  alignment: Alignment.centerRight,
                  height: 200,
                  child: Text(
                    operation,
                    style: const TextStyle(
                        fontSize: 70, fontWeight: FontWeight.w300),
                  )),
              const Divider(
                indent: 25,
                endIndent: 25,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      EraserButton(
                        mytext: "C",
                        onPressed: () {
                          setState(() {
                            if (operation.isNotEmpty) {
                              operation =
                                  operation.substring(0, operation.length - 1);
                            }
                          });
                        },
                      ),
                      EraserButton(
                        mytext: "AC",
                        onPressed: () {
                          setState(() {
                            operation = "";
                          });
                        },
                      ),
                      OperateButton(
                        mytext: "%",
                        onPressed: () {
                          setState(() {
                            operation += "%";
                          });
                        },
                      ),
                      OperateButton(
                        mytext: "/",
                        onPressed: () {
                          setState(() {
                            operation += "/";
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NumberButton(
                        mytext: "7",
                        onPressed: () {
                          setState(() {
                            operation += "7";
                          });
                        },
                      ),
                      NumberButton(
                        mytext: "8",
                        onPressed: () {
                          setState(() {
                            operation += "8";
                          });
                        },
                      ),
                      NumberButton(
                        mytext: "9",
                        onPressed: () {
                          setState(() {
                            operation += "9";
                          });
                        },
                      ),
                      OperateButton(
                        mytext: "*",
                        onPressed: () {
                          setState(() {
                            operation += "*";
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NumberButton(
                        mytext: "4",
                        onPressed: () {
                          setState(() {
                            operation += "4";
                          });
                        },
                      ),
                      NumberButton(
                        mytext: "5",
                        onPressed: () {
                          setState(() {
                            operation += "5";
                          });
                        },
                      ),
                      NumberButton(
                        mytext: "6",
                        onPressed: () {
                          setState(() {
                            operation += "6";
                          });
                        },
                      ),
                      OperateButton(
                        mytext: "-",
                        onPressed: () {
                          setState(() {
                            operation += "-";
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NumberButton(
                        mytext: "1",
                        onPressed: () {
                          setState(() {
                            operation += "1";
                          });
                        },
                      ),
                      NumberButton(
                        mytext: "2",
                        onPressed: () {
                          setState(() {
                            operation += "2";
                          });
                        },
                      ),
                      NumberButton(
                        mytext: "3",
                        onPressed: () {
                          setState(() {
                            operation += "3";
                          });
                        },
                      ),
                      OperateButton(
                        mytext: "+",
                        onPressed: () {
                          setState(() {
                            operation += "+";
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OperateButton(
                        mytext: "+/-",
                        onPressed: () {
                          setState(() {
                            if (operation.startsWith("-")) {
                              operation = operation.substring(1);
                            } else if (operation.isNotEmpty) {
                              operation = "-$operation";
                            }
                          });
                        },
                      ),
                      NumberButton(
                        mytext: "0",
                        onPressed: () {
                          setState(() {
                            operation += "0";
                          });
                        },
                      ),
                      NumberButton(
                        mytext: ".",
                        onPressed: () {
                          setState(() {
                            operation += ".";
                          });
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            try {
                              ShuntingYardParser parser = ShuntingYardParser();
                              Expression expression = parser.parse(operation);

                              ContextModel contextModel = ContextModel();
                              double result = expression.evaluate(
                                EvaluationType.REAL,
                                contextModel,
                              );

                              if (!result.isFinite) {
                                operation = "Error";
                              } else {
                                operation = result == result.roundToDouble()
                                    ? result.toInt().toString()
                                    : result.toString();
                              }
                            } catch (e) {
                              operation = "Error";
                            }
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.green),
                            overlayColor:
                                WidgetStatePropertyAll(Colors.green[800]),
                            shape: const WidgetStatePropertyAll(CircleBorder()),
                            minimumSize: WidgetStatePropertyAll(
                                Size(deviceWidth / 4 - 15, 100))),
                        child: const Text(
                          "=",
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
