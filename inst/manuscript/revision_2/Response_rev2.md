# Manuscript Number: SOFTX-D-22-00172

<!-- CC: [nkourkou\@uoi.gr](mailto:nkourkou@uoi.gr){.email}

Microxanox: an R package for simulating an aquatic MICRobial ecosystem that can occupy OXic orANOXic states.

Dear Dr. Krug,

Thank you for submitting your manuscript to SoftwareX.

I have completed my evaluation of your manuscript. The reviewers recommend reconsideration of your manuscript following minor revision and modification. I invite you to resubmit your manuscript after addressing the comments below. Please resubmit your revised manuscript by Jun 12, 2023.

When revising your manuscript, please consider all issues mentioned in the reviewers' comments carefully: please outline every change made in response to their comments and provide suitable rebuttals for any comments not addressed. Please note that your revised submission may need to be re-reviewed.

To submit your revised manuscript, please log in as an author at <https://www.editorialmanager.com/softx/>, and navigate to the "Submissions Needing Revision" folder under the Author Main Menu.

SoftwareX values your contribution and I look forward to receiving your revised manuscript.

Kind regards,

Randall Sobie

Editor-in-Chief

SoftwareX -->

## Response from Authors to Editor and Reviewer comments

### Introduction

Thank you for the opportunity to revise the manuscript again. We apologise that our first revision was found to be insufficient and that it was not as easy to follow as it should have been.

We provide a guide to the materials we resubmit:

First is this document. In it we use this typeface to give our responses and we use the following typeface when text from the manuscript is being quoted: `this typeface shows text being quoted from the manuscript`. In this document we use the following type of box to indicate comments from the reviewer.

> This kind of box contains comments from the reviewer.

The second document is the revised and clean manuscript, and the third is the revised manuscript with changes shown.

Below, we cover each of the latest reviewer comments in turn.


> It was difficult to follow the [Responses and Suggestions] in the new version. Those sections/paragraphs that have been rewritten, added, or modified in the paper should be included in the reply letter and explicitly highlight the parts that correspond precisely to each remark. The highlighted paper and the clean version should be shown at the end of the reply letter.

Apologies that we provided materials that were difficult to follow. With the current revision we provide two versions of the revised manuscript, as requested, one a clean version, and one with changes highlight. We also, as requested, include all revised text in this response document and then reference the location in the revised document by line number. *Rainer, please check that this is so, before resubmission. Wait for our final version of the text before inserting the correct line numbers below.*

> 2.1a-b The comment has been addressed.

Thank you.

> 2.2 The comment has not been addressed.

> Here is the original comment 2.2: `finding steady states that correspond to values of one environmental driver`. The software does not find a steady state. Maybe the authors refer to the software running an open loop of the dynamic system under a set of initial conditions and a subset of parameter values (oxygen diffusivity). Then, the numerical evaluation of steady states could be related to environmental conditions in real systems.

**Response**: We agree--the software does not find a steady state of the system. We no longer claim that it does, and we have added `The software does not provide the user with a steady state.` (lines XXX-YYY). Furthermore, in lines XXX-YYY of the newly revised manuscript we explain that the simulations provide a *final state* of the system, and that this is not guaranteed to be a steady state of the system: `When one wishes to be able to make conclusions about how the *steady state* of the system is affected by the environmental driver, it is very important to note that the *final state* (provided by the simulation) is not guaranteed to be a *steady state*.` (lines XXX-YYY). We also then list the actions that users need to take in order to somewhat safely assume that the provided final state is a steady state of the system: `In order to somewhat safely assume that the final state is a steady state, the user must ensure that the simulation is run for sufficiently long time for any transient dynamics to disappeared, and must also check the type of long-term dynamics occurring. In the results presented here, and in the paper @Limberger2023, this was performed by visual inspection, and by checking the sensitivity of conclusions to the length of the simulation.` (lines XXX-YYY)

> 2.3 The comment has not been addressed.

> Here is the original comment 2.3: `Two methods for finding steady states are implemented`. Again, the software does not find a steady state. Maybe the authors refer to two simulations proposed to evaluate an open loop simulation of the dynamic model numerically.

**Response**: We agree--the software does not find a steady state of the system. We no longer claim that it does, and we have added `The software does not provide the user with a steady state.` (lines XXX-YYY). 

> 2.4 The comment has been addressed.

Thank you.

> 2.5 The comment has been addressed.

Thank you.

> 2.6a-b The comment has been addressed.

Thank you.

> 2.6c The comment has not been addressed.

> Here is the original comment 2.6c:  `in order to check if results were sensitive to choice of method`. This sentence needs to be clarified. There is no comparison between numerical evaluations in any sense. The numerical simulations or simulation results are not sensitive to choice or method. Indeed, the numerical solution of the dynamical model is sensitive to a set of parameters and initial conditions. Maybe the authors mean the following: to evaluate the performance of the numerical parametric sensitivity analysis of the dynamical model concerning one parametric variation (oxygen diffusivity) under two schemes.

**Response:** We agree that the software does not itself make a comparison. It only provides users information that they could use to make a comparison. This and the surround text have been revised and the points clarified: `Two numerical strategies for finding final states and their sensitivity to parameters are implemented. Two strategies are implemented in order to allow users to compare of their results.` (lines XXX-YYY). 

> 2.7 The comment has not been addressed.

> Here is the original comment 2.7: It is not clear why there are two `methods` for numerical parametric sensitivity analysis. The authors should include the arguments of this.

**Response:** We now state that `Two numerical strategies for finding final states and their sensitivity to parameters are implemented. Two strategies are implemented in order to allow users to compare of their results.` (lines XXX-YYY). Furthermore, we have added the following text: `An potentially important difference between the two methods is in the system state when a new value of oxygen diffusivity is set. In the replication method, the system state when a new value of oxygen diffusivity is set is always the same. Whereas in the temporal method, the system state when a new value of oxygen diffusivity is set is the final state of the system for the previously set value of oxygen diffusivity. Since some modellers prefer one approach and others another, we decided to implement both.` (lines XXX-YYY)

> 2.8 The comment has not been addressed.

> Here is the original comment 2.8: Please consider rewrite the section 3.3 (see previous 2.1 - 2.7 points) in the sense of Parametric sensitivity analysis, Open loop dynamical behavior, Equilibrium points (see Khalil, H. K. (2002). Nonlinear Systems. Prentice Hall, New Jersey.)

**Response:** in our previous response we attempted to argue that the language and terms used in the text were appropriate and understandable by the target audience (quantitative ecologists with some knowledge of dynamical systems modelling).

> 3 It wasn't easy to follow the [Suggestion] in the new version.

We interpret this as the reviewer asking for clearer accounts of what was changed, and now provide below, with line numbers corresponding to those in the newly revised document, and the corresponding text in green font. *Rainer, please do this.*

> 3.  Please consider the following suggestions:

> Line 5 `types of ecosystem`

Changed to `types of ecosystems`

> Line 10 `Permanent link to`

Changed to `Permanent links to`

> Line 12 `role in the development of understanding about how ecosystems`

`role in understanding how ecosystems` Changed to `Mathematical models play a key role in the development of ecosystem models and the understanding about how ecosystems work`

> Line 13: `and how they respond`

Changed to `and respond`

> Line 15 `have played a influential role is 16 how ecosystems respond to gradual change`

`have been influential in how ecosystems respond to a gradual change` changed to `One area of ecology in which models have been influential is the understanding of their response to a gradual change in an environmental driver [@Scheffer2001].`

> Line 16 `is a environmental`

Changed to `is an environmental`

> Line 17 `affects an ecosystem, but 18 is assumed to not be`

Changed to `affects an ecosystem. Still, it is assumed not to be`

> Line 27 `change of the system`

Changed to `change in the system`

> Line 28 `to anaerobic`

Changed to `to an anaerobic`

> Line 34 `termed the oxygen diffusitivity`

Changed to `termed oxygen diffusivity`

> Line 38 `This leaves open the question of if and how biodiversity within these types (i.e. functional groups) of bacteria affects the ecosystem`

Changed to `This leaves the question of if and how bacteria's biodiversity within these types (i.e., functional groups) affects the ecosystem`

> Line 47 `It was with this goal in mind that we developed the microxanox package`

Changed to `With this goal in mind, we developed the microxanox package`

> Line 58 `conditions, addition`

Changed to `conditions, the addition`

> Line 60 `some functions to analyse the results as well as to visualize the results to provide a starting`

`some functions to analyze the results and visualize them to provide a starting` changed to `some functions to analyse the results and visualize these to provide a starting point`

> Line 71 `for running individual simulations and for running a set of simulations`

Changed to `for running individual simulations and a set of simulations`

> Line 76 `the vectors and matrices, and to use matrix mathematics`

Changed to `the vectors and matrices and used matrix mathematics`

> Line 80 `code have modular structure so that new functionality can be easily added. E.g. temporally`

Changed to `code have a modular structure so that new functionality can be easily added. E.g., temporally`

> Line 87 `to maximise simplicity for the user, and`

Changed to `to maximize simplicity for the user and`

> Line 95 `results of the run`

Changed to `simulation results`

> Line 98 `parameters and re-running the simulations straightforward. In the following sections we`

`parameters, and reruns the simulations straightforwardly. In the following sections, we` changed to `This promotes reproducibility and makes incremental changes of individual parameters with a consecutive and re-running of the simulations straightforward.`

> Line 107 `contains among other things the`

Changed to `contains, among other things, the`

> Line 109 `their meaning and how they are created and have values set and changed please`

Changed to `their meaning, and how they are created and have values set and changed, please`

> Line 113 `an object which is identical to the parameter`

Changed to `an object identical to the parameter`

> Line 116 `to run the simulation again from`

Changed to `to rerun the simulation from`

> Line 119 `The general approach used to find the stable state of the system`

Changed to `The general approach to finding the numerical value of a system's stable state (if it exists)`



> 4 The suggestion seems to have been heeded.

Thank you.

> 5 The suggestion seems to have been heeded.

Thank you.





