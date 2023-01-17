<p align="center">
<img src="https://raw.githubusercontent.com/sjhorn/scaffolding/master/assets/scaffolding_full.png" height="125" alt="scaffolding logo" />
</p>

<p align="center">
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://github.com/felangel/mason"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge" alt="Powered by Mason"></a>
</p>

# scaffolding_home_test brick

This generates the unit tests for home/index main and app files for a scaffolding app

## How to use 🚀

### Command Line

```
mason init
mason add scaffolding_home_test
mason make scaffolding_home_test --package scaffolding_sample --features feature1
```
Then add your properties! (Optional)

## Variables for the Command Line and Config Json ✨

| Variable         | Description                                                | Default                                   | Type     |
| -----------------| ---------------------------------------------------------- | ----------------------------------------- | -------- |
| `package`        | The name of the package this is generated into             | scaffolding_sample                        | `string` |
| `features`       | The name of the feature(s) to generate home/index for      | feature1                                  | `string` |
### Config

`mason make scaffolding_home_test -c scaffolding_config.json`

[Example Config](https://github.com/sjhorn/mason_bricks/tree/main/bricks/scaffolding_home/config_template.json):

```json
{
  "package": "scaffolding_sample",
  "features": "feature1"
}
```

## Outputs 📦

```
--package scaffolding_home_test --features feature1,feature2
test/
└─ scaffold_app_test.dart
```

