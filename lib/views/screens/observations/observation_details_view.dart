import 'package:flutter/material.dart';
import 'package:tirol_office_app/helpers/datetime_helper.dart';
import 'package:tirol_office_app/models/observation_model.dart';
import 'package:tirol_office_app/utils/page_utils.dart';

class ObservationDetailsView extends StatelessWidget {
  final Observation observation;

  ObservationDetailsView({Key key, @required this.observation})
      : super(key: key);
  static const String AUTHOR_LABEL = 'Autor';
  static const String DATETIME_LABEL = 'Data e hora';
  static const String TITLE_LABEL = 'Título';
  static const String CONTENT_LABEL = 'Conteúdo';

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = observation.dateTime;
    return Scaffold(
      appBar: AppBar(
        title: Text(PageUtils.observations),
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(PageUtils.bodyPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            observationAttribute(AUTHOR_LABEL, observation.author),
            separator,
            observationAttribute(DATETIME_LABEL,
                '${DateTimeHelper.convertIntToStringWeekday(dateTime.weekday)}, ${dateTime.day} de ${DateTimeHelper.convertIntToStringMonth(dateTime.month)} de ${dateTime.year} às ${DateTimeHelper.formatTime(dateTime)}'),
            separator,
            observationAttribute(TITLE_LABEL, observation.title),
            separator,
            observationAttribute(CONTENT_LABEL,
                'ob servati on.contento bserva tion.c ontentobse rvation.contentob servation.content')
          ],
        ),
      ),
    );
  }

  Widget observationAttribute(String label, String value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget separator = Column(
    children: [
      SizedBox(
        height: 12.0,
      ),
      Container(
        width: double.maxFinite,
        height: 0.5,
        color: Colors.grey[400],
      ),
      SizedBox(
        height: 12.0,
      ),
    ],
  );
}