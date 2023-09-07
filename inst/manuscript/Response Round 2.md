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

### Reviewer #1

> 0. It was difficult to follow the [Responses and Suggestions] in the new version. Those sections/paragraphs that have been rewritten, added, or modified in the paper should be included in the reply letter and explicitly highlight the parts that correspond precisely to each remark. The highlighted paper and the clean version should be shown at the end of the reply letter.

**Response:** We apologise on these oversights on our side. We have attached a pdf document with filename `diff_R0_R2.pdf` which shows the changes between the original submission (R0) and the current one (R2).

**Response:** Below we address each of the comments that the reviewer reported to be not addressed, and do so by first copying the original comment, and then responding.





> !!! 2.2 The comment has not been addressed.

> 2.2 `finding steady states that correspond to values of one environmental driver`. The software does not find a steady state. Maybe the authors refer to the software running an open loop of the dynamic system under a set of initial conditions and a subset of parameter values (oxygen diffusivity). Then, the numerical evaluation of steady states could be related to environmental conditions in real systems.

**Response:** In the first revision we altered text to address this comment. These alterations included but were not limited to: "When one wishes to be able to make conclusions about how the *steady state* of the system is affected by the environmental driver, it is very important to note that the *final state* (provided by the simulation) is not guaranteed to be a *steady state*. The software does not provide the user with a steady state. In order to somewhat safely assume that the final state is a steady state, the user must ensure that the simulation is run for sufficiently long time for any transient dynamics to disappeared, and must also check the type of long-term dynamics occurring."





> !!! 2.3 The comment has not been addressed.

> 2.3 `Two methods for finding steady states are implemented`. Again, the software does not find a steady state. Maybe the authors refer to two simulations proposed to evaluate an open loop simulation of the dynamic model numerically.


**Response:** We acknowledge now that the software does find a final state: e.g., "The software does not provide the user with a steady state." and do in the surrounding text carefully describe what the software does do.

**Response:** We have added "In terms of non-linear systems analysis, this would be termed a *parameteric sensitivity analysis* being conducted by running an open loop of the dynamic system under a set of initial conditions and a subset of parameter values (here oxygen diffusivity)." to the first paragraph of section 3.3.




> !!! 2.6c The comment has not been addressed.

> 2.6 c)  `in order to check if results were sensitive to choice of method`. This sentence needs to be clarified. There is no comparison between numerical evaluations in any sense. The numerical simulations or simulation results are not sensitive to choice or method. Indeed, the numerical solution of the dynamical model is sensitive to a set of parameters and initial conditions. Maybe the authors mean the following: to evaluate the performance of the numerical parametric sensitivity analysis of the dynamical model concerning one parametric variation (oxygen diffusivity) under two schemes.

**Response:** We agree with the reviewer that there is no sensitivity to the methods themselves, but rather to variation in the oxygen diffusivity parameter. We have revised the corresponding text to read: "Two numerical strategies for finding final states and their sensitivity to parameters are implemented. Two strategies are implemented in order to allow users to compare of their results. The first method runs a independent simulation for each combination of initial conditions and oxygen diffusivity (we term this the *Replication method*). This is the method used in the Bush et al (2017) study and was used to obtain the results in figures 3 and 4 of that article."




> !!! 2.7 The comment has not been addressed.

> 2.7 It is not clear why there are two `methods` for numerical parametric sensitivity analysis. The authors should include the arguments of this.

**Response**: We now state: "Two strategies are implemented in order to allow users to compare of their results."





> !!! 2.8 The comment has not been addressed.

> 2.8 Please consider rewrite the section 3.3 (see previous 2.1 - 2.7 points) in the sense of Parametric sensitivity analysis, Open loop dynamical behavior, Equilibrium points (see Khalil, H. K. (2002). Nonlinear Systems. Prentice Hall, New Jersey.)

**Response:** We have considered this request carefully. Doing so included reviewing the content of the book *Khalil (2002) Nonlinear Systems*. As a result, we have made the following two changes to section 3.3. We have added the sentence "In terms of non-linear systems analysis, this would be termed a *parameteric sensitivity analysis* being conducted by running an open loop of the dynamic system under a set of initial conditions and a subset of parameter values (here oxygen diffusivity)." in the first paragraph of section 3.3. And we have added "(or an equilibrium point)" to the sentence "When one wishes to be able to make conclusions about how the *steady state* (or an equilibrium point) of the system is affected by the environmental driver, it is very important to note that the *final state* (provided by the simulation) is not guaranteed to be a *steady state*." in the second paragraph of section 3.3.

**Response:** We have, however, refrained from a "rewrite" of section 3.3. The text as written uses terms and language that will be familiar to the intended audience: quantitative ecologists with some interest in simulating ecological systems. Changing the terms and language to that in *Khalil, H. K. (2002). Nonlinear Systems* would make it more appropriate for the intended readers of that book, namely engineers and applied mathematicians.

------------------------------------------------------------------------

Dear Editor,


Thank you for the opportunity to make a second revision. The latest comments from the reviewer included that we had made it difficult to follow our previous revisions, and so in this revision we take even more care and provide a difference file that shows the changes from the original ms to the current revision.

The reviewer also pointed out which of their original comments they felt were inadequately addressed. We revisited all of these, made additional changes in some cases, while in others we clarify the change already made. In all cases, we provide the  make a response that includes the text that was revised.

We would like to thank the reviewer for their insights, which have helped to improve the manuscript again. We would also like to that you for allowing us additional time to revise the manuscript. We hope that you will find the changes acceptable now, and hope for a positive outcome.

Sincerely,

Rainer M Krug

<!-- ------------------------------------------------------------------------

More information and support

FAQ: How do I revise my submission in Editorial Manager?

<https://service.elsevier.com/app/answers/detail/a_id/28463/supporthub/publishing/>

You will find information relevant for you as an author on Elsevier's Author Hub: <https://www.elsevier.com/authors>

FAQ: How can I reset a forgotten password? <https://service.elsevier.com/app/answers/detail/a_id/28452/supporthub/publishing/> For further assistance, please visit our customer service site: <https://service.elsevier.com/app/home/supporthub/publishing/> Here you can search for solutions on a range of topics, find answers to frequently asked questions, and learn more about Editorial Manager via interactive tutorials. You can also talk 24/7 to our customer support team by phone and 24/7 by live chat and email

#AU_SOFTX#

To ensure this email reaches the intended recipient, please do not delete the above code

In compliance with data protection regulations, you may request that we remove your personal registration details at any time. (Remove my information/details). Please contact the publication office if you have any questions. -->


