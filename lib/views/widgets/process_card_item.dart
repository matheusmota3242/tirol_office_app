import 'package:flutter/material.dart';
import 'package:tirol_office_app/helpers/datetime_helper.dart';
import 'package:tirol_office_app/helpers/route_helper.dart';
import 'package:tirol_office_app/models/process_model.dart';

class ProcessCardItem extends StatelessWidget {
  final Process process;
  final bool isProcessDetailsView;

  const ProcessCardItem({Key key, this.process, this.isProcessDetailsView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final DateTimeHelper _dateTimeHelper = DateTimeHelper();
    final theme = Theme.of(context);

    return Container(
      height: 132.0,
      child: Card(
        shadowColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Positioned(
                  child: this.isProcessDetailsView
                      ? Text(
                          process.getDepartmentId,
                          style: theme.textTheme.headline5,
                        )
                      : GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, RouteHelper.processDetails,
                              arguments: {'process': process}),
                          child: Text(
                            process.getDepartmentId,
                            style: theme.textTheme.headline5,
                          ),
                        ),
                  top: 0,
                  left: 0),
              Positioned(
                child: Text(
                  process.getEnd == null ? 'Em andamento' : 'Finalizado',
                  style: TextStyle(
                      color: process.getEnd == null
                          ? Colors.yellow[600]
                          : Colors.green[600],
                      fontStyle: FontStyle.italic,
                      fontSize: 14.0),
                ),
                top: 0,
                right: 0,
              ),
              Positioned(
                child: Row(
                  children: [
                    Text(
                      'Horário:',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    process.getEnd != null
                        ? Text(
                            '${_dateTimeHelper.formatTime(process.getStart)} | ${_dateTimeHelper.formatTime(process.getEnd)}',
                            style: theme.textTheme.bodyText1,
                            // process.start.hour.toString() +
                            //     ':' +
                            //     process.start.minute.toString() +
                            //     " | " +
                            //     process.end?.hour.toString() +
                            //     ":" +
                            //     process.end?.minute.toString(),
                          )
                        : Text(
                            '${_dateTimeHelper.formatTime(process.getStart)} | --:--',
                            style: theme.textTheme.bodyText1),
                  ],
                ),
                top: 40.0,
              ),
              Positioned(
                child: Row(
                  children: [
                    Text(
                      'Responsável:',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      process.getResponsible,
                      style: theme.textTheme.bodyText1,
                    ),
                  ],
                ),
                top: 80.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
