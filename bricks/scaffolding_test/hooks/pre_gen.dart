import 'package:mason/mason.dart';

typedef PropertyList = List<Map<String, dynamic>>;

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final String properties = context.vars['properties'];
  if (properties.length == 0) {
    logger.alert('You have not specified any properties');
    throw Exception();
  }
  PropertyList propertyList = _parseProperties(properties, logger);

  logger
      .info(lightCyan.wrap('You have the following properties: $propertyList'));

  context.vars = {
    ...context.vars,
    'properties': propertyList,
  };
  logger.info(context.vars.toString());
}

PropertyList _parseProperties(String properties, Logger logger) {
  final PropertyList propertyList = [];
  final propertyEntries = properties.split(',');

  return propertyEntries.fold<PropertyList>(
    propertyList,
    (propertyList, propertyEntry) =>
        _addProperty(propertyList, logger, propertyEntry.trim()),
  );
}

PropertyList _addProperty(
    List<Map<String, dynamic>> properties, Logger logger, String property) {
  if (!property.contains(' ')) {
    logger.alert(
        'Your properties ($property) were not a valid format: Type property[=defaultValue]');
    throw Exception();
  }

  if ((property.contains('<') ||
      (property.contains('>')) &&
          property.allMatches('<').length != property.allMatches('>').length)) {
    logger.alert(
        'It seems you are missing a < or >, please retype this property');
    throw Exception();
  }
  String defaultValue = '';
  final splitDefaultValue = property.split('=');
  if (splitDefaultValue.length == 2) {
    defaultValue = splitDefaultValue[1];
  }
  String typeProperty = splitDefaultValue[0].trim();
  final splitProperty = typeProperty.trim().split(' ');
  if (splitProperty.length != 2) {
    logger.alert(
        'The format must be exactly: Type property and $typeProperty does not match this');
    throw Exception();
  }
  final propertyType = splitProperty[0].trim();
  final propertyName = splitProperty[1].trim();

  properties.add(_Property(
    name: propertyName,
    type: propertyType,
    defaultValue: defaultValue,
  ).toMap());
  return properties;
}

class _Property {
  final String name;
  final String type;
  String defaultValue;
  late final dynamic emptyValue;
  late final dynamic testValue;

  _Property({
    required this.name,
    required this.type,
    required this.defaultValue,
  }) {
    switch (type) {
      case 'String':
        emptyValue = "''";
        testValue = "'testString'";
        defaultValue =
            !defaultValue.startsWith("'") ? "'$defaultValue'" : defaultValue;
        break;
      case 'int':
        emptyValue = 0;
        testValue = 1;
        defaultValue = defaultValue == '' ? '${emptyValue}' : defaultValue;
        break;
      case 'double':
        emptyValue = 0.0;
        testValue = 1.1;
        defaultValue = defaultValue == '' ? '${emptyValue}' : defaultValue;
        break;
      case 'bool':
        emptyValue = false;
        testValue = true;
        defaultValue = defaultValue == '' ? '${emptyValue}' : defaultValue;
        break;
      default:
        throw Exception('Unsupported type for property');
    }
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'type': type,
        'defaultValue': defaultValue,
        'emptyValue': emptyValue,
        'testValue': testValue,
      };
}
