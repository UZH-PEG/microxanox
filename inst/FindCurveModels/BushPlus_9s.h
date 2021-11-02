/***
   NAME
     BushPlus
   PURPOSE
     Module computes the internal equilibrium of the stage-structured biomass model
     with a single resource and pulsed reproduction and a single predator
	 BASED ON
	 	 Based on the function 'bushplus_dynamic_model.R' as implemented in this package
	 	 	
    Last modification: RMK - Oct 29, 2021
 ***/

/*
 *=====================================================================================================
 *  PROGRAM SETTINGS
 *=====================================================================================================
 */

#define RESFLUC                   0                                     // Set resource dynamics to  
 																																				// Semi-chemostat ( = 0) or
 																																				// fluctuating dynamics ( = 1)

/*
 *=====================================================================================================
 *  DEFINITION OF PROBLEM DIMENSIONS AND NUMERICAL SETTINGS
 *=====================================================================================================
 */
// Dimension settings: Required
#define EQUATIONS_DIM             4
#define EXTRAOUTPUT_DIM           6
#define PARAMETER_NR              24

// Numerical settings: Optional (default values adopted otherwise)
#define ODESOLVE_MAX_STEP         0.1                                   // Largest step size in 
																																				// odesolver
#define ODESOLVE_REL_ERR          1.0E-10

#define DYTOL                     1.0E-8                                // Variable tolerance
#define RHSTOL                    1.0E-9                                // Function tolerance
#define ALLOWNEGATIVE             0                                     // Negative solution 
																																				// components allowed?


/*
 *=====================================================================================================
 *  DEFINITION OF ALIASES
 *=====================================================================================================
 */
// Define CB strain parameter strain 1
// cat(paste0(paste0("#define CB_", rep(1:8, each = 9)), "_", names(x$strain_parameter$CB),  "           parameter[", (0:79), "]", collapse = "\n"))
#define CB_1_strain_name           parameter[0]
#define CB_1_g_max_CB           parameter[1]
#define CB_1_k_CB_P           parameter[2]
#define CB_1_h_SR_CB           parameter[3]
#define CB_1_y_P_CB           parameter[4]
#define CB_1_Pr_CB           parameter[5]
#define CB_1_m_CB           parameter[6]
#define CB_1_i_CB           parameter[7]
#define CB_1_strain_name           parameter[8]
#define CB_2_g_max_CB           parameter[9]
#define CB_2_k_CB_P           parameter[10]
#define CB_2_h_SR_CB           parameter[11]
#define CB_2_y_P_CB           parameter[12]
#define CB_2_Pr_CB           parameter[13]
#define CB_2_m_CB           parameter[14]
#define CB_2_i_CB           parameter[15]
#define CB_2_strain_name           parameter[16]
#define CB_2_g_max_CB           parameter[17]
#define CB_3_k_CB_P           parameter[18]
#define CB_3_h_SR_CB           parameter[19]
#define CB_3_y_P_CB           parameter[20]
#define CB_3_Pr_CB           parameter[21]
#define CB_3_m_CB           parameter[22]
#define CB_3_i_CB           parameter[23]
#define CB_3_strain_name           parameter[24]
#define CB_3_g_max_CB           parameter[25]
#define CB_3_k_CB_P           parameter[26]
#define CB_4_h_SR_CB           parameter[27]
#define CB_4_y_P_CB           parameter[28]
#define CB_4_Pr_CB           parameter[29]
#define CB_4_m_CB           parameter[30]
#define CB_4_i_CB           parameter[31]
#define CB_4_strain_name           parameter[32]
#define CB_4_g_max_CB           parameter[33]
#define CB_4_k_CB_P           parameter[34]
#define CB_4_h_SR_CB           parameter[35]
#define CB_5_y_P_CB           parameter[36]
#define CB_5_Pr_CB           parameter[37]
#define CB_5_m_CB           parameter[38]
#define CB_5_i_CB           parameter[39]
#define CB_5_strain_name           parameter[40]
#define CB_5_g_max_CB           parameter[41]
#define CB_5_k_CB_P           parameter[42]
#define CB_5_h_SR_CB           parameter[43]
#define CB_5_y_P_CB           parameter[44]
#define CB_6_Pr_CB           parameter[45]
#define CB_6_m_CB           parameter[46]
#define CB_6_i_CB           parameter[47]
#define CB_6_strain_name           parameter[48]
#define CB_6_g_max_CB           parameter[49]
#define CB_6_k_CB_P           parameter[50]
#define CB_6_h_SR_CB           parameter[51]
#define CB_6_y_P_CB           parameter[52]
#define CB_6_Pr_CB           parameter[53]
#define CB_7_m_CB           parameter[54]
#define CB_7_i_CB           parameter[55]
#define CB_7_strain_name           parameter[56]
#define CB_7_g_max_CB           parameter[57]
#define CB_7_k_CB_P           parameter[58]
#define CB_7_h_SR_CB           parameter[59]
#define CB_7_y_P_CB           parameter[60]
#define CB_7_Pr_CB           parameter[61]
#define CB_7_m_CB           parameter[62]
#define CB_8_i_CB           parameter[63]
#define CB_8_strain_name           parameter[64]
#define CB_8_g_max_CB           parameter[65]
#define CB_8_k_CB_P           parameter[66]
#define CB_8_h_SR_CB           parameter[67]
#define CB_8_y_P_CB           parameter[68]
#define CB_8_Pr_CB           parameter[69]
#define CB_8_m_CB           parameter[70]
#define CB_8_i_CB           parameter[71]
#define CB_1_strain_name           parameter[72]
#define CB_1_g_max_CB           parameter[73]
#define CB_1_k_CB_P           parameter[74]
#define CB_1_h_SR_CB           parameter[75]
#define CB_1_y_P_CB           parameter[76]
#define CB_1_Pr_CB           parameter[77]
#define CB_1_m_CB           parameter[78]
#define CB_1_i_CB           parameter[79]

// Define PB strain parameter
// cat(paste0(paste0("#define PB_", rep(1:9, each = 9)), "_", names(x$strain_parameter$PB),  "           parameter[", (1:81) + 79, "]", collapse = "\n"))
#define PB_1_strain_name           parameter[80]
#define PB_1_g_max_PB           parameter[81]
#define PB_1_k_PB_SR           parameter[82]
#define PB_1_k_PB_P           parameter[83]
#define PB_1_h_O_PB           parameter[84]
#define PB_1_y_SR_PB           parameter[85]
#define PB_1_y_P_PB           parameter[86]
#define PB_1_m_PB           parameter[87]
#define PB_1_i_PB           parameter[88]
#define PB_2_strain_name           parameter[89]
#define PB_2_g_max_PB           parameter[90]
#define PB_2_k_PB_SR           parameter[91]
#define PB_2_k_PB_P           parameter[92]
#define PB_2_h_O_PB           parameter[93]
#define PB_2_y_SR_PB           parameter[94]
#define PB_2_y_P_PB           parameter[95]
#define PB_2_m_PB           parameter[96]
#define PB_2_i_PB           parameter[97]
#define PB_3_strain_name           parameter[98]
#define PB_3_g_max_PB           parameter[99]
#define PB_3_k_PB_SR           parameter[100]
#define PB_3_k_PB_P           parameter[101]
#define PB_3_h_O_PB           parameter[102]
#define PB_3_y_SR_PB           parameter[103]
#define PB_3_y_P_PB           parameter[104]
#define PB_3_m_PB           parameter[105]
#define PB_3_i_PB           parameter[106]
#define PB_4_strain_name           parameter[107]
#define PB_4_g_max_PB           parameter[108]
#define PB_4_k_PB_SR           parameter[109]
#define PB_4_k_PB_P           parameter[110]
#define PB_4_h_O_PB           parameter[111]
#define PB_4_y_SR_PB           parameter[112]
#define PB_4_y_P_PB           parameter[113]
#define PB_4_m_PB           parameter[114]
#define PB_4_i_PB           parameter[115]
#define PB_5_strain_name           parameter[116]
#define PB_5_g_max_PB           parameter[117]
#define PB_5_k_PB_SR           parameter[118]
#define PB_5_k_PB_P           parameter[119]
#define PB_5_h_O_PB           parameter[120]
#define PB_5_y_SR_PB           parameter[121]
#define PB_5_y_P_PB           parameter[122]
#define PB_5_m_PB           parameter[123]
#define PB_5_i_PB           parameter[124]
#define PB_6_strain_name           parameter[125]
#define PB_6_g_max_PB           parameter[126]
#define PB_6_k_PB_SR           parameter[127]
#define PB_6_k_PB_P           parameter[128]
#define PB_6_h_O_PB           parameter[129]
#define PB_6_y_SR_PB           parameter[130]
#define PB_6_y_P_PB           parameter[131]
#define PB_6_m_PB           parameter[132]
#define PB_6_i_PB           parameter[133]
#define PB_7_strain_name           parameter[134]
#define PB_7_g_max_PB           parameter[135]
#define PB_7_k_PB_SR           parameter[136]
#define PB_7_k_PB_P           parameter[137]
#define PB_7_h_O_PB           parameter[138]
#define PB_7_y_SR_PB           parameter[139]
#define PB_7_y_P_PB           parameter[140]
#define PB_7_m_PB           parameter[141]
#define PB_7_i_PB           parameter[142]
#define PB_8_strain_name           parameter[143]
#define PB_8_g_max_PB           parameter[144]
#define PB_8_k_PB_SR           parameter[145]
#define PB_8_k_PB_P           parameter[146]
#define PB_8_h_O_PB           parameter[147]
#define PB_8_y_SR_PB           parameter[148]
#define PB_8_y_P_PB           parameter[149]
#define PB_8_m_PB           parameter[150]
#define PB_8_i_PB           parameter[151]
#define PB_9_strain_name           parameter[152]
#define PB_9_g_max_PB           parameter[153]
#define PB_9_k_PB_SR           parameter[154]
#define PB_9_k_PB_P           parameter[155]
#define PB_9_h_O_PB           parameter[156]
#define PB_9_y_SR_PB           parameter[157]
#define PB_9_y_P_PB           parameter[158]
#define PB_9_m_PB           parameter[159]
#define PB_9_i_PB           parameter[160]

// Define SB strain parameter
// cat(paste0(paste0("#define SB_", rep(1:9, each = 9)), "_", names(x$strain_parameter$SB),  "           parameter[", (1:81) + 160, "]", collapse = "\n"))
#define SB_1_strain_name           parameter[161]
#define SB_1_g_max_SB           parameter[162]
#define SB_1_k_SB_SO           parameter[163]
#define SB_1_k_SB_P           parameter[164]
#define SB_1_h_O_SB           parameter[165]
#define SB_1_y_SO_SB           parameter[166]
#define SB_1_y_P_SB           parameter[167]
#define SB_1_m_SB           parameter[168]
#define SB_1_i_SB           parameter[169]
#define SB_2_strain_name           parameter[170]
#define SB_2_g_max_SB           parameter[171]
#define SB_2_k_SB_SO           parameter[172]
#define SB_2_k_SB_P           parameter[173]
#define SB_2_h_O_SB           parameter[174]
#define SB_2_y_SO_SB           parameter[175]
#define SB_2_y_P_SB           parameter[176]
#define SB_2_m_SB           parameter[177]
#define SB_2_i_SB           parameter[178]
#define SB_3_strain_name           parameter[179]
#define SB_3_g_max_SB           parameter[180]
#define SB_3_k_SB_SO           parameter[181]
#define SB_3_k_SB_P           parameter[182]
#define SB_3_h_O_SB           parameter[183]
#define SB_3_y_SO_SB           parameter[184]
#define SB_3_y_P_SB           parameter[185]
#define SB_3_m_SB           parameter[186]
#define SB_3_i_SB           parameter[187]
#define SB_4_strain_name           parameter[188]
#define SB_4_g_max_SB           parameter[189]
#define SB_4_k_SB_SO           parameter[190]
#define SB_4_k_SB_P           parameter[191]
#define SB_4_h_O_SB           parameter[192]
#define SB_4_y_SO_SB           parameter[193]
#define SB_4_y_P_SB           parameter[194]
#define SB_4_m_SB           parameter[195]
#define SB_4_i_SB           parameter[196]
#define SB_5_strain_name           parameter[197]
#define SB_5_g_max_SB           parameter[198]
#define SB_5_k_SB_SO           parameter[199]
#define SB_5_k_SB_P           parameter[200]
#define SB_5_h_O_SB           parameter[201]
#define SB_5_y_SO_SB           parameter[202]
#define SB_5_y_P_SB           parameter[203]
#define SB_5_m_SB           parameter[204]
#define SB_5_i_SB           parameter[205]
#define SB_6_strain_name           parameter[206]
#define SB_6_g_max_SB           parameter[207]
#define SB_6_k_SB_SO           parameter[208]
#define SB_6_k_SB_P           parameter[209]
#define SB_6_h_O_SB           parameter[210]
#define SB_6_y_SO_SB           parameter[211]
#define SB_6_y_P_SB           parameter[212]
#define SB_6_m_SB           parameter[213]
#define SB_6_i_SB           parameter[214]
#define SB_7_strain_name           parameter[215]
#define SB_7_g_max_SB           parameter[216]
#define SB_7_k_SB_SO           parameter[217]
#define SB_7_k_SB_P           parameter[218]
#define SB_7_h_O_SB           parameter[219]
#define SB_7_y_SO_SB           parameter[220]
#define SB_7_y_P_SB           parameter[221]
#define SB_7_m_SB           parameter[222]
#define SB_7_i_SB           parameter[223]
#define SB_8_strain_name           parameter[224]
#define SB_8_g_max_SB           parameter[225]
#define SB_8_k_SB_SO           parameter[226]
#define SB_8_k_SB_P           parameter[227]
#define SB_8_h_O_SB           parameter[228]
#define SB_8_y_SO_SB           parameter[229]
#define SB_8_y_P_SB           parameter[230]
#define SB_8_m_SB           parameter[231]
#define SB_8_i_SB           parameter[232]
#define SB_9_strain_name           parameter[233]
#define SB_9_g_max_SB           parameter[234]
#define SB_9_k_SB_SO           parameter[235]
#define SB_9_k_SB_P           parameter[236]
#define SB_9_h_O_SB           parameter[237]
#define SB_9_y_SO_SB           parameter[238]
#define SB_9_y_P_SB           parameter[239]
#define SB_9_m_SB           parameter[240]
#define SB_9_i_SB           parameter[241]

// general strain parameter
#define a_S                       parameter[242]
#define a_O                       parameter[243]
#define a_P                       parameter[244]
#define back_SR                   parameter[245]
#define back_SO                   parameter[246]
#define back_O                    parameter[247]
#define back_P                    parameter[248]
#define c                         parameter[249]


// additional parameter
#define noise_sigma               parameter[250]
#define minimum_abundances_CB     parameter[251]
#define minimum_abundances_PB     parameter[252]
#define minimum_abundances_SB     parameter[253]



/*
 *=====================================================================================================
 *  DEFINITION OF NAMES AND DEFAULT VALUES OF THE PARAMETERS
 *=====================================================================================================
 */
// At least two parameters should be specified in this array
char *parameternames[PARAMETER_NR] = {"Delta", "Rmax",     "Mc",  "Tc", "Sigmac", "Zc",     
																			"Muc", "Qc",  "Hc", "MucPlus", "MucjPlus", "MucaPlus",
                                      "EPS",   "Interval", "Psi", "Mp", "Tp",     "Sigmap", 
                                      "Mup", "Phi", "Hp", "Muplusp", "FuncResp", "AresF"};

// These are the default parameters values
double parameter[PARAMETER_NR] = {0.1, 30.0, 1.0, 0.1,  0.5,   0.1, 0.015, 1.5, 3.0, 0.0, 0.0, 0.0,
                                  0.0, 70.0, 0.0, 0.32, 0.032, 0.5, 0.005, 0.0, 3.0, 0.0, 1.0, 0.0};

/*
 *=====================================================================================================
 *  DEFINITION OF THE SYSTEM OF EQUATIONS TO SOLVE
 *=====================================================================================================
 */

#undef MAX_EXP
#define MAX_EXP                   50.0

double Maturation(double z, double nuj, double muj)

{
  double  logz, tmp, tres, matrate = 0.0;

  logz = log(z);
  tres = muj/(1.0 - MAX_EXP/logz);
  if (nuj < tres)
    matrate = 0.0;
  else
    {
      tmp = 1.0 - muj/nuj;
      if (fabs(tmp) < 1.0E-6)
        matrate = tmp/2 - 1/logz;
      else
        matrate = tmp/(1.0 - exp(tmp*logz));
    }
  matrate *= nuj;

  return matrate;
}


/*====================================================================================================*/

// The ODE system defining the change in state variables during the growth period

#define ODEDIM 11
static double                     StoredVals[ODEDIM];
static int                        OdeDim = ODEDIM;

#define R                         argument[0]                           // Resource
#define CJ                        argument[1]                           // Juvenile consumers
#define CA                        argument[2]                           // Adult consumers
#define P                         argument[3]                           // Predator biomass
#define B                         argument[4]                           // energy storage

#define DRDT                      derivative[0]                         // Resource
#define DCJDT                     derivative[1]                         // Juvenile consumers
#define DCADT                     derivative[2]                         // Adult consumers
#define DPDT                      derivative[3]                         // Predator
#define DBDT                      derivative[4]                         // Energy storage

void WithinSeason(double t, double *argument, double *derivative)
{
  static double ingest_R = 0.0;
  static double nu_J, nu_A;
  static double mort_J, mort_A, maturation, encP;
#if (RESFLUC == 1)
  static double rfluc;
#endif

  ingest_R = MC*((2 - QC)*CJ + QC*CA)*R/((1 - FUNCRESP) + FUNCRESP*(R + HC));
  nu_J     = SIGMAC*(2 - QC)*MC*R/((1 - FUNCRESP) + FUNCRESP*(R + HC)) - TC;
  nu_A     = SIGMAC*QC*MC*R/((1 - FUNCRESP) + FUNCRESP*(R + HC)) - TC*(1 + EPS*B/CA);

  encP = PHI*CJ + (1 - PHI)*(CA + B);

  // mort_J   = MUC - (nu_J - max(nu_J, 0.0));
  // Starvation mortality (max(nu_J, 0.0)-nu_J) included here !
  mort_J = MUC + MUCJPLUS + MUCPLUS + max(-nu_J, 0.0) + MP*PHI*P/((1 - FUNCRESP) + FUNCRESP*(encP + HP));
  mort_A = MUC + MUCAPLUS + MUCPLUS + max(-nu_A, 0.0) + MP*(1 - PHI)*P/((1 - FUNCRESP) + FUNCRESP*(encP + HP));

  maturation = Maturation(ZC, nu_J, mort_J)*CJ;

#if (RESFLUC == 0)
  DRDT = DELTAR*(RMAX - R) - ingest_R;
#elif (RESFLUC == 1)
  rfluc = RMAX*(1 + ARESF*sin(2*M_PI*t/INTERVAL));
  DRDT  = DELTAR*(rfluc - R) - ingest_R;
#endif

  DCJDT = max(nu_J, 0.0)*CJ - maturation - mort_J*CJ + PSI*max(nu_A, 0.0)*CA;
  DCADT = maturation - mort_A*CA;
  DPDT  = (SIGMAP*MP*encP/((1 - FUNCRESP) + FUNCRESP*(encP + HP)) - TP - MUP - MUPLUSP)*P;
  DBDT  = (1 - PSI)*max(nu_A, 0.0)*CA - mort_A*B;

  // Integrate the following ODEs only for output purposes
  if (OdeDim == ODEDIM)
    {
      derivative[5]  = R;
      derivative[6]  = CJ;
      derivative[7]  = CA + B;
      derivative[8]  = CJ + CA + B;
      derivative[9]  = P;
      derivative[10] = (SIGMAP*MP*encP/((1 - FUNCRESP) + FUNCRESP*(encP + HP)) - TP - MUP - MUPLUSP);
    }

  return;
}


/*====================================================================================================*/

// Routine specifying the system of equalities from which to solve for
// R, J and A at equilibrium
#define PERIOD 1

int Equations(double *argument, double *result)

{
  int     period;
  double  tval, tend, x[ODEDIM];

  //================================================================================
  // Set the initial point for the ODEs

  memset(x, 0, ODEDIM*sizeof(double));
  x[0] = R;
  x[1] = CJ;
  x[2] = CA;
  x[3] = P;

  if (result)
    OdeDim = 5;
  else
    OdeDim = ODEDIM;
  tval     = 0.0;
  tend     = INTERVAL;

  for (period = 0; period < PERIOD; period++)
    {
      tend = (period + 1)*INTERVAL;
      // Integrate up to end of the growing phase
      if (odesolve(x, OdeDim, &tval, tend, WithinSeason, NULL) == FAILURE)
        {
          ErrorMsg(__FILE__, __LINE__, "Integration failed!");
          return FAILURE;
        }
      if (!result) memcpy(StoredVals, x, ODEDIM*sizeof(double));
      x[1] += x[4];                                                     // Add reproductive mass 
      																																	// to juveniles
      x[4] = 0.0;                                                       // Reset reproductive mass
    }

  //================================================================================
  // Compute the final values of the fixed point equation F(y)=0,

  if (result)
    {
      result[0] = (R - x[0]);
      result[1] = (CJ - x[1]);
      result[2] = (CA - x[2]);
      result[3] = (P - x[3]);
    }

  return SUCCES;
}


/*====================================================================================================*/

// Define all variables to be written to the output file (column-organized ASCII file)

int DefineExtraOutput(double *argument, double *ExtraOutput)

{
  // Invoke the routine that sets the right-hand side for setting the output variables
  if (Equations(argument, NULL) == FAILURE) return FAILURE;

  ExtraOutput[0] = StoredVals[5]/INTERVAL;                              // Average resource
  ExtraOutput[1] = StoredVals[6]/INTERVAL;                              // Average Cj
  ExtraOutput[2] = StoredVals[7]/INTERVAL;                              // Avergae Ca+Cb
  ExtraOutput[3] = StoredVals[8]/INTERVAL;                              // Average Cj+Ca+Cb
  ExtraOutput[4] = StoredVals[9]/INTERVAL;                              // Average P
  ExtraOutput[5] = StoredVals[10]/INTERVAL;                             // P.C. growth rate P

  return SUCCES;
}


/*====================================================================================================*/
