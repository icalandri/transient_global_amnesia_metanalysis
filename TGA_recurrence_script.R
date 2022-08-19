#...............................................................................
#                                                                              .
#  The following script contains the analysis performed for the paper          .
#  entitled Transient global amnesia recurrence: prevalence and risk factor    .
#  meta-analysis MS ID#: NEURCLINPRACT/2021/070078.  This script is            .
#  accompanied by the corresponding dataset and a dictionary of variables.     .
#  Statistical analysis and coding are the responsibility of Ismael Calandri,  .
#  contact: icalandri@fleni.org.ar                                             .
#                                                                              .
#...............................................................................




#............................libraries............................
library(meta)
library(metafor)
library(dmetar)
library(dplyr)


#............................data tidy...........................

library(readr)
data <- read_csv("TGA_recurrence_metanalysis_dataset.csv")

data$`Recurrence as a main outcome`<-factor(data$`Recurrence as a main outcome`,
                                            levels = c(0,1),
                                            labels = c("No", "Yes"))
library(expss)
data$recurrence_prevalence<-data$TGA_rec_subjects/data$TGA_subjects

data<-apply_labels(data,
                   recurrence_prevalence= "Prevalence of recurrency (%)")


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            ~~
##                           PREVALENCE METANALYSIS                         ----
##                                                                            ~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            --
##...............................RAW.PREVALENCE.............................----
##                                                                            --
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


data_prevalence<-data%>% select(TGA_rec_subjects,
                                TGA_subjects,
                                Study, 
                                TGA_definition, 
                                `Recurrence as a main outcome`)

data_prevalence<-na.omit(data_prevalence)
meta_prevalence<- metaprop(data_prevalence$TGA_rec_subjects,
                           data_prevalence$TGA_subjects, 
                           studlab=data_prevalence$Study,
                           sm="PFT", data=data_prevalence, 
                           method="Inverse", method.tau="DL")

summary(meta_prevalence)


forest.meta(meta_prevalence,
            comb.r=T, 
            comb.f=F, 
            prediction = T,
            leftcols = c("Study","TGA_rec_subjects","TGA_subjects",  "TGA_definition", "Recurrence as a main outcome"),
            leftlabs = c("Author", "Events", "Total", "TGA criteria", "Recurrency outcome"),
            xlab="Prevalence of recurrency")


forest.meta(meta_prevalence,
            comb.r=T, 
            comb.f=F, 
            prediction = T,
            xlab="Prevalence of recurrence")

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                      outliers and influential analysis                   ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a<-find.outliers(meta_prevalence)
a$out.study.random


# Model w/o outliers (Random effects model)

a$m.random



# Influential analysis

inf.analysis <- InfluenceAnalysis(x =meta_prevalence,
                                  random = TRUE)

plot(inf.analysis, "influence")


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                              Publication bias                            ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Contour enhanced funnel plot
funnel.meta(meta_prevalence,studlab = TRUE, cex.studlab = 0.5,
            contour = c(0.9, 0.95, 0.99),
            col.contour = col.contour)
legend(x = 0.6, y = 0.001, cex = 0.8,
       legend = c("p < 0.1", "p < 0.05", "p < 0.01"),
       fill = col.contour)
title("Contour-Enhanced Funnel Plot (TGA recurrence prevalence)")


# Egger´s test 

eggers.test(meta_prevalence)


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            --
##............................STRATIFIED.PREVALENCE.........................----
##                                                                            --
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Creating a follow-up stratus
data2<-data
data2$FU<-cut(data2$Follow_up_time, 
              breaks=c(0, 24, 48, 100), 
              labels=c("< 2 years","2 to 4 years","> 4years")) 
data2<-data2 %>% filter(FU != "NA")


#Stratified metanalysis
meta<-metaprop(data2$TGA_rec_subjects,
               data2$TGA_subjects, 
               studlab=data2$Study, 
               sm="PFT", data=data2, 
               method="Inverse", method.tau="DL")


meta2<-update.meta(meta, 
                   byvar = FU, 
                   tau.common = FALSE)


meta2

forest(meta2,
       comb.r=T, 
       comb.f=F, 
       prediction = T,
       xlab="Prevalence of recurrence" )

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                               Metaregression                             ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

data_prevalence2<-data %>% select(TGA_subjects,TGA_rec_subjects,
                                  Study, TGA_definition, 
                                  `Recurrence as a main outcome`,
                                  Follow_up_time)

data_prevalence2<-na.omit(data_prevalence2)
meta_prevalence2<- metaprop(data_prevalence2$TGA_rec_subjects, 
                            data_prevalence2$TGA_subjects, 
                            studlab=data_prevalence2$Study, 
                            sm="PFT", data=data_prevalence2, 
                            method="Inverse", method.tau="DL")

meta_reg<-metareg(meta_prevalence2, ~Follow_up_time)

meta_reg


bubble(meta_reg, studlab = T, cex.studlab = .5, 
       xlab = "Follow-up time (days)", xlim = c(0, 400),
       col = c("#E7B800"),bg = c("#fada96"),pos.studlab = 4,
       col.line = c("#b57e09"),ylab = "Freeman-Tukey transformation proportion")


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            ~~
##                       RISK FACTOR FACTOR METANALYSIS                     ----
##                                                                            ~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                 Female sex                               ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

m.sex <- metabin(data$female_events,
                 data$female_n,
                 data$male_events_n,
                 data$males_n,
                 data = data,
                 studlab = data$Study,
                 comb.fixed = FALSE,
                 comb.random = TRUE,
                 method.tau = "SJ",
                 hakn = TRUE,
                 prediction = TRUE,
                 incr = 0.1,
                 sm = "OR")
m.sex


forest(m.sex,
       xlab="OR", 
       lab.e = "Female",
       lab.c = "Male")


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                        Cardiovascular risk factors                       ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

##~~~~~~~~~~~~~~~~~~~~~
##  ~ Prevalences  ----
##~~~~~~~~~~~~~~~~~~~~~

#HBP

prev_HBP<-data %>% select(HBP_n, noHBP_n, Study)
prev_HBP$subjects_n <-prev_HBP$HBP_n+prev_HBP$noHBP_n

prev_HBP<-na.omit(prev_HBP)

metaprop(HBP_n, 
         subjects_n, 
         studlab=Study, sm="PFT", 
         data=prev_HBP, method="Inverse", method.tau="DL")

#DLP
prev_dlp<-data %>% select(DLP_n, noDLP_n, Study)
prev_dlp$subjects_n <-prev_dlp$DLP_n+prev_dlp$noDLP_n
prev_dlp<-na.omit(prev_dlp)

metaprop(DLP_n, 
         subjects_n, 
         studlab=Study, sm="PFT", 
         data=prev_dlp, method="Inverse", method.tau="DL")

#DBT
prev_DBT<-data %>% select(DBT_n, noDBT_n, Study)
prev_DBT$subjects_n <-prev_DBT$DBT_n+prev_DBT$noDBT_n
prev_DBT<-na.omit(prev_DBT)

metaprop(DBT_n, 
         subjects_n, 
         studlab=Study, sm="PFT", 
         data=prev_DBT, method="Inverse", method.tau="DL")


#Smoking
prev_smoke<-data %>% select(smoke_n, nosmoke_n, Study)
prev_smoke$subjects_n <-prev_smoke$smoke_n+prev_smoke$nosmoke_n
prev_smoke<-na.omit(prev_smoke)

metaprop(smoke_n, 
         subjects_n, 
         studlab=Study, sm="PFT", 
         data=prev_smoke, method="Inverse", method.tau="DL")

#Atrial Fibrillation
prev_AF<-data %>% select(AF_n, noAF_n, Study)
prev_AF$subjects_n <-prev_AF$AF_n+prev_AF$noAF_n
prev_AF<-na.omit(prev_AF)

metaprop(AF_n, 
         subjects_n, 
         studlab=Study, sm="PFT", 
         data=prev_AF, method="Inverse", method.tau="DL")

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##  ~ Association with recurrence  ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#HBP
m.hbp <- metabin(data$HBP_event_n,
                 data$HBP_n,
                 data$noHBP_events_n,
                 data$noHBP_n,
                 data = data,
                 studlab = data$Study,
                 comb.fixed = FALSE,
                 comb.random = TRUE,
                 method.tau = "SJ",
                 hakn = TRUE,
                 prediction = TRUE,
                 incr = 0.1,
                 sm = "OR")
m.hbp

#DLP
m.DLP <- metabin(data$DLP_events_n,
                 data$DLP_n,
                 data$noDLP_events_n,
                 data$noDLP_n,
                 data = data,
                 studlab = data$Study,
                 comb.fixed = FALSE,
                 comb.random = TRUE,
                 method.tau = "SJ",
                 hakn = TRUE,
                 prediction = TRUE,
                 incr = 0.1,
                 sm = "OR")
m.DLP

#DBT

m.DBT <- metabin(data$DBT_events_n,
                 data$DBT_n,
                 data$noDBT_event_n,
                 data$noDBT_n,
                 data = data,
                 studlab = data$Study,
                 comb.fixed = FALSE,
                 comb.random = TRUE,
                 method.tau = "SJ",
                 hakn = TRUE,
                 prediction = TRUE,
                 incr = 0.1,
                 sm = "OR")
m.DBT


m.smoke <- metabin(data$smoke_event_n,
                 data$smoke_n,
                 data$nosmoke_event_n,
                 data$nosmoke_n,
                 data = data,
                 studlab = data$Study,
                 comb.fixed = FALSE,
                 comb.random = TRUE,
                 method.tau = "SJ",
                 hakn = TRUE,
                 prediction = TRUE,
                 incr = 0.1,
                 sm = "OR")
m.smoke

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                   Stroke                                 ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


m.stroke <- metabin(data$stroke_events_n,
                   data$stroke_n,
                   data$nostroke_events_n,
                   data$nostroke_n,
                   data = data,
                   studlab = data$Study,
                   comb.fixed = FALSE,
                   comb.random = TRUE,
                   method.tau = "SJ",
                   hakn = TRUE,
                   prediction = TRUE,
                   incr = 0.1,
                   sm = "OR")
m.stroke

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                          Coronary artery disease                         ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

m.CAD <- metabin(data$CAD_events_n,
                    data$CAD_n,
                    data$noCAD_events_n,
                    data$noCAD_n,
                    data = data,
                    studlab = data$Study,
                    comb.fixed = FALSE,
                    comb.random = TRUE,
                    method.tau = "SJ",
                    hakn = TRUE,
                    prediction = TRUE,
                    incr = 0.1,
                    sm = "OR")
m.CAD


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                  Migraine                                ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


prev_Migraine<-data %>% select(Migraine_n, noMigraine_n, Study)
prev_Migraine$subjects_n <-prev_Migraine$Migraine_n+prev_Migraine$noMigraine_n
prev_Migraine<-na.omit(prev_Migraine)

metaprop(Migraine_n, 
         subjects_n, 
         studlab=Study, sm="PFT", 
         data=prev_Migraine, method="Inverse", method.tau="DL")

m.Migraine <- metabin(data$Migraine_events_n,
                 data$Migraine_n,
                 data$noMigraine_events_n,
                 data$noMigraine_n,
                 data = data,
                 studlab = data$Study,
                 comb.fixed = FALSE,
                 comb.random = TRUE,
                 method.tau = "SJ",
                 hakn = TRUE,
                 prediction = TRUE,
                 incr = 0.1,
                 sm = "OR")
m.Migraine

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                 Depression                               ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


prev_Depresion<-data %>% select(Depresion_n, noDepresion_n, Study)
prev_Depresion$subjects_n <-prev_Depresion$Depresion_n+prev_Depresion$noDepresion_n
prev_Depresion<-na.omit(prev_Depresion)

metaprop(Depresion_n, 
         subjects_n, 
         studlab=Study, sm="PFT", 
         data=prev_Depresion, method="Inverse", method.tau="DL")

m.Depresion <- metabin(data$Depresion_events_n,
                      data$Depresion_n,
                      data$noDepresion_events_n,
                      data$noDepresion_n,
                      data = data,
                      studlab = data$Study,
                      comb.fixed = FALSE,
                      comb.random = TRUE,
                      method.tau = "SJ",
                      hakn = TRUE,
                      prediction = TRUE,
                      incr = 0.1,
                      sm = "OR")
m.Depresion

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                  Triggers                                ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

##~~~~~~~~~~~~~~~~~~~~~
##  ~ any trigger  ----
##~~~~~~~~~~~~~~~~~~~~~

prev_trigger<-data %>% select(any_trigger_n, notrigger_n, Study)
prev_trigger$subjects_n <-prev_trigger$any_trigger_n+ prev_trigger$notrigger_n
prev_trigger<-na.omit(prev_trigger)

metaprop(any_trigger_n, 
         subjects_n, 
         studlab=Study, sm="PFT", 
         data=prev_trigger, method="Inverse", method.tau="DL")

m.trigger <- metabin(data$any_trigger_events_n,
                       data$any_trigger_n,
                       data$notrigger_events_n,
                       data$notrigger_n,
                       data = data,
                       studlab = data$Study,
                       comb.fixed = FALSE,
                       comb.random = TRUE,
                       method.tau = "SJ",
                       hakn = TRUE,
                       prediction = TRUE,
                       incr = 0.1,
                       sm = "OR")
m.trigger

##~~~~~~~~~~~~~~~~
##  ~ stress  ----
##~~~~~~~~~~~~~~~~

m.stress <- metabin(data$stress_events_n,
                       data$stress_n,
                       data$nostress_events_n,
                       data$nostress_n,
                       data = data,
                       studlab = data$Study,
                       comb.fixed = FALSE,
                       comb.random = TRUE,
                       method.tau = "SJ",
                       hakn = TRUE,
                       prediction = TRUE,
                       incr = 0.1,
                       sm = "OR")
m.stress


##~~~~~~~~~~~~~~~~~~~~~~~~~~~
##  ~ Physical exercise  ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~


m.physical <- metabin(data$physical_events_n,
                    data$physical_ex_n,
                    data$nophysical_events_n,
                    data$nophysical_ex_n,
                    data = data,
                    studlab = data$Study,
                    comb.fixed = FALSE,
                    comb.random = TRUE,
                    method.tau = "SJ",
                    hakn = TRUE,
                    prediction = TRUE,
                    incr = 0.1,
                    sm = "OR")
m.physical 

##~~~~~~~~~~~~~~~~
##  ~ Shower  ----
##~~~~~~~~~~~~~~~~

m.shower <- metabin(data$shower_events_n,
                    data$shower_n,
                    data$noshower_events_n,
                    data$noshower_n,
                    data = data,
                    studlab = data$Study,
                    comb.fixed = FALSE,
                    comb.random = TRUE,
                    method.tau = "SJ",
                    hakn = TRUE,
                    prediction = TRUE,
                    incr = 0.1,
                    sm = "OR")
m.shower

##~~~~~~~~~~~~~~~~~~
##  ~ Vomiting  ----
##~~~~~~~~~~~~~~~~~~

m.vomiting <- metabin(data$vomiting_events_n,
                    data$vomiting_n,
                    data$novomiting_events_n,
                    data$novomiting_n,
                    data = data,
                    studlab = data$Study,
                    comb.fixed = FALSE,
                    comb.random = TRUE,
                    method.tau = "SJ",
                    hakn = TRUE,
                    prediction = TRUE,
                    incr = 0.1,
                    sm = "OR")
m.vomiting


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##  ~ Sexual intercourse  ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~

m.sex_int <- metabin(data$sex_int_events_n,
                      data$sex_int_n,
                      data$nosex_int_events_n,
                      data$nosex_int_n,
                      data = data,
                      studlab = data$Study,
                      comb.fixed = FALSE,
                      comb.random = TRUE,
                      method.tau = "SJ",
                      hakn = TRUE,
                      prediction = TRUE,
                      incr = 0.1,
                      sm = "OR")
m.sex_int

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                DWI lesions                               ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

m.DWI <- metabin(data$DWI_events_n,
                      data$DWI_n,
                      data$noDWI_events_n,
                      data$noDWI_n,
                      data = data,
                      studlab = data$Study,
                      comb.fixed = FALSE,
                      comb.random = TRUE,
                      method.tau = "SJ",
                      hakn = TRUE,
                      prediction = TRUE,
                      incr = 0.1,
                      sm = "OR")
m.DWI

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                abnormal EEG                              ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

m.aEEG <- metabin(data$aEEG_events_n,
                 data$aEEG_n,
                 data$noaEEG_events_n,
                 data$noaEEG_n,
                 data = data,
                 studlab = data$Study,
                 comb.fixed = FALSE,
                 comb.random = TRUE,
                 method.tau = "SJ",
                 hakn = TRUE,
                 prediction = TRUE,
                 incr = 0.1,
                 sm = "OR")
m.aEEG


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                        Jugular reflux by ultrasound                      ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

m.jreflux <- metabin(data$jreflux_events_n,
                  data$jreflux_n,
                  data$nojreflux_events_n,
                  data$nojreflux_n,
                  data = data,
                  studlab = data$Study,
                  comb.fixed = FALSE,
                  comb.random = TRUE,
                  method.tau = "SJ",
                  hakn = TRUE,
                  prediction = TRUE,
                  incr = 0.1,
                  sm = "OR")
m.jreflux
