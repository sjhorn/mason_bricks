<p align="center">
<img src="https://raw.githubusercontent.com/sjhorn/scaffolding/main/assets/scaffolding_full.png" height="125" alt="scaffolding logo" />
</p>

<p align="center">
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://github.com/felangel/mason"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge" alt="Powered by Mason"></a>
</p>

# Scaffolding

A brick to scaffold a flutter application for CRUD (Create, Read, Update and Delete)!

This is based on [rails](https://guides.rubyonrails.org/v3.2/getting_started.html#getting-up-and-running-quickly-with-scaffolding) and [grails](https://docs.grails.org/5.2.5/guide/single.html#scaffolding) scaffolding.

Lots of ideas, structure and approach lifted directly from their documentation, source code and my own prior experience using the scaffolding approach in grails/rails to bootstrap **CRUD** web application. 

In creating this brick I thought why not try take these learning/reduce boilerplate benefits to flutter / dart even if only to help quickly educate the patterns in building, testing and scaling a CRUD application using  state management in BLoC (Business logic controller) and unit tests. 

Please note this has nothing to do with the flutter Scaffold (https://api.flutter.dev/flutter/material/Scaffold-class.html) material class widget.

## Samples screens

![Home Scaffolding](https://raw.githubusercontent.com/sjhorn/mason_bricks/main/bricks/scaffolding/home_scaffold.png)
![Feature Scaffolding](https://raw.githubusercontent.com/sjhorn/mason_bricks/main/bricks/scaffolding/feature1_scaffold.png)


## Table of Contents

- [How to use](#how-to-use-🚀)
  - [Scaffolding from Command Line](#command-line)
  - [Scaffolding from Config](#config)
- [Outputs](#outputs)

## How to use 🚀

### Simple flutter project

Start with a simple flutter project and add the following dependencies

```
equatable
uuid
flutter_bloc
```
For the generated unit test you will also need
```
mockito
bloc_test
```

The steps to add from the command line would be:
```
flutter create scaffolding_sample
cd scaffolding_sample
flutter pub add equatable uuid flutter_bloc
flutter pub add mocktail bloc_test --dev
```
Next setup mason to scaffold your code.

### Command Line

```
mason init
mason add scaffolding
mason make scaffolding --package scaffolding_sample --feature feature1 --properties "String firstName=Your first name, String lastName=Your surname, bool registered=false, int age=21" --generate-tests true --generate-home true
```

To confirm the tests are all passing with full coverage run the following from the based of the project (noting the removal of the widget_test from flutter create):
```
rm test/widget_test.dart 
flutter test --coverage && genhtml -p ${PWD}/lib -o coverage coverage/lcov.info && open coverage/index.html
```
You should see a result similar to the image below in your browser. 
![Unit Test generation](https://raw.githubusercontent.com/sjhorn/mason_bricks/main/bricks/scaffolding/test_coverage.png)

## Variables for the Command Line and Config Json ✨

| Variable         | Description                                                | Default                                   | Type     |
| -----------------| ---------------------------------------------------------- | ----------------------------------------- | -------- |
| `package`        | The name of the package this is generated into             | scaffolding_sample                        | `string` |
| `feature`        | The name of the feature                                    | feature1                                  | `string` |
| `properties`     | string of the properties of this feature (string,bool,num) |                                           | `string` |
| `generate_tests` | Generate units tests using scaffolding-tests brick         | true                                      | `boolean`   |
| `generate_home`  | Generate home/main files tests using scaffolding-main brick| false                                     | `boolean`   |
### Config

`mason make scaffolding -c scaffolding_config.json`

[Example Config](https://github.com/sjhorn/mason_bricks/tree/main/bricks/scaffolding/config_template.json):

```json
{
  "package": "scaffolding_sample",
  "feature": "feature1",
  "generate-tests": true, // true or false
  "generate-home": true, // true or false
  "properties": "String firstName=Your first name, String lastName=Your surname, bool registered=false, int age=21"
}
```

## Outputs 📦

```
--package scaffolding_sample --feature feature1 --properties "String firstName=Your first name, String lastName=Your surname, bool registered=false, int age=21" --generate-tests true --generate-home true
lib/
├─ features/
│  └─ feature1/
│     ├─ data/
│     │  ├─ feature1_model.dart
│     │  └─ feature1_repository_impl.dart
│     ├─ domain/
│     │  ├─ feature1_repository.dart
│     │  └─ feature1.dart
│     └─ presentation/
│        ├─ bloc/
│        │  ├─ feature1_edit_bloc.dart
│        │  ├─ feature1_edit_event.dart
│        │  ├─ feature1_edit_state.dart
│        │  ├─ feature1_read_bloc.dart
│        │  ├─ feature1_read_event.dart
│        │  └─ feature1_read_state.dart
│        └─ views/
│           ├─ feature1_edit_view.dart
│           └─ feature1_read_view.dart
└─ shared/
   └─ presentation/
         └─ list_table.dart
```

Files from the scaffolding_test and scaffolding_main that are included for the options `--generate-tests true --generate-home true`

When `--generate-test` true
```
test/
└─ features/
   └─ feature1/
      ├─ data/
      │  ├─ feature1_model_test.dart
      │  └─ feature1_repository_impl_test.dart
      ├─ domain/
      │  └─ feature1_test.dart
      └─ presentation/
         ├─ bloc/
         │  ├─ feature1_edit_bloc_test.dart
         │  └─ feature1_read_bloc_test.dart
         └─ views/
            ├─ feature1_edit_view_test.dart
            └─ feature1_read_view_test.dart
```

When `--generate-home` true
```
lib/
├─ main.dart
└─ scaffold_app.dart
```

When both `--generate-home true` and `--generate-test true`
```
test/
└─ scaffold_app_test.dart
```