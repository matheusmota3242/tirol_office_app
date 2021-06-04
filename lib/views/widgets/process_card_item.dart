import 'package:flutter/material.dart';
import 'package:tirol_office_app/helpers/datetime_helper.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/models/process_model.dart';

class ProcessCardItem extends StatelessWidget {
  final Process process;
  final bool isProcessDetailsView;
  final bool isLastItem;

  const ProcessCardItem(
      {Key key, this.process, this.isProcessDetailsView, this.isLastItem})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: isLastItem ? 0 : 16.0),
      shadowColor: Colors.transparent,
      child: Container(
        height: 182.0,
        padding: EdgeInsets.all(20.0),
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
                            context, RouteUtils.processDetails,
                            arguments: {
                              'process': process,
                              'isProcessDetailsView':
                                  this.isProcessDetailsView ? false : true
                            }),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Horário',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700]),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  process.getEnd != null
                      ? Text(
                          '${DateTimeHelper.formatTime(process.getStart)} | ${DateTimeHelper.formatTime(process.getEnd)}',
                          style: theme.textTheme.subtitle1,
                        )
                      : Text(
                          '${DateTimeHelper.formatTime(process.getStart)} | --:--',
                          style: theme.textTheme.bodyText1),
                ],
              ),
              top: 40.0,
            ),
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Responsável',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700]),
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    process.getResponsible,
                    style: theme.textTheme.subtitle1,
                  ),
                ],
              ),
              top: 100.0,
            ),
          ],
        ),
      ),
    );
  }
}
