* Encoding: UTF-8.
* Python extension macro to calculate sensitivity and specificity
* by Jamie DeCoster

* This program provides users with classification statistics (such as sensitivity
* and specificity) for the ability of a screener to predict the value of a test.

**** Usage: sensiSpeci(screen, test)
**** "screen" is a dummy-coded variable representing whether the screener
* identified a case as positive (value of 1) or negative (value of 0).
**** "test" is a dummy-coded variable representing whether the true value
* of a case is positive (value of 1) or negative (value of 0).

**** Example: sensiSpeci("BDI", "Diagnosis")
**** In this example, we are using the Beck Depression Inventory (BDI) to predict 
* whether or not an individual has been clinically diagnosed with depression
* (Diagnosis). "BDI" is a continuous measure, whereas "Diagnosis" is binary
* where a value of 0 means an individual is not depressed an a value of 1 means
* that an individual has been clinically diagnosed as being depressed. The 
* function would output classification statistics indicating how well the BDI was
* able to predict the true state of depression as indicated by the clinical
* diagnosis.

*********
* Version History
*********
* 2017-09-11 Created
* 2017-09-11 Added overall classification rate
* 2017-09-27 Added example

set printback = off.

begin program python.
import spss, spssaux
from spss import CellText

def sensiSpeci(screen, test):
# Show initial crosstab
     submitstring = """CROSSTABS
  /TABLES={0} BY {1}
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT 
  /COUNT ROUND CELL.""".format(screen, test)
     spss.Submit(submitstring)

# Suppress crosstab output
     submitstring = """OMS /SELECT ALL EXCEPT = [WARNINGS] 
    /DESTINATION VIEWER = NO 
    /TAG = 'NoJunk'."""
     spss.Submit(submitstring)

     cmd = """CROSSTABS
  /TABLES={0} BY {1}
  /FORMAT=AVALUE TABLES
  /CELLS=COUNT 
  /COUNT ROUND CELL.
    """.format(screen, test)
     handle,failcode=spssaux.CreateXMLOutput(
    		cmd,
    		omsid="Crosstabs",
    		subtype="Crosstabulation",
    		visible=False)
     result=spssaux.GetValuesFromXMLWorkspace(
    		handle,
    		tableSubtype="Crosstabulation",
    		cellAttrib="text")

     submitstring = """OMSEND TAG = 'NoJunk'."""
     spss.Submit(submitstring)

# TN: Screen = 0, Test = 0
     TN = float(result[0])
# FN: Screen = 0, Test = 1
     FN = float(result[1])
# FP: Screen = 1, Test = 0
     FP = float(result[3])
# TP: Screen = 1, Test = 1
     TP = float(result[4])

     sensitivity = TP/(TP+FN)
     specificity = TN/(TN+FP)
     PPV = TP/(TP+FP)
     NPV = TN/(TN+FN)
     FPR = FP/(FP+TN)
     FNR = FN/(TP+FN)
     FDR = FP/(TP+FP)
     OCR = (TP+TN)/(TP+TN+FP+FN)

# Put results into a pivot table
     spss.StartProcedure("SensiSpeci")
     table = spss.BasePivotTable("Classification Statistics", 
          "OMS Table Subtype")

     rowList = [CellText.String("Sensitivity"),
CellText.String("Specificity"),
CellText.String("Positive Predictive Value"),
CellText.String("Negative Predictive Value"),
CellText.String("False Positive Rate"),
CellText.String("False Negative Rate"),
CellText.String("False Discovery Rate"),
CellText.String("Overall Classification Rate")]

     valueList = [CellText.String('%.4f' % sensitivity),
CellText.String('%.4f' % specificity),
CellText.String('%.4f' % PPV),
CellText.String('%.4f' % NPV),
CellText.String('%.4f' % FPR),
CellText.String('%.4f' % FNR),
CellText.String('%.4f' % FDR),
CellText.String('%.4f' % OCR)]

     table.SimplePivotTable(rowdim = "Statistic",
rowlabels = rowList,
collabels = ["Value"],
cells = valueList)
     spss.EndProcedure()

     return valueList
end program python.

set printback = on.
