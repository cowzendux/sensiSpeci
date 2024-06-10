# sensiSpeci

SPSS Python Extension function to calculate sensitivity, specificity, and other measures of categorization accuracy

This and other SPSS Python Extension functions can be found at http://www.stat-help.com/python.html

## Usage
**sensiSpeci(screen, test)**
* "screen" is a dummy-coded variable representing whether the screener identified a case as positive (value of 1) or negative (value of 0).
* "test" is a dummy-coded variable representing whether the true value of a case is positive (value of 1) or negative (value of 0).

## Example
**Example: sensiSpeci(screen = "BDI",    
test = "Diagnosis")**
* In this example, we are using the Beck Depression Inventory (BDI) to predict whether or not an individual has been clinically diagnosed with depression (Diagnosis).
* "BDI" is a screener that is being used to predict "Diagnosis", which is an official result.
* Both variables are binary where a value of 0 means an individual is not depressed and a value of 1 means that an individual is depressed.
* The function would output classification statistics indicating how well the BDI was able to predict the true state of depression as indicated by the clinical diagnosis.
