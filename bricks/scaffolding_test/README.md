# scaffolding_test



## How to use 🚀

### Command Line

```
mason init
mason add scaffolding_test --git-url https://github.com/sjhorn/mason_bricks --git-path bricks/scaffolding_test
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

[Example Config](https://github.com/sjhorn/mason_bricks/tree/master/bricks/scaffolding_test/config_template.json):

```json
{
  "package": "scaffolding_sample",
  "feature": "feature1",
  "properties": "String firstName=Your first name, String lastName=Your surname, bool registered=false, int age=21"
}
```

## Outputs 📦

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