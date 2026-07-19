import 'package:flutter/material.dart';
import 'package:bmi_calculator/components/bottom_container.dart';
import '../components/content_box.dart';
import '../components/reusable_box.dart';
import '../constants.dart';
import '../components/circular_button.dart';
import '../functions.dart';
import 'result_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

enum Gender {
  male,
  female,
}

class _InputPageState extends State<InputPage> {
  Gender selectedGender = Gender.male;
  int height = 180;
  int weight = 60;
  int age = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('BMI CALCULATOR'),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = Gender.male;
                  });
                },
                child: ReusableBox(
                  colour: selectedGender == Gender.male
                      ? cActiveCardColor
                      : cInactiveCardColor,
                  cardChild: const ContentBox(
                    icon: Icons.male,
                    text: 'Male',
                  ),
                ),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = Gender.female;
                  });
                },
                child: ReusableBox(
                  colour: selectedGender == Gender.female
                      ? cActiveCardColor
                      : cInactiveCardColor,
                  cardChild: const ContentBox(
                    icon: Icons.female,
                    text: 'Female',
                  ),
                ),
              ))
            ],
          )),
          Expanded(
              child: ReusableBox(
                  colour: cActiveCardColor,
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'HEIGHT',
                        style: cCardTextStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            height.toString(),
                            style: cDigitTextStyle,
                          ),
                          const Text(
                            'cm',
                            style: cCardTextStyle,
                          )
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: cSliderInactiveColor,
                          thumbColor: const Color(0xFFEB1555),
                          overlayColor: const Color(0x29EB1555),
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 15.0),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 35.0),
                        ),
                        child: Slider(
                          value: height.toDouble(),
                          min: 120,
                          max: 220,
                          onChanged: (double newValue) {
                            setState(() {
                              height = newValue.round();
                            });
                          },
                        ),
                      )
                    ],
                  ))),
          Expanded(
              child: Row(
            children: [
              Expanded(
                  child: ReusableBox(
                      colour: cActiveCardColor,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'WEIGHT',
                            style: cCardTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                weight.toString(),
                                style: cDigitTextStyle,
                              ),
                              const Text(
                                'kg',
                                style: cCardTextStyle,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularButton(
                                  icon: Icons.remove,
                                  onPressed: () {
                                    setState(() {
                                      if (weight > 0) {
                                        weight--;
                                      }
                                    });
                                  }),
                              const SizedBox(
                                width: 15,
                              ),
                              CircularButton(
                                  icon: Icons.add,
                                  onPressed: () {
                                    setState(() {
                                      weight++;
                                    });
                                  })
                            ],
                          )
                        ],
                      ))),
              Expanded(
                  child: ReusableBox(
                      colour: cActiveCardColor,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'AGE',
                            style: cCardTextStyle,
                          ),
                          Text(
                            age.toString(),
                            style: cDigitTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularButton(
                                  icon: Icons.remove,
                                  onPressed: () {
                                    setState(() {
                                      if (age > 0) {
                                        age--;
                                      }
                                    });
                                  }),
                              const SizedBox(
                                width: 15,
                              ),
                              CircularButton(
                                  icon: Icons.add,
                                  onPressed: () {
                                    setState(() {
                                      age++;
                                    });
                                  })
                            ],
                          )
                        ],
                      )))
            ],
          )),
          BottomContainer(
              text: 'Calculate',
              onTap: () {
                BmiCalculator calc =
                    BmiCalculator(height: height, weight: weight);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      bmi: calc.result(),
                      resultText: calc.getText(),
                      advice: calc.getAdvice(),
                      textColor: calc.getTextColor(),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
