<p align="center">
<img src="https://raw.githubusercontent.com/sjhorn/scaffolding/master/assets/scaffolding_full.png" height="125" alt="scaffolding logo" />
</p>
<p align="center">
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://github.com/felangel/mason"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge" alt="Powered by Mason"></a>
</p>
# scaffolding_test

![Unit Test generation](https://raw.githubusercontent.com/sjhorn/mason_bricks/main/bricks/scaffolding/test_coverage.png)

## How to use 🚀

### Command Line

```
mason init
mason add scaffolding_test
mason make scaffolding_test --package scaffolding_sample --feature feature1 --properties "String firstName=Your first name, String lastName=Your surname, bool registered=false, int age=21"
```
Then add your properties! (Optional)

## Variables for the Command Line and Config Json ✨

| Variable         | Description                                                | Default                                   | Type     |
| -----------------| ---------------------------------------------------------- | ----------------------------------------- | -------- |
| `package`        | The name of the package this is generated into             | scaffolding_sample                        | `string` |
| `feature`        | The name of the feature                                    | feature1                                  | `string` |
| `properties`     | string of the properties of this feature (string,bool,num) |                                           | `string` |
### Config

`mason make scaffolding_test -c config_template.json`

[Example Config](https://github.com/sjhorn/mason_bricks/tree/main/bricks/scaffolding_test/config_template.json):

```json
{
  "package": "scaffolding_sample",
  "feature": "feature1",
  "properties": "String firstName=Your first name, String lastName=Your surname, bool registered=false, int age=21"
}
```

## Outputs 📦
```
--package scaffolding_sample --feature feature1 --properties "String firstName=Your first name, String lastName=Your surname, bool registered=false, int age=21"
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