import 'package:flutter/material.dart';
import 'package:tirol_office_app/models/process_model.dart';

class ProcessCardItem extends StatelessWidget {
  final Process process;

  const ProcessCardItem({Key key, this.process}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132.0,
      child: Card(
        shadowColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Positioned(
                  child: Text(
                    process.getDepartmentId,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800]),
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
                          color: Colors.grey[800]),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      process.start.hour.toString() +
                          ':' +
                          process.start.minute.toString() +
                          " | " +
                          process.end?.hour.toString() +
                          ":" +
                          process.end?.minute.toString(),
                      style: TextStyle(fontSize: 15.0, color: Colors.grey[800]),
                    ),
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
                          color: Colors.grey[800]),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      process.getResponsible,
                      style: TextStyle(fontSize: 15.0, color: Colors.grey[800]),
                    ),
                  ],
                ),
                top: 80.0,
              ),
              Positioned(
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  right: 0,
                  top: 22.0)
            ],
          ),
        ),
      ),
    );
  }
}
