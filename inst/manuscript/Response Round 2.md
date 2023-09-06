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

We apologise on this oversight on our side. Attached please find a diff between the Original submission and the revised version. We hope this helps.


> 2.6 `We implemented two methods since there is no definitive best method, and in order to check if results were sensitive to choice of method`. This sentence is confusing.

> c)  `in order to check if results were sensitive to choice of method`. This sentence needs to be clarified. There is no comparison between numerical evaluations in any sense. The numerical simulations or simulation results are not sensitive to choice or method. Indeed, the numerical solution of the dynamical model is sensitive to a set of parameters and initial conditions. Maybe the authors mean the following: to evaluate the performance of the numerical parametric sensitivity analysis of the dynamical model concerning one parametric variation (oxygen diffusivity) under two schemes.

!!! 2.6c The comment has not been addressed.

**Response:** We agree with the reviewer that there is no sensitivity to the methods themselves, but rather to the choice of oxygen variation. As this was not clear from the onset, we implemented these two methods. The paragraph in the revision reads:

> Two numerical strategies for finding final states and their sensitivity to parameters are implemented. Two strategies are implemented in order to allow comparison of their results. The first method runs a independent simulation for each combination of initial conditions and oxygen diffusivity (we term this the *Replication method*). This is the method used in the @Bush2017 study and was used to obtain the results in figures 3 and 4 of that article.

which hopefully clarifies this.

> 2.7 It is not clear why there are two `methods` for numerical parametric sensitivity analysis. The authors should include the arguments of this.

!!! 2.7 The comment has not been addressed.

Please see our response to 2.6c.



We would like to address the following comments together:

> 2.2 `finding steady states that correspond to values of one environmental driver`. The software does not find a steady state. Maybe the authors refer to the software running an open loop of the dynamic system under a set of initial conditions and a subset of parameter values (oxygen diffusivity). Then, the numerical evaluation of steady states could be related to environmental conditions in real systems.

> **Response:** We envisage and hope that Response R1 sufficiently clarifies steady state finding.


!!! 2.2 The comment has not been addressed.

> 2.3 `Two methods for finding steady states are implemented`. Again, the software does not find a steady state. Maybe the authors refer to two simulations proposed to evaluate an open loop simulation of the dynamic model numerically.

!!! 2.3 The comment has not been addressed.

For context we copied from first response:
> a)  `The steady state`. Is there a unique steady state? Is there a reported contribution concerning a formal analysis of the model in the sense of stability (stable > state existence and uniqueness)? Maybe, authors should refer as `a system's stable state (if it exists)`.
>
> **Response:** Thank you for raising this important issue, which we had overlooked. A number of the reviewer comments below are closely related, hence we sometimes refer to this response and do so using the label "Response R1". In order to clarify about the existence and uniqueness of steady states we have added the text `When one wishes to be able to make conclusions about how the steady state of the system is affected by the environmental driver, it is very important to note that the *final state* (found by the simulation) is not guaranteed to be a *steady state*. The user must ensure that the simulation is run for sufficiently long time for any transient dynamics to disappeared, and must also check the type of long-term dynamics occurring. In the results presented here, and in the paper @Limberger2022, this was performed by visual inspection, and by checking the sensitivity of conclusions to the length of the simulation. Furthermore, the package does not include methods for a formal analysis of the stability of the system and users should take care to assess if steady states are unique.`

> 2.8 Please consider rewrite the section 3.3 (see previous 2.1 - 2.7 points) in the sense of Parametric sensitivity analysis, Open loop dynamical behavior, Equilibrium points (see Khalil, H. K. (2002). Nonlinear Systems. Prentice Hall, New Jersey.)

> **Response:** We have the opinion that the with the revisions already made and detailed above, and those below, that the terminology is now more in line with this text, and will be clearly understandable by the target audience (theoretical ecologists) even when the section is not more substatially rewritten.

!!! 2.8 The comment has not been addressed.

***Response:*** These poiints raised by the Reviewer are related to the point we (hopefully) clarified in our last response above. The terminology we used, is widely used and accepted in the field this publication is aimed at, namely theoretical ecology. We do not doubt, that there is another terminology used in different fields (particularly in the field of Open Loop Dynamic Behaviour), but using that terminology, would make the article inaccessible for theoratical ecologists while at the same time (we would assume) be to simplistic to be of interest to the field of Open Loop Dynamic Behaviour Research.
We therefore would prefer to keep the terminolgy used to jeep the paper as accessible as possible for the intendeed audience.

------------------------------------------------------------------------

Dear Editor,

we did not do any textual changes in this revision as we did not receive any actionable comments from the reviewer. Most remaining comments were based on the terminology we used in the manuscript. To re-iterate, the terminology is established in the field of the intended audience (theoretical ecology) and therefore would prefer to keep it as it is.

We would humbly like to ask you if you could take a decision based on the our review and clarifications provided, as we do not see any productive way forward based on the comments of the reviewer. We would be happy to suggest potential reviewers from our field of therotecal ecology, if you would like to have a third round of review. Unfortiunately, we would object to including the current reviewer in further reviews, if requeted from your side.

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
