CC: [nkourkou\@uoi.gr](mailto:nkourkou@uoi.gr){.email}

Manuscript Number: SOFTX-D-22-00172

Microxanox: an R package for simulating an aquatic MICRobial ecosystem that can occupy OXic orANOXic states.

Dear Dr. Krug,

Thank you for submitting your manuscript to SoftwareX.

I have completed my evaluation of your manuscript. The reviewers recommend reconsideration of your manuscript following minor revision and modification. I invite you to resubmit your manuscript after addressing the comments below. Please resubmit your revised manuscript by Jun 12, 2023.

When revising your manuscript, please consider all issues mentioned in the reviewers' comments carefully: please outline every change made in response to their comments and provide suitable rebuttals for any comments not addressed. Please note that your revised submission may need to be re-reviewed.

To submit your revised manuscript, please log in as an author at <https://www.editorialmanager.com/softx/>, and navigate to the "Submissions Needing Revision" folder under the Author Main Menu.

SoftwareX values your contribution and I look forward to receiving your revised manuscript.￼

Kind regards,

Randall Sobie

Editor-in-Chief

SoftwareX

Editor and Reviewer comments:

# Reviewer #1:
> 1.  Please consider reference style: Number the references (numbers in square brackets) in the list in the order in which they appear in the text.

*##Rainer: please correct and then make a response here.*

> The authors in section 3.3 claim several sentences that could confuse readers.
2.1 `one discovers how the steady state of the system responds to the environmental conditions`. There are several concerns that the authors should clarify:

> a)  `The steady state`. Is there a unique steady state? Is there a reported contribution concerning a formal analysis of the model in the sense of stability (stable state existence and uniqueness)? Maybe, authors should refer as `a system's stable state (if it exists)`.

**Response:** We have added the text `The package does not include methods for a formal analysis of the stability of the system and users should take care to assess if steady states are unique, and indeed if a steady state has been achieved.` 

**Response:** Since we do not provide methods for formal analysis of stability, we always use "steady state" and have removed all methods of "stable state".

>`b)  `The steady state of the system responds`. It should be noted that the steady state does not respond to the environment. Maybe, the authors refer to the numerical result of a steady state as a function of parameter and initial condition (if a steady state is not unique).

**Response:** Thank you. We have edited the text so that we do not state that the steady state responds to the environment.

    
> 2.2 `finding steady states that correspond to values of one environmental driver`. The software does not find a steady state. Maybe the authors refer to the software running an open loop of the dynamic system under a set of initial conditions and a subset of parameter values (oxygen diffusivity). Then, the numerical evaluation of steady states could be related to environmental conditions in real systems.

**Response:** we do not understand why the reviewer states that the software does not find a steady state. We are very sorry that we are missing some key point of understanding here.

> 2.3 `Two methods for finding steady states are implemented`. Again, the software does not find a steady state. Maybe the authors refer to two simulations proposed to evaluate an open loop simulation of the dynamic model numerically.

**Response:** we do not understand why the reviewer states that the software does not find a steady state. We are very sorry that we are missing some key point of understanding here.

> 2.4 `The first runs a separate simulation for each combination of starting conditions and oxygen diffusivity`. This sentence is confusing. What the authors mean with `separate simulation` and `starting conditions`. Maybe the authors refer to each initial condition and parameter set value (oxygen diffusivity) as an open loop simulation run of the dynamic system. Are these simulations results focused on obtaining a bifurcation diagram Fig. 3 and 4 from {10.1038/s41467-017-00912-x}? Please clarified this point.


**Response:** We have clarified what is meant by "separate simulation" by changing to "independent simulation", and change "starting conditions" to "initial conditions". We hope that this more standard terminology is clearer. Furthermore, we have added that "This is the method used in the @Bush2017 study and was used to obtain the results in figures 3 and 4 of that article."

> 2.5 `The second runs two simulations, one with step-wise and slowly temporally increasing oxygen diffusivity, and the other with step-wise and slowly decreasing oxygen diffusivity`. This sentence needs to be clarified. Authors refer `temporally` as several changes in the value of oxygen diffusivity during a simulation run time. Maybe the authors mean the following: to explore the parametric sensitivity of the dynamic model under oxygen diffusivity variation, subset values of this parameter are numerically evaluated. Two value vectors of oxygen diffusivity are presented step-wise, gradually increasing and decreasing.

**Response:** We are grateful for this different perspective on how to explain the method and have added it to the manuscript ("Put another way, to explore the sensitivity of steady states of the dynamic model under oxygen diffusivity variation, subset values of this parameter are numerically evaluated. Two value vectors of oxygen diffusivity are presented step-wise, gradually increasing and decreasing.")

> 2.6 `We implemented two methods since there is no definitive best method, and in order to check if results were sensitive to choice of method`. This sentence is confusing.

**Response:** Thank you for pointing out this source of confusion. We change the text to "Two strategies are implemented in order to allow comparison of their results." and moved it to just after we state that two strategies are provided.

> a) `two methods` Maybe the authors mean the following: two numerical strategies to explore a parametric sensitivity numerical evaluation.

**Response:** Thank you for this suggestions. We have changed the text to "Two numerical strategies for finding steady states and their sensitivity to parameters are implemented."

> b) `there is no definitive best method`. Under which criteria? The authors present only two numerical evaluations. Please clarified this point.


**Response:** We have removed this claim since it is not demonstrated to be true and is unimportant.

> c)  `in order to check if results were sensitive to choice of method`. This sentence needs to be clarified. There is no comparison between numerical evaluations in any sense. The numerical simulations or simulation results are not sensitive to choice or method. Indeed, the numerical solution of the dynamical model is sensitive to a set of parameters and initial conditions. Maybe the authors mean the following: to evaluate the performance of the numerical parametric sensitivity analysis of the dynamical model concerning one parametric variation (oxygen diffusivity) under two schemes.2.7 It is not clear why there are two `methods` for numerical parametric sensitivity analysis. The authors should include the arguments of this.
        

**Response:** We removed this text and now simply state that having two methods allows the comparison of their results.

> 2.8 Please consider rewrite the section 3.3 (see previous 2.1 - 2.7 points) in the sense of Parametric sensitivity analysis, Open loop dynamical behavior, Equilibrium points (see Khalil, H. K. (2002). Nonlinear Systems. Prentice Hall, New Jersey.)


**Response:** we are of the opinion that the with the revisions already made and detailed above, and those below, that the terminology is now more in line with this text, and will be clearly understandable by the target audience (theoretical ecologists) even when the section is not completely rewritten.

> 3.  Please consider the following suggestions:

> Line 5 `types of ecosystem` 

Changed to  `types of ecosystems` 

>  Line 10 `Permanent link to` 

Changed to  `Permanent links to` 

>  Line 12 `role in the development of understanding about how ecosystems` 

`role in understanding how ecosystems` Changed to `Mathematical models play a key role in the development of ecosystem models and the understanding about how ecosystems work`

>  Line 13: `and how they respond` 

Changed to  `and respond` 

>  Line 15 `have played a influential role is 16 how ecosystems respond to gradual change` 

`have been influential in how ecosystems respond to a gradual change` changed to `One area of ecology in which models have been influential is the understanding of their response to a gradual change in an environmental driver [@Scheffer2001].`

>  Line 16 `is a environmental` 

Changed to `is an environmental` 

>  Line 17 `affects an ecosystem, but 18 is assumed to not be` 

Changed to  `affects an ecosystem. Still, it is assumed not to be` 

>  Line 27 `change of the system` 

Changed to  `change in the system` 

>  Line 28 `to anaerobic` 

Changed to  `to an anaerobic` 

>  Line 34 `termed the oxygen diffusitivity` 

Changed to  `termed oxygen diffusivity` 

>  Line 38 `This leaves open the question of if and how biodiversity within these types (i.e. functional groups) of bacteria affects the ecosystem` 

Changed to  `This leaves the question of if and how bacteria's biodiversity within these types (i.e., functional groups) affects the ecosystem` 

>  Line 47 `It was with this goal in mind that we developed the microxanox package` 

Changed to  `With this goal in mind, we developed the microxanox package` 

>  Line 58 `conditions, addition` 

Changed to  `conditions, the addition` 


>  Line 60 `some functions to analyse the results as well as to visualize the results to provide a starting` 

`some functions to analyze the results and visualize them to provide a starting` changed to `some functions to analyse the results and visualize these to provide a starting point`

>  Line 71 `for running individual simulations and for running a set of simulations` 

Changed to  `for running individual simulations and a set of simulations` 

>  Line 76 `the vectors and matrices, and to use matrix mathematics` 

Changed to  `the vectors and matrices and used matrix mathematics` 

>  Line 80 `code have modular structure so that new functionality can be easily added. E.g. temporally` 

Changed to  `code have a modular structure so that new functionality can be easily added. E.g., temporally` 

>  Line 87 `to maximise simplicity for the user, and` 

Changed to  `to maximize simplicity for the user and` 

>  Line 95 `results of the run` 

Changed to  `simulation results` 

>  Line 98 `parameters and re-running the simulations straightforward. In the following sections we` 

`parameters, and reruns the simulations straightforwardly. In the following sections, we` changed to `This promotes reproducibility and makes incremental changes of individual parameters with a consecutive and re-running of the simulations straightforward.`

>  Line 107 `contains among other things the` 

Changed to  `contains, among other things, the` 

>  Line 109 `their meaning and how they are created and have values set and changed please` 

Changed to  `their meaning, and how they are created and have values set and changed, please` 

>  Line 113 `an object which is identical to the parameter` 

Changed to  `an object identical to the parameter` 

>  Line 116 `to run the simulation again from` 

Changed to  `to rerun the simulation from` 

>  Line 119 `The general approach used to find the stable state of the system` 

Changed to  `The general approach to finding the numerical value of a system's stable state (if it exists)` 

>  Line ...

>  4.  Please, consider English Editing Service or Proofread Your Paper.

## ##Rainer: please would you see to this?
        
>  5.  Please, consider include two or three references of SoftwareX Journal.

##Rainer: please would you see to this?


---

---

More information and support

FAQ: How do I revise my submission in Editorial Manager?

<https://service.elsevier.com/app/answers/detail/a_id/28463/supporthub/publishing/>

You will find information relevant for you as an author on Elsevier's Author Hub: <https://www.elsevier.com/authors>

FAQ: How can I reset a forgotten password? <https://service.elsevier.com/app/answers/detail/a_id/28452/supporthub/publishing/> For further assistance, please visit our customer service site: <https://service.elsevier.com/app/home/supporthub/publishing/> Here you can search for solutions on a range of topics, find answers to frequently asked questions, and learn more about Editorial Manager via interactive tutorials. You can also talk 24/7 to our customer support team by phone and 24/7 by live chat and email

#AU_SOFTX#

To ensure this email reaches the intended recipient, please do not delete the above code

In compliance with data protection regulations, you may request that we remove your personal registration details at any time. (Remove my information/details). Please contact the publication office if you have any questions.
