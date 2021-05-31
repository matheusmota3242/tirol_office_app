import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200.0,
                child: SvgPicture.asset('assets/images/tirol_office_empty.svg'),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Não há itens cadastrados',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
