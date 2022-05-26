import 'package:demo_app/models/training_record.dart';
import 'package:demo_app/providers/training_item_model.dart';
import 'package:demo_app/providers/training_record_model.dart';
import 'package:demo_app/widgets/base/base_card_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreenTab extends StatelessWidget {
  static final String id = "Home";
  final CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Color(0xf56a79).withOpacity(0.9),
                Color(0xff414d).withOpacity(0.9),
              ],
              stops: const [
                0.1,
                0.9,
              ],
            ),
          ),
          child: TableCalendar(
            calendarController: _calendarController,
            calendarStyle: CalendarStyle(
              //平日のTextStyle
                weekdayStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                //土日のTextStyle
                weekendStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                //別の月の平日, 土日, 祝日のTextStyle
                outsideStyle: TextStyle(color: Colors.black45, fontSize: 18),
                outsideWeekendStyle:
                TextStyle(color: Colors.black45, fontSize: 18),
                outsideHolidayStyle:
                TextStyle(color: Colors.black45, fontSize: 18),
                selectedColor: Colors.white24,
                todayColor: Colors.black38),
            daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white, fontSize: 12),
                weekendStyle: TextStyle(color: Colors.white, fontSize: 12)),
            headerStyle: HeaderStyle(
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              titleTextBuilder: (DateTime dateTime, dynamic _) {
                return DateFormat(
                    "${DateFormat.ABBR_MONTH} ${DateFormat.YEAR}")
                    .format(dateTime);
              },
              centerHeaderTitle: true,
              formatButtonVisible: false,
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ),
            onDaySelected: (DateTime day, List events, List holidays) {
              Provider.of<TrainingRecordModel>(context, listen: false)
                  .setDateTimeRange(
                  start: day.add(Duration(hours: -12, microseconds: -1)),
                  end: day.add(Duration(hours: 12, microseconds: -1)));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: Text(
            "記録(${DateFormat("yyyy年MM月dd日").format(Provider.of<TrainingRecordModel>(context).dateTimeRange.start.add(Duration(microseconds: 1)))})",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: _trainingRecordTileListView(context),
        ),
      ],
    );
  }

  Widget _trainingRecordTileListView(BuildContext context) {
    Map trainingRecordMap =
        Provider.of<TrainingRecordModel>(context).getDailyTrainingRecordMap(
      trainingRecordMap:
          Provider.of<TrainingRecordModel>(context).dailyTrainingRecordMap,
    );
    if (trainingRecordMap.length == 0) {
      return Text(
        "トレーニングの記録がありません。",
        style: TextStyle(color: Colors.grey),
      );
    } else {
      return ListView.builder(
        itemCount: trainingRecordMap.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime date = (trainingRecordMap.keys.toList()
            ..sort((a, b) => b.compareTo(a)))[index];
          List dateTrainingRecordList = trainingRecordMap[date];
          return Column(
            children: [
              roundedWidgetTile(
                  context: context,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat("yyyy/MM/dd").format(date) ?? "",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ),
                      Column(
                        children: List.generate(dateTrainingRecordList.length,
                            (index) {
                          TrainingRecord trainingRecord =
                              dateTrainingRecordList[index];
                          return _trainingRecordTile(context, trainingRecord);
                        }),
                      )
                    ],
                  )),
            ],
          );
        },
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      );
    }
  }

  Widget _trainingRecordTile(
      BuildContext context, TrainingRecord trainingRecord) {
    if (trainingRecord.trainingItemId == 2) {
      return _aerobicTrainingRecordTile(context, trainingRecord);
    } else {
      return _anaerobicTrainingRecordTile(context, trainingRecord);
    }
  }

  Widget _aerobicTrainingRecordTile(
      BuildContext context, TrainingRecord trainingRecord) {
    return roundedWidgetTile(
        context: context,
        color: Colors.redAccent[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(Provider.of<TrainingItemModel>(context)
                  .getTrainingItem(trainingRecord.trainingItemId)
                  .trainingName),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(trainingRecord.time.toString() ?? "",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  Text("min"),
                ],
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            )
          ],
        ));
  }

  Widget _anaerobicTrainingRecordTile(
      BuildContext context, TrainingRecord trainingRecord) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: roundedWidgetTile(
          context: context,
          color: Colors.redAccent[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Provider.of<TrainingItemModel>(context)
                          .getTrainingItem(trainingRecord.trainingItemId)
                          .trainingName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                        DateFormat("hh:mm").format(
                            DateTime.fromMillisecondsSinceEpoch(
                                trainingRecord.dateMillisecondsSinceEpoch)),
                        style: TextStyle(color: Colors.grey))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(trainingRecord.weight.toString() ?? "",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(trainingRecord.unit),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("×",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ),
                    Text(trainingRecord.count.toString() ?? "",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Text("回")
                  ],
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              )
            ],
          )),
    );
  }
}
