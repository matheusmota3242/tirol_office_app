import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:tirol_office_app/models/observation_model.dart';
import 'package:tirol_office_app/service/observation_service.dart';
import 'package:tirol_office_app/service/user_service.dart';
import 'package:tirol_office_app/utils/page_utils.dart';
import 'package:tirol_office_app/views/widgets/toast.dart';

class ObservationFormView extends StatefulWidget {
  final bool edit;
  final Observation observation;

  const ObservationFormView({Key key, @required this.edit, this.observation})
      : super(key: key);
  @override
  _ObservationFormViewState createState() => _ObservationFormViewState();
}

class _ObservationFormViewState extends State<ObservationFormView>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _key = GlobalKey();
  AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.initState();
  }

  getScreenTitle() => widget.edit ? 'Editar observação' : 'Nova observação';

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    ObservationService _service = ObservationService();
    var user = Provider.of<UserService>(context).getUser;
    bool isEditing() => widget.edit;
    setAuthor(user.name);
    void submit() {
      String msg = '';
      if (_key.currentState.validate()) {
        if (isEditing()) {
          _service.update(widget.observation);
          msg = 'Departamendo editado com sucesso';
        } else {
          _service.save(widget.observation);
          msg = 'Departamendo salvo com sucesso';
        }
        Navigator.pop(context);
        Toasts.showToast(content: msg);
      }
    }

    void pop() => Navigator.pop(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(getScreenTitle()),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(PageUtils.fabIcons.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                    0.0, 1.0 - index / PageUtils.fabIcons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: PageUtils.fabIconsColors[index],
                mini: true,
                child: Icon(PageUtils.fabIcons[index], color: Colors.white),
                // !!!build
                onPressed: () => index == 0 ? submit() : pop(),
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            FloatingActionButton(
              backgroundColor: themeData.buttonColor,
              heroTag: null,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Transform(
                  transform: new Matrix4.rotationZ(
                      _animationController.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: Icon(_animationController.isDismissed
                      ? Icons.share
                      : Icons.close),
                ),
              ),
              onPressed: () {
                if (_animationController.isDismissed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
            ),
          ),
      ),
      body: Container(
        padding: EdgeInsets.all(PageUtils.bodyPadding),
        child: Form(
          key: _key,
          child: ListView(
            children: [
              observationTitleField(),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.grey[600],
              ),
              SizedBox(
                height: 10.0,
              ),
              observationContentField()
            ],
          ),
        ),
      ),
    );
  }

  Widget observationTitleField() {
    TextEditingController controller =
        TextEditingController(text: widget.observation?.title);

    return Container(
      child: TextFormField(
        onChanged: (value) => setTitle(value),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        controller: controller,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: 'Título',
          labelStyle: TextStyle(
              color: Colors.grey[700],
              height: 0.9,
              fontWeight: FontWeight.w600),
          filled: true,
          counterStyle: TextStyle(color: Colors.red),
          hintText: 'Título...',
          contentPadding: EdgeInsets.only(
            left: 10.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget observationContentField() {
    TextEditingController controller =
        TextEditingController(text: widget.observation?.content);
    return Container(
      child: TextFormField(
        onChanged: (value) => setContent(value),
        validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        controller: controller,
        maxLines: 8,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: 'Conteúdo',
          labelStyle: TextStyle(
              color: Colors.grey[700],
              height: 0.9,
              fontWeight: FontWeight.w600),
          filled: true,
          counterStyle: TextStyle(color: Colors.red),
          hintText: 'Conteúdo...',
          contentPadding: EdgeInsets.only(left: 10.0, top: 24.0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  setTitle(String title) => widget.observation.title = title;

  setContent(String content) => widget.observation.content = content;

  setAuthor(String author) => widget.observation.author = author;
}
