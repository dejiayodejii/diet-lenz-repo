# openapi.model.DashboardResponseDto

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**date** | [**DateTime**](DateTime.md) |  | [optional] 
**targets** | [**MacroTargetDto**](MacroTargetDto.md) |  | [optional] 
**actuals** | [**MacroActualDto**](MacroActualDto.md) |  | [optional] 
**performance** | [**MacroPerformanceDto**](MacroPerformanceDto.md) |  | [optional] 
**mealsToday** | [**List<MealLogResponseDto>**](MealLogResponseDto.md) |  | [optional] [default to const []]
**streaks** | [**StreakInfoDto**](StreakInfoDto.md) |  | [optional] 
**basicGoalMet** | **bool** |  | [optional] 
**macroGoalMet** | **bool** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


