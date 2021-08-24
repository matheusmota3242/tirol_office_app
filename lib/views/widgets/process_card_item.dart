import 'package:flutter/material.dart';
import 'package:tirol_office_app/helpers/datetime_helper.dart';
import 'package:tirol_office_app/utils/route_utils.dart';
import 'package:tirol_office_app/models/process_model.dart';
import 'package:tirol_office_app/views/screens/processes/process_details_view_2.dart';

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

    return InkWell(
      onTap: () {
        if (!this.isProcessDetailsView)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProcessDetailsViewTwo(
                  edit: this.isProcessDetailsView ? false : true,
                  process: process),
            ),
          );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: isLastItem ? 0 : 16.0),
        shadowColor: Colors.transparent,
        child: Container(
          height: 100.0,
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Positioned(
                  child: Text(
                    process.getDepartment.name,
                    style: theme.textTheme.headline5,
                  ),
                  top: 0,
                  left: 0),
              Positioned(
                child:
                    /* Text(
                  process.getEnd == null ? 'Em andamento' : 'Finalizado',
                  style: TextStyle(
                      color: process.getEnd == null
                          ? Colors.yellow[600]
                          : Colors.green[600],
                      fontStyle: FontStyle.italic,
                      fontSize: 14.0),
                ), */
                    Container(
                  height: 24,
                  width: 24,
                  child: Icon(
                    process.getEnd == null
                        ? Icons.watch_later_outlined
                        : Icons.done_all,
                    color: Colors.white,
                    size: 16,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: process.getEnd == null
                          ? Colors.yellow
                          : Colors.green),
                ),
                top: 0,
                right: 0,
              ),
              Positioned(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Horário',
                    //   style: TextStyle(
                    //       fontSize: 15.0,
                    //       fontWeight: FontWeight.w400,
                    //       color: Colors.grey[700]),
                    // ),
                    // SizedBox(
                    //   height: 6.0,
                    // ),
                    process.getEnd != null
                        ? Text(
                            '${DateTimeHelper.formatTime(process.getStart)} | ${DateTimeHelper.formatTime(process.getEnd)}',
                            style: theme.textTheme.subtitle1,
                          )
                        : Text(
                            '${DateTimeHelper.formatTime(process.getStart)} | --:--',
                            style: theme.textTheme.subtitle1),
                  ],
                ),
                top: 40.0,
                right: 0,
              ),
              Positioned(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'Responsável',
                    //   style: TextStyle(
                    //       fontSize: 15.0,
                    //       fontWeight: FontWeight.w400,
                    //       color: Colors.grey[700]),
                    // ),
                    // SizedBox(
                    //   height: 6.0,
                    // ),
                    Text(
                      process.getResponsible,
                      style: theme.textTheme.subtitle1,
                    ),
                  ],
                ),
                top: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
