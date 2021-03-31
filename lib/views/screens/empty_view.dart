import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
            style: Theme.of(context).textTheme.headline5,
          )
        ],
      ),
    );
  }
}
