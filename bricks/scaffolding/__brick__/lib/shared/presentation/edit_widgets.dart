import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditWidget<T> extends StatelessWidget {
  final Function(BuildContext, T) changedEvent;
  final Function(BuildContext) submittedEvent;
  final T Function(BuildContext) initialValue;
  final String labelText;

  const EditWidget({
    required this.labelText,
    required this.initialValue,
    required this.changedEvent,
    required this.submittedEvent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (T) {
      case double:
        return TextFormField(
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,}'))
          ],
          initialValue: _castToString(T, initialValue(context)),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: labelText),
          onChanged: (value) =>
              changedEvent(context, _castFromString(T, value)),
          onEditingComplete: () => submittedEvent(context),
        );
      case int:
        return TextFormField(
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          initialValue: _castToString(T, initialValue(context)),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: labelText),
          onChanged: (value) =>
              changedEvent(context, _castFromString(T, value)),
          onEditingComplete: () => submittedEvent(context),
        );
      case bool:
        bool value = initialValue(context) as bool;
        return FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          descendantsAreFocusable: false,
          shortcuts: {
            const SingleActivator(LogicalKeyboardKey.enter): VoidCallbackIntent(
              () => submittedEvent(context),
            )
          },
          actions: {
            ActivateIntent: CallbackAction<Intent>(onInvoke: (_) {
              changedEvent(context, !value as T);
            }),
          },
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Focus.of(context).requestFocus();
                changedEvent(context, !value as T);
              },
              child: InputDecorator(
                isFocused: Focus.of(context).hasFocus,
                decoration: InputDecoration(
                  labelText: labelText,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Checkbox(
                      value: value,
                      onChanged: (value) {
                        Focus.of(context).requestFocus();
                        changedEvent(context, value! as T);
                      }),
                ),
              ),
            ),
          ),
        );
      default:
        return TextFormField(
          autofocus: true,
          keyboardType: TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          initialValue: _castToString(T, initialValue(context)),
          textInputAction: TextInputAction.done,
          maxLength: 255,
          decoration: InputDecoration(labelText: labelText),
          onChanged: (value) =>
              changedEvent(context, _castFromString(T, value)),
          onEditingComplete: () => submittedEvent(context),
        );
    }
  }

  String _castToString(Type type, dynamic value) {
    switch (type) {
      case String:
        return value;
      default:
        return '${value}';
    }
  }

  dynamic _castFromString(Type type, String value) {
    switch (type) {
      case double:
        try {
          return double.parse(value);
        } catch (e) {
          return 0.0;
        }
      case int:
        try {
          return int.parse(value);
        } catch (e) {
          return 0;
        }
      default:
        return value;
    }
  }
}
