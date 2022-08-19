# Readme
## _Transient global amnesia recurrence: prevalence and risk factor meta-analysis_


The following dataset and code was created as a part of the homonimous paper 
Ref: NEURCLINPRACT/2021/070078

Authors: Micaela Anahí Hernández, Julieta E Arena, Lucas Alessandro, Ricardo Francisco Allegri, and Ismael L Calandri

contact: icalandri@fleni.org.ar

The full package contains
- a dataset: **TGA_recurrence_metanalysis_dataset.csv**
- a R script: **TGA_recurrence_script.R**


To know more about the methods  of data adquisition and selection please visit the 
protocol registered in the international prospective register of systematic reviews PROSPERO (registration number PROSPERO 2021 CRD42021249506). 

for Markdown's syntax, type some text into the left window and
watch the results in the right.

## Data dictionary

| Variable                     | Meaning                                                                                                                   |
|------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| Study                        | Citation of the study                                                                                                     |
| Year                         | Year of publication of the study                                                                                          |
| Design                       | Methodological design ( case-control or cohort)                                                                           |
| total_subjects               | Number of subjects included in the study                                                                                  |
| TGA_subjects                 | Number of subjects with TGA diagnosis included in the study                                                               |
| TGA_rec_subjects             | Number of subjects with TGA diagnosis and recurrence (target event) included in the study                                 |
| TGA_definition               | Categorical variable showing wich set of criteria was used to defined TGA diagnosis in that study                         |
| Recurrence as a main outcome | Dicotomical variable showing if study was specifically designed to collect data about TGA recurrence or not               |
| Mean_Age_Total               | Mean age of the total of subjects included in the study                                                                   |
| Mean_Age_s-TGA               | Mean age of the TGA subjects without recurrence included in the study                                                     |
| Mean_Age_r-TGA               | Mean age of the TGA subjects with recurrence included in the study                                                        |
| SD_Age_Total                 | Standard deviation age of the total of subjects included in the study                                                     |
| SD_Age_s-TGA                 | Standard deviation age of the TGA subjects without recurrence included in the study                                       |
| SD_Age_r-TGA                 | Standard deviation age of the TGA subjects with recurrence included in the study                                          |
| Follow_up_time               | Follow-up time of the subjects (in months)                                                                                |
| female_n                     | Number of female TGA subjects                                                                                             |
| female_events                | Number of female TGA subjects with TGA recurrence (target event)                                                          |
| males_n                      | Number of male TGA subjects                                                                                               |
| male_events_n                | Number of male TGA subjects with TGA recurrence (target event)                                                            |
| HBP_n                        | Number of TGA subjects with high blood pressure                                                                           |
| HBP_event_n                  | Number of TGA subjects with high blood pressure and TGA recurrence (target event)                                         |
| noHBP_n                      | Number of TGA subjects without high blood pressure                                                                        |
| noHBP_events_n               | Number of TGA subjects without high blood pressure and TGA recurrence (target event)                                      |
| DLP_n                        | Number of TGA subjects with dyslipidemia                                                                                  |
| DLP_events_n                 | Number of TGA subjects with dyslipidemia and TGA recurrence (target event)                                                |
| noDLP_n                      | Number of TGA subjects without dyslipidemia                                                                               |
| noDLP_events_n               | Number of TGA subjects without dyslipidemia and TGA recurrence (target event)                                             |
| smoke_n                      | Number of TGA subjects with smoking history                                                                               |
| smoke_event_n                | Number of TGA subjects with smoking history and TGA recurrence (target event)                                             |
| nosmoke_n                    | Number of TGA subjects without smoking history                                                                            |
| nosmoke_event_n              | Number of TGA subjects without smoking history and TGA recurrence (target event)                                          |
| DBT_n                        | Number of TGA subjects with diabetes                                                                                      |
| DBT_events_n                 | Number of TGA subjects with diabetes and TGA recurrence (target event)                                                    |
| noDBT_n                      | Number of TGA subjects without diabetes                                                                                   |
| noDBT_event_n                | Number of TGA subjects without diabetes and TGA recurrence (target event)                                                 |
| stroke_n                     | Number of TGA subjects with stroke history                                                                                |
| stroke_events_n              | Number of TGA subjects with stroke history and TGA recurrence (target event)                                              |
| nostroke_n                   | Number of TGA subjects without stroke history                                                                             |
| nostroke_events_n            | Number of TGA subjects without stroke history and TGA recurrence (target event)                                           |
| CAD_n                        | Number of TGA subjects with coronary artery disease or myocardial infarction history                                      |
| CAD_events_n                 | Number of TGA subjects with coronary artery disease or myocardial infarction history and TGA recurrence (target event)    |
| noCAD_n                      | Number of TGA subjects without coronary artery disease or myocardial infarction history                                   |
| noCAD_events_n               | Number of TGA subjects without coronary artery disease or myocardial infarction history and TGA recurrence (target event) |
| AF_n                         | Number of TGA subjects with atrial fibrillation history                                                                   |
| AF_events_n                  | Number of TGA subjects with atrial fibrillation history and TGA recurrence (target event)                                 |
| noAF_n                       | Number of TGA subjects without atrial fibrillation history                                                                |
| noAF_events_n                | Number of TGA subjects without atrial fibrillation history and TGA recurrence (target event)                              |
| Migraine_n                   | Number of TGA subjects with migraine                                                                                      |
| Migraine_events_n            | Number of TGA subjects with migraine and TGA recurrence (target event)                                                    |
| noMigraine_n                 | Number of TGA subjects without migraine                                                                                   |
| noMigraine_events_n          | Number of TGA subjects without migraine and TGA recurrence (target event)                                                 |
| Depresion_n                  | Number of TGA subjects with depression history                                                                            |
| Depresion_events_n           | Number of TGA subjects with depression history and TGA recurrence (target event)                                          |
| noDepresion_n                | Number of TGA subjects without depression history                                                                         |
| noDepresion_events_n         | Number of TGA subjects without depression history and TGA recurrence (target event)                                       |
| any_trigger_n                | Number of TGA subjects with a recognizible trigger event                                                                  |
| any_trigger_events_n         | Number of TGA subjects with a recognizible trigger event and TGA recurrence                                               |
| notrigger_n                  | Number of TGA subjects without a recognizible trigger event                                                               |
| notrigger_events_n           | Number of TGA subjects without a recognizible trigger event and TGA recurrence                                            |
| stress_n                     | Number of TGA subjects with psychological stress as a trigger event                                                       |
| stress_events_n              | Number of TGA subjects with psychological stress as a trigger event and TGA recurrence                                    |
| nostress_n                   | Number of TGA subjects without psychological stress as a trigger event                                                    |
| nostress_events_n            | Number of TGA subjects without psychological stress as a trigger event and TGA recurrence                                 |
| physical_ex_n                | Number of TGA subjects with physical exercise as a trigger event                                                          |
| physical_events_n            | Number of TGA subjects with physical exercise as a trigger event and TGA recurrence                                       |
| nophysical_ex_n              | Number of TGA subjects without physical exercise as a trigger event                                                       |
| nophysical_events_n          | Number of TGA subjects without physical exercise as a trigger event and TGA recurrence                                    |
| shower_n                     | Number of TGA subjects with a shower as a trigger event                                                                   |
| shower_events_n              | Number of TGA subjects with a shower as a trigger event and TGA recurrence                                                |
| noshower_n                   | Number of TGA subjects without a shower as a trigger event                                                                |
| noshower_events_n            | Number of TGA subjects without a shower as a trigger event and TGA recurrence                                             |
| sex_int_n                    | Number of TGA subjects with a sexual intercourse as a trigger event                                                       |
| sex_int_events_n             | Number of TGA subjects with a sexual intercourse as a trigger event and TGA recurrence                                    |
| nosex_int_n                  | Number of TGA subjects without a sexual intercourse as a trigger event                                                    |
| nosex_int_events_n           | Number of TGA subjects without a sexual intercourse as a trigger event and TGA recurrence                                 |
| vomiting_n                   | Number of TGA subjects with a vomiting episode as a trigger event                                                         |
| vomiting_events_n            | Number of TGA subjects with a vomiting episode as a trigger event and TGA recurrence                                      |
| novomiting_n                 | Number of TGA subjects without a vomiting episode as a trigger event                                                      |
| novomiting_events_n          | Number of TGA subjects without a vomiting episode as a trigger event and TGA recurrence                                   |
| DWI_n                        | Number of TGA subjects with hyperintense images in DWI sequence                                                           |
| DWI_events_n                 | Number of TGA subjects with hyperintense images in DWI sequence and TGA recurrence (target event)                         |
| noDWI_n                      | Number of TGA subjects without hyperintense images in DWI sequence                                                        |
| noDWI_events_n               | Number of TGA subjects without hyperintense images in DWI sequence and TGA recurrence (target event)                      |
| jreflux_n                    | Number of TGA subjects with jugular reflux detected by ultrasound                                                         |
| jreflux_events_n             | Number of TGA subjects with jugular reflux detected by ultrasound and TGA recurrence (target event)                       |
| nojreflux_n                  | Number of TGA subjects without jugular reflux detected by ultrasound                                                      |
| nojreflux_events_n           | Number of TGA subjects without jugular reflux detected by ultrasound and TGA recurrence (target event)                    |
| aEEG_n                       | Number of TGA subjects with abnormal EEG                                                                                  |
| aEEG_events_n                | Number of TGA subjects with abnormal EEG and TGA recurrence (target event)                                                |
| noaEEG_n                     | Number of TGA subjects without abnormal EEG                                                                               |
| noaEEG_events_n              | Number of TGA subjects without abnormal EEG and TGA recurrence (target event)                                             |




