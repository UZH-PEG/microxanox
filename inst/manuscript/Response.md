CC: nkourkou@uoi.gr

Manuscript Number: SOFTX-D-22-00172

Microxanox: an R package for simulating an aquatic MICRobial ecosystem that can occupy OXic orANOXic states.

Dear Dr. Krug,

Thank you for submitting your manuscript to SoftwareX.

I have completed my evaluation of your manuscript. The reviewers recommend reconsideration of your manuscript following minor revision and modification. I invite you to resubmit your manuscript after addressing the comments below. Please resubmit your revised manuscript by Jun 12, 2023.

When revising your manuscript, please consider all issues mentioned in the reviewers' comments carefully: please outline every change made in response to their comments and provide suitable rebuttals for any comments not addressed. Please note that your revised submission may need to be re-reviewed.

To submit your revised manuscript, please log in as an author at https://www.editorialmanager.com/softx/, and navigate to the "Submissions Needing Revision" folder under the Author Main Menu.

SoftwareX values your contribution and I look forward to receiving your revised manuscript.￼

Kind regards,

Randall Sobie

Editor-in-Chief

SoftwareX

Editor and Reviewer comments:





# Reviewer #1:
- 1. Please consider reference style: Number the references (numbers in square brackets) in the list in the order in which they appear in the text.

- 2 The authors in section 3.3 claim several sentences that could confuse readers.
    - 2.1 `one discovers how the steady state of the system responds to the environmental conditions`. There are several concerns that the authors should clarify:
         - a) `The steady state`. Is there a unique steady state? Is there a reported contribution concerning a formal analysis of the model in the sense of stability (stable state existence and uniqueness)? Maybe, authors should refer as `a system's stable state (if it exists)`.
         - b) `The steady state of the system responds`. It should be noted that the steady state does not respond to the environment. Maybe, the authors refer to the numerical result of a steady state as a function of parameter and initial condition (if a steady state is not unique).
    - 2.2 `finding steady states that correspond to values of one environmental driver`. The software does not find a steady state. Maybe the authors refer to the software running an open loop of the dynamic system under a set of initial conditions and a subset of parameter values (oxygen diffusivity). Then, the numerical evaluation of steady states could be related to environmental conditions in real systems.
    - 2.3 `Two methods for finding steady states are implemented`. Again, the software does not find a steady state. Maybe the authors refer to two simulations proposed to evaluate an open loop simulation of the dynamic model numerically.
    - 2.4 `The first runs a separate simulation for each combination of starting conditions and oxygen diffusivity`. This sentence is confusing. What the authors mean with `separate simulation` and `starting conditions`. Maybe the authors refer to each initial condition and parameter set value (oxygen diffusivity) as an open loop simulation run of the dynamic system. Are these simulations results focused on obtaining a bifurcation diagram Fig. 3 and 4 from {10.1038/s41467-017-00912-x}? Please clarified this point.
    - 2.5 `The second runs two simulations, one with step-wise and slowly temporally increasing oxygen diffusivity, and the other with step-wise and slowly decreasing oxygen diffusivity`. This sentence needs to be clarified. Authors refer `temporally` as several changes in the value of oxygen diffusivity during a simulation run time. Maybe the authors mean the following: to explore the parametric sensitivity of the dynamic model under oxygen diffusivity variation, subset values of this parameter are numerically evaluated. Two value vectors of oxygen diffusivity are presented step-wise, gradually increasing and decreasing.
    - 2.6 `We implemented two methods since there is no definitive best method, and in order to check if results were sensitive to choice of method`. This sentence is confusing.
         - a) `two methods` Maybe the authors mean the following: two numerical strategies to explore a parametric sensitivity numerical evaluation.
         - b) `there is no definitive best method`. Under which criteria? The authors present only two numerical evaluations. Please clarified this point.
         - c) `in order to check if results were sensitive to choice of method`. This sentence needs to be clarified. There is no comparison between numerical evaluations in any sense. The numerical simulations or simulation results are not sensitive to choice or method. Indeed, the numerical solution of the dynamical model is sensitive to a set of parameters and initial conditions. Maybe the authors mean the following: to evaluate the performance of the numerical parametric sensitivity analysis of the dynamical model concerning one parametric variation (oxygen diffusivity) under two schemes.2.7 It is not clear why there are two `methods` for numerical parametric sensitivity analysis. The authors should include the arguments of this.
    - 2.8 Please consider rewrite the section 3.3 (see previous 2.1 - 2.7 points) in the sense of Parametric sensitivity analysis, Open loop dynamical behavior, Equilibrium points (see Khalil, H. K. (2002). Nonlinear Systems. Prentice Hall, New Jersey.)

- 3. Please consider the following suggestions:
    - Line 5 `types of ecosystem` -> `types of ecosystems` <span style="color:green">**Done**</span>
    - Line 10 `Permanent link to` -> `Permanent links to` <span style="color:green">**Done**</span>
    - Line 12 `role in the development of understanding about how ecosystems` -> `role in understanding how ecosystems` <span style="color:green">**Changed to `Mathematical models play a key role in the development of ecosystem models and the understanding about how ecosystems work`**</span>
    - Line 13: `and how they respond` -> `and respond` <span style="color:green">**Done**</span>
    - Line 15 `have played a influential role is 16 how ecosystems respond to gradual change` -> `have been influential in how ecosystems respond to a gradual change` <span style="color:green">**Changed to `One area of ecology in which models have been influential is the understanding of their response to a gradual change in an environmental driver [@Scheffer2001].`**</span>
    - Line 16 `is a environmental` -> `is an environmental` <span style="color:green">**Done**</span>
    - Line 17 `affects an ecosystem, but 18 is assumed to not be` -> `affects an ecosystem. Still, it is assumed not to be` <span style="color:green">**Done**</span>
    - Line 27 `change of the system` -> `change in the system` <span style="color:green">**Done**</span>
    - Line 28 `to anaerobic` -> `to an anaerobic`  <span style="color:green">**Done**</span>
    - Line 34 `termed the oxygen diffusitivity` -> `termed oxygen diffusivity` <span style="color:green">**Done**</span>
    - Line 38 `This leaves open the question of if and how biodiversity within these types (i.e. functional groups) of bacteria affects the ecosystem` -> `This leaves the question of if and how bacteria's biodiversity within these types (i.e., functional groups) affects the ecosystem` <span style="color:green">**Done**</span>
    - Line 47 `It was with this goal in mind that we developed the microxanox package` -> `With this goal in mind, we developed the microxanox package` <span style="color:green">**Done**</span>
    - Line 58 `conditions, addition` -> `conditions, the addition` <span style="color:green">**Done**</span>
    - Line 60 `some functions to analyse the results as well as to visualize the results to provide a starting` -> `some functions to analyze the results and visualize them to provide a starting`<span style="color:green">** Changed to `some functions to analyse the results and visualize these to provide a starting point`**</span>
    - Line 71 `for running individual simulations and for running a set of simulations` -> `for running individual simulations and a set of simulations` <span style="color:green">**Done**</span>
    - Line 76 `the vectors and matrices, and to use matrix mathematics` -> `the vectors and matrices and used matrix mathematics` <span style="color:green">**Done**</span>
    - Line 80 `code have modular structure so that new functionality can be easily added. E.g. temporally` -> `code have a modular structure so that new functionality can be easily added. E.g., temporally` <span style="color:green">**Done**</span>
    - Line 87 `to maximise simplicity for the user, and` -> `to maximize simplicity for the user and` <span style="color:green">**Done**</span>
    - Line 95 `results of the run` -> `simulation results` <span style="color:green">**Done**</span>
    - Line 98 `parameters and re-running the simulations straightforward. In the following sections we` -> `parameters, and reruns the simulations straightforwardly. In the following sections, we` <span style="color:green">**Changed to `This promotes reproducibility and makes incremental changes of individual parameters with a consecutive and re-running of the simulations straightforward.`**</span>
    - Line 107 `contains among other things the` -> `contains, among other things, the` <span style="color:green">**Done**</span>
    - Line 109 `their meaning and how they are created and have values set and changed please` -> `their meaning, and how they are created and have values set and changed, please` <span style="color:green">**Done**</span>
    - Line 113 ` an object which is identical to the parameter` -> `an object identical to the parameter` <span style="color:green">**Done**</span>
    - Line 116 `to run the simulation again from` -> `to rerun the simulation from` <span style="color:green">**Done**</span>
    - Line 119 `The general approach used to find the stable state of the system` -> `The general approach to finding the numerical value of a system's stable state (if it exists)` <span style="color:green">**Done**</span>
    - Line …

- 4. Please, consider English Editing Service or Proofread Your Paper.

- 5. Please, consider include two or three references of SoftwareX Journal.




More information and support

FAQ: How do I revise my submission in Editorial Manager?

https://service.elsevier.com/app/answers/detail/a_id/28463/supporthub/publishing/

You will find information relevant for you as an author on Elsevier’s Author Hub: https://www.elsevier.com/authors

FAQ: How can I reset a forgotten password?
https://service.elsevier.com/app/answers/detail/a_id/28452/supporthub/publishing/
For further assistance, please visit our customer service site: https://service.elsevier.com/app/home/supporthub/publishing/
Here you can search for solutions on a range of topics, find answers to frequently asked questions, and learn more about Editorial Manager via interactive tutorials. You can also talk 24/7 to our customer support team by phone and 24/7 by live chat and email

#AU_SOFTX#

To ensure this email reaches the intended recipient, please do not delete the above code



In compliance with data protection regulations, you may request that we remove your personal registration details at any time. (Remove my information/details). Please contact the publication office if you have any questions.