/***
   	NAME
    	BushPlus
   	PURPOSE
    	To Be Added
	BASED ON
	 	Based on the function 'bushplus_dynamic_model.R' as implemented in this package
	COMMENTS
		1. no events included in this C implementation 	 	
		2. no minimum_abundances
		3. no noise_sigma
		4. no forcing function log10a_forcing_func
    Last modification: RMK - Nov 15, 2021
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
#define EQUATIONS_DIM             3
#define EXTRAOUTPUT_DIM           6
#define PARAMETER_NR              242

// Numerical settings: Optional (default values adopted otherwise)
#define ODESOLVE_MAX_STEP         0.1                                   // Largest step size in 
																																				// odesolver
#define ODESOLVE_REL_ERR          1.0E-10

#define DYTOL                     1.0E-8                                // Variable tolerance
#define RHSTOL                    1.0E-9                                // Function tolerance
#define ALLOWNEGATIVE             0                                     // Negative solution 
																																				// components allowed?

#define NO_STRAINS								9

/*
 *=====================================================================================================
 *  DEFINITION OF NAMES AND DEFAULT VALUES OF THE PARAMETERS
 *=====================================================================================================
 */
 
 
// At least two parameters should be specified in this array
// cat(paste0(paste0("\"CB_", rep(1:9, each = 8)), "_", names(x$strain_parameter$CB), "\", "))
// cat(paste0(paste0("\"PB_", rep(1:9, each = 9)), "_", names(x$strain_parameter$PB), "\", "))
// cat(paste0(paste0("\"SB_", rep(1:9, each = 9)), "_", names(x$strain_parameter$SB), "\", "))
// char *parameternames[PARAMETER_NR] = {
// "CB_1_strain_name",  "CB_1_g_max_CB",  "CB_1_k_CB_P",  "CB_1_h_SR_CB",  "CB_1_y_P_CB",  "CB_1_Pr_CB",  "CB_1_m_CB",  "CB_1_i_CB",  
// "CB_2_strain_name",  "CB_2_g_max_CB",  "CB_2_k_CB_P",  "CB_2_h_SR_CB",  "CB_2_y_P_CB",  "CB_2_Pr_CB",  "CB_2_m_CB",  "CB_2_i_CB",  
// "CB_3_strain_name",  "CB_3_g_max_CB",  "CB_3_k_CB_P",  "CB_3_h_SR_CB",  "CB_3_y_P_CB",  "CB_3_Pr_CB",  "CB_3_m_CB",  "CB_3_i_CB",  
// "CB_4_strain_name",  "CB_4_g_max_CB",  "CB_4_k_CB_P",  "CB_4_h_SR_CB",  "CB_4_y_P_CB",  "CB_4_Pr_CB",  "CB_4_m_CB",  "CB_4_i_CB",  
// "CB_5_strain_name",  "CB_5_g_max_CB",  "CB_5_k_CB_P",  "CB_5_h_SR_CB",  "CB_5_y_P_CB",  "CB_5_Pr_CB",  "CB_5_m_CB",  "CB_5_i_CB",  
// "CB_6_strain_name",  "CB_6_g_max_CB",  "CB_6_k_CB_P",  "CB_6_h_SR_CB",  "CB_6_y_P_CB",  "CB_6_Pr_CB",  "CB_6_m_CB",  "CB_6_i_CB",  
// "CB_7_strain_name",  "CB_7_g_max_CB",  "CB_7_k_CB_P",  "CB_7_h_SR_CB",  "CB_7_y_P_CB",  "CB_7_Pr_CB",  "CB_7_m_CB",  "CB_7_i_CB",  
// "CB_8_strain_name",  "CB_8_g_max_CB",  "CB_8_k_CB_P",  "CB_8_h_SR_CB",  "CB_8_y_P_CB",  "CB_8_Pr_CB",  "CB_8_m_CB",  "CB_8_i_CB",  
// "CB_9_strain_name",  "CB_9_g_max_CB",  "CB_9_k_CB_P",  "CB_9_h_SR_CB",  "CB_9_y_P_CB",  "CB_9_Pr_CB",  "CB_9_m_CB",  "CB_9_i_CB", 
// 
// "PB_1_strain_name",  "PB_1_g_max_PB",  "PB_1_k_PB_SR",  "PB_1_k_PB_P",  "PB_1_h_O_PB",  "PB_1_y_SO_SB",  "PB_1_y_P_PB",  "PB_1_m_PB",  "PB_1_i_PB",  
// "PB_2_strain_name",  "PB_2_g_max_PB",  "PB_2_k_PB_SR",  "PB_2_k_PB_P",  "PB_2_h_O_PB",  "PB_2_y_SO_SB",  "PB_2_y_P_PB",  "PB_2_m_PB",  "PB_2_i_PB",  
// "PB_3_strain_name",  "PB_3_g_max_PB",  "PB_3_k_PB_SR",  "PB_3_k_PB_P",  "PB_3_h_O_PB",  "PB_3_y_SO_SB",  "PB_3_y_P_PB",  "PB_3_m_PB",  "PB_3_i_PB",  
// "PB_4_strain_name",  "PB_4_g_max_PB",  "PB_4_k_PB_SR",  "PB_4_k_PB_P",  "PB_4_h_O_PB",  "PB_4_y_SO_SB",  "PB_4_y_P_PB",  "PB_4_m_PB",  "PB_4_i_PB",  
// "PB_5_strain_name",  "PB_5_g_max_PB",  "PB_5_k_PB_SR",  "PB_5_k_PB_P",  "PB_5_h_O_PB",  "PB_5_y_SO_SB",  "PB_5_y_P_PB",  "PB_5_m_PB",  "PB_5_i_PB",  
// "PB_6_strain_name",  "PB_6_g_max_PB",  "PB_6_k_PB_SR",  "PB_6_k_PB_P",  "PB_6_h_O_PB",  "PB_6_y_SO_SB",  "PB_6_y_P_PB",  "PB_6_m_PB",  "PB_6_i_PB",  
// "PB_7_strain_name",  "PB_7_g_max_PB",  "PB_7_k_PB_SR",  "PB_7_k_PB_P",  "PB_7_h_O_PB",  "PB_7_y_SO_SB",  "PB_7_y_P_PB",  "PB_7_m_PB",  "PB_7_i_PB",  
// "PB_8_strain_name",  "PB_8_g_max_PB",  "PB_8_k_PB_SR",  "PB_8_k_PB_P",  "PB_8_h_O_PB",  "PB_8_y_SO_SB",  "PB_8_y_P_PB",  "PB_8_m_PB",  "PB_8_i_PB",  
// "PB_9_strain_name",  "PB_9_g_max_PB",  "PB_9_k_PB_SR",  "PB_9_k_PB_P",  "PB_9_h_O_PB",  "PB_9_y_SO_SB",  "PB_9_y_P_PB",  "PB_9_m_PB",  "PB_9_i_PB",
// 
// "SB_1_strain_name",  "SB_1_g_max_SB",  "SB_1_k_SB_SO",  "SB_1_k_SB_P",  "SB_1_h_O_SB",  "SB_1_y_SO_SB",  "SB_1_y_P_SB",  "SB_1_m_SB",  "SB_1_i_SB",  
// "SB_2_strain_name",  "SB_2_g_max_SB",  "SB_2_k_SB_SO",  "SB_2_k_SB_P",  "SB_2_h_O_SB",  "SB_2_y_SO_SB",  "SB_2_y_P_SB",  "SB_2_m_SB",  "SB_2_i_SB",  
// "SB_3_strain_name",  "SB_3_g_max_SB",  "SB_3_k_SB_SO",  "SB_3_k_SB_P",  "SB_3_h_O_SB",  "SB_3_y_SO_SB",  "SB_3_y_P_SB",  "SB_3_m_SB",  "SB_3_i_SB", 
// "SB_4_strain_name",  "SB_4_g_max_SB",  "SB_4_k_SB_SO",  "SB_4_k_SB_P",  "SB_4_h_O_SB",  "SB_4_y_SO_SB",  "SB_4_y_P_SB",  "SB_4_m_SB",  "SB_4_i_SB",  
// "SB_5_strain_name",  "SB_5_g_max_SB",  "SB_5_k_SB_SO",  "SB_5_k_SB_P",  "SB_5_h_O_SB",  "SB_5_y_SO_SB",  "SB_5_y_P_SB",  "SB_5_m_SB",  "SB_5_i_SB",  
// "SB_6_strain_name",  "SB_6_g_max_SB",  "SB_6_k_SB_SO",  "SB_6_k_SB_P",  "SB_6_h_O_SB",  "SB_6_y_SO_SB",  "SB_6_y_P_SB",  "SB_6_m_SB",  "SB_6_i_SB",  
// "SB_7_strain_name",  "SB_7_g_max_SB",  "SB_7_k_SB_SO",  "SB_7_k_SB_P",  "SB_7_h_O_SB",  "SB_7_y_SO_SB",  "SB_7_y_P_SB",  "SB_7_m_SB",  "SB_7_i_SB",  
// "SB_8_strain_name",  "SB_8_g_max_SB",  "SB_8_k_SB_SO",  "SB_8_k_SB_P",  "SB_8_h_O_SB",  "SB_8_y_SO_SB",  "SB_8_y_P_SB",  "SB_8_m_SB",  "SB_8_i_SB",  
// "SB_9_strain_name",  "SB_9_g_max_SB",  "SB_9_k_SB_SO",  "SB_9_k_SB_P",  "SB_9_h_O_SB",  "SB_9_y_SO_SB",  "SB_9_y_P_SB",  "SB_9_m_SB",  "SB_9_i_SB", 
// "a_S", "a_O", "a_P", "back_SR", "back_SO", "back_O", "back_P", "c"
// // "noise_sigma", "minimum_abundances_CB", "minimum_abundances_PB", "minimum_abundances_SB"
// };

// These are the default parameters values
// x$strain_parameter$CB
// x$strain_parameter$SB
double parameter[PARAMETER_NR] = {
1.1, 0.05, 0.2, 300, 1.67E+08, 6E-09, 0.02, 0,
1.2, 0.05, 0.2, 300, 1.67E+08, 6E-09, 0.02, 0,
1.3, 0.05, 0.2, 300, 1.67E+08, 6E-09, 0.02, 0,
1.4, 0.05, 0.2, 300, 1.67E+08, 6E-09, 0.02, 0,
1.5, 0.05, 0.2, 300, 1.67E+08, 6E-09, 0.02, 0,
1.6, 0.05, 0.2, 300, 1.67E+08, 6E-09, 0.02, 0,
1.7, 0.05, 0.2, 300, 1.67E+08, 6E-09, 0.02, 0,
1.8, 0.05, 0.2, 300, 1.67E+08, 6E-09, 0.02, 0,
1.9, 0.05, 0.2, 300, 1.67E+08, 6E-09, 0.02, 0,

2.1, 0.07,  10, 0.5, 100, 12500000, 1.67E+08, 0.028, 0,
2.2, 0.07,  10, 0.5, 100, 12500000, 1.67E+08, 0.028, 0,
2.3, 0.07,  10, 0.5, 100, 12500000, 1.67E+08, 0.028, 0,
2.4, 0.07,  10, 0.5, 100, 12500000, 1.67E+08, 0.028, 0,
2.5, 0.07,  10, 0.5, 100, 12500000, 1.67E+08, 0.028, 0,
2.6, 0.07,  10, 0.5, 100, 12500000, 1.67E+08, 0.028, 0,
2.7, 0.07,  10, 0.5, 100, 12500000, 1.67E+08, 0.028, 0,
2.8, 0.07,  10, 0.5, 100, 12500000, 1.67E+08, 0.028, 0,
2.9, 0.07,  10, 0.5, 100, 12500000, 1.67E+08, 0.028, 0,

3.1, 0.1, 5, 0.5, 100, 33300000, 1.67E+08, 0.04, 0,
3.2, 0.1, 5, 0.5, 100, 33300000, 1.67E+08, 0.04, 0,
3.3, 0.1, 5, 0.5, 100, 33300000, 1.67E+08, 0.04, 0,
3.4, 0.1, 5, 0.5, 100, 33300000, 1.67E+08, 0.04, 0,
3.5, 0.1, 5, 0.5, 100, 33300000, 1.67E+08, 0.04, 0,
3.6, 0.1, 5, 0.5, 100, 33300000, 1.67E+08, 0.04, 0,
3.7, 0.1, 5, 0.5, 100, 33300000, 1.67E+08, 0.04, 0,
3.8, 0.1, 5, 0.5, 100, 33300000, 1.67E+08, 0.04, 0,
3.9, 0.1, 5, 0.5, 100, 33300000, 1.67E+08, 0.04, 0,

0.001, 8E-04, 0.01, 300, 300, 300, 9.5, 4E-05
// 0, 1, 1, 1
};


/*
 *=====================================================================================================y_SO_SB\t\t\t
 *  DEFINITION OF ALIASES AND VARIABLES
 *=====================================================================================================
 */

// Define state for the 9 strain model
// cat(paste0("#define ", names(new_initial_state(9, 9, 9)), "			rate[", 0:30, "]", collapse = "\n"), "\n")
double state[NO_STRAINS * 3 + 4];
//
#define CB_1			state[0]
#define CB_2			state[1]
#define CB_3			state[2]
#define CB_4			state[3]
#define CB_5			state[4]
#define CB_6			state[5]
#define CB_7			state[6]
#define CB_8			state[7]
#define CB_9			state[8]
#define PB_1			state[9]
#define PB_2			state[10]
#define PB_3			state[11]
#define PB_4			state[12]
#define PB_5			state[13]
#define PB_6			state[14]
#define PB_7			state[15]
#define PB_8			state[16]
#define PB_9			state[17]
#define SB_1			state[18]
#define SB_2			state[19]
#define SB_3			state[20]
#define SB_4			state[21]
#define SB_5			state[22]
#define SB_6			state[23]
#define SB_7			state[24]
#define SB_8			state[25]
#define SB_9			state[26]
#define SO  			state[27]
#define SR  			state[28]
#define O   			state[29]
#define P					state[30]


// Define rate for the 9 strain model
// cat(paste0("#define ", names(new_initial_state(9, 9, 9)), "			rate[", 0:30, "]", collapse = "\n"), "\n")
double rate[NO_STRAINS * 3 + 4];
//
#define CB_1_rate			rate[0]
#define CB_2_rate			rate[1]
#define CB_3_rate			rate[2]
#define CB_4_rate			rate[3]
#define CB_5_rate			rate[4]
#define CB_6_rate			rate[5]
#define CB_7_rate			rate[6]
#define CB_8_rate			rate[7]
#define CB_9_rate			rate[8]
#define PB_1_rate			rate[9]
#define PB_2_rate			rate[10]
#define PB_3_rate			rate[11]
#define PB_4_rate			rate[12]
#define PB_5_rate			rate[13]
#define PB_6_rate			rate[14]
#define PB_7_rate			rate[15]
#define PB_8_rate			rate[16]
#define PB_9_rate			rate[17]
#define SB_1_rate			rate[18]
#define SB_2_rate			rate[19]
#define SB_3_rate			rate[20]
#define SB_4_rate			rate[21]
#define SB_5_rate			rate[22]
#define SB_6_rate			rate[23]
#define SB_7_rate			rate[24]
#define SB_8_rate			rate[25]
#define SB_9_rate			rate[26]
#define SO_rate  			rate[27]
#define SR_rate  			rate[28]
#define O_rate   			rate[29]
#define P_rate				rate[30]



// Define CB strain parameter strain 1
// cat(paste0(paste0("#define CB_", rep(1:9, each = 8)), "_", names(x$strain_parameter$CB),  "			parameter[", (0:71), "]", collapse = "\n"))
#define CB_1_strain_name	parameter[0]
#define CB_1_g_max_CB		parameter[1]
#define CB_1_k_CB_P			parameter[2]
#define CB_1_h_SR_CB		parameter[3]
#define CB_1_y_P_CB			parameter[4]
#define CB_1_Pr_CB			parameter[5]
#define CB_1_m_CB			parameter[6]
#define CB_1_i_CB			parameter[7]
#define CB_2_strain_name	parameter[8]
#define CB_2_g_max_CB		parameter[9]
#define CB_2_k_CB_P			parameter[10]
#define CB_2_h_SR_CB		parameter[11]
#define CB_2_y_P_CB			parameter[12]
#define CB_2_Pr_CB			parameter[13]
#define CB_2_m_CB			parameter[14]
#define CB_2_i_CB			parameter[15]
#define CB_3_strain_name	parameter[16]
#define CB_3_g_max_CB		parameter[17]
#define CB_3_k_CB_P			parameter[18]
#define CB_3_h_SR_CB		parameter[19]
#define CB_3_y_P_CB			parameter[20]
#define CB_3_Pr_CB			parameter[21]
#define CB_3_m_CB			parameter[22]
#define CB_3_i_CB			parameter[23]
#define CB_4_strain_name	parameter[24]
#define CB_4_g_max_CB		parameter[25]
#define CB_4_k_CB_P			parameter[26]
#define CB_4_h_SR_CB		parameter[27]
#define CB_4_y_P_CB			parameter[28]
#define CB_4_Pr_CB			parameter[29]
#define CB_4_m_CB			parameter[30]
#define CB_4_i_CB			parameter[31]
#define CB_5_strain_name	parameter[32]
#define CB_5_g_max_CB		parameter[33]
#define CB_5_k_CB_P			parameter[34]
#define CB_5_h_SR_CB		parameter[35]
#define CB_5_y_P_CB			parameter[36]
#define CB_5_Pr_CB			parameter[37]
#define CB_5_m_CB			parameter[38]
#define CB_5_i_CB			parameter[39]
#define CB_6_strain_name	parameter[40]
#define CB_6_g_max_CB		parameter[41]
#define CB_6_k_CB_P			parameter[42]
#define CB_6_h_SR_CB		parameter[43]
#define CB_6_y_P_CB			parameter[44]
#define CB_6_Pr_CB			parameter[45]
#define CB_6_m_CB			parameter[46]
#define CB_6_i_CB			parameter[47]
#define CB_7_strain_name	parameter[48]
#define CB_7_g_max_CB		parameter[49]
#define CB_7_k_CB_P			parameter[50]
#define CB_7_h_SR_CB		parameter[51]
#define CB_7_y_P_CB			parameter[52]
#define CB_7_Pr_CB			parameter[53]
#define CB_7_m_CB			parameter[54]
#define CB_7_i_CB			parameter[55]
#define CB_8_strain_name	parameter[56]
#define CB_8_g_max_CB		parameter[57]
#define CB_8_k_CB_P			parameter[58]
#define CB_8_h_SR_CB		parameter[59]
#define CB_8_y_P_CB			parameter[60]
#define CB_8_Pr_CB			parameter[61]
#define CB_8_m_CB			parameter[62]
#define CB_8_i_CB			parameter[63]
#define CB_9_strain_name	parameter[64]
#define CB_9_g_max_CB		parameter[65]
#define CB_9_k_CB_P			parameter[66]
#define CB_9_h_SR_CB		parameter[67]
#define CB_9_y_P_CB			parameter[68]
#define CB_9_Pr_CB			parameter[69]
#define CB_9_m_CB			parameter[70]
#define CB_9_i_CB			parameter[71]

const double y_P_CB[9]  = {CB_1_y_P_CB, CB_2_y_P_CB, CB_3_y_P_CB, CB_4_y_P_CB, CB_5_y_P_CB,
													CB_6_y_P_CB, CB_7_y_P_CB, CB_8_y_P_CB, CB_9_y_P_CB};
const double Pr_CB[9]  = {CB_1_Pr_CB, CB_2_Pr_CB, CB_3_Pr_CB, CB_4_Pr_CB, CB_5_Pr_CB,
													CB_6_Pr_CB, CB_7_Pr_CB, CB_8_Pr_CB, CB_9_Pr_CB};


// Define PB strain parameter
// cat(paste0(paste0("#define PB_", rep(1:9, each = 9)), "_", names(x$strain_parameter$PB),  "			parameter[", (1:81) + 71, "]", collapse = "\n"))
#define PB_1_strain_name	parameter[72]
#define PB_1_g_max_PB		parameter[73]
#define PB_1_k_PB_SR		parameter[74]
#define PB_1_k_PB_P			parameter[75]
#define PB_1_h_O_PB			parameter[76]
#define PB_1_y_SO_SB		parameter[77]
#define PB_1_y_P_PB			parameter[78]
#define PB_1_m_PB			parameter[79]
#define PB_1_i_PB			parameter[80]
#define PB_2_strain_name	parameter[81]
#define PB_2_g_max_PB		parameter[82]
#define PB_2_k_PB_SR		parameter[83]
#define PB_2_k_PB_P			parameter[84]
#define PB_2_h_O_PB			parameter[85]
#define PB_2_y_SO_SB		parameter[86]
#define PB_2_y_P_PB			parameter[87]
#define PB_2_m_PB			parameter[88]
#define PB_2_i_PB			parameter[89]
#define PB_3_strain_name	parameter[90]
#define PB_3_g_max_PB		parameter[91]
#define PB_3_k_PB_SR		parameter[92]
#define PB_3_k_PB_P			parameter[93]
#define PB_3_h_O_PB			parameter[94]
#define PB_3_y_SO_SB		parameter[95]
#define PB_3_y_P_PB			parameter[96]
#define PB_3_m_PB			parameter[97]
#define PB_3_i_PB			parameter[98]
#define PB_4_strain_name	parameter[99]
#define PB_4_g_max_PB		parameter[100]
#define PB_4_k_PB_SR		parameter[101]
#define PB_4_k_PB_P			parameter[102]
#define PB_4_h_O_PB			parameter[103]
#define PB_4_y_SO_SB		parameter[104]
#define PB_4_y_P_PB			parameter[105]
#define PB_4_m_PB			parameter[106]
#define PB_4_i_PB			parameter[107]
#define PB_5_strain_name	parameter[108]
#define PB_5_g_max_PB		parameter[109]
#define PB_5_k_PB_SR		parameter[110]
#define PB_5_k_PB_P			parameter[111]
#define PB_5_h_O_PB			parameter[112]
#define PB_5_y_SO_SB		parameter[113]
#define PB_5_y_P_PB			parameter[114]
#define PB_5_m_PB			parameter[115]
#define PB_5_i_PB			parameter[116]
#define PB_6_strain_name	parameter[117]
#define PB_6_g_max_PB		parameter[118]
#define PB_6_k_PB_SR		parameter[119]
#define PB_6_k_PB_P			parameter[120]
#define PB_6_h_O_PB			parameter[121]
#define PB_6_y_SO_SB		parameter[122]
#define PB_6_y_P_PB			parameter[123]
#define PB_6_m_PB			parameter[124]
#define PB_6_i_PB			parameter[125]
#define PB_7_strain_name	parameter[126]
#define PB_7_g_max_PB		parameter[127]
#define PB_7_k_PB_SR		parameter[128]
#define PB_7_k_PB_P			parameter[129]
#define PB_7_h_O_PB			parameter[130]
#define PB_7_y_SO_SB		parameter[131]
#define PB_7_y_P_PB			parameter[132]
#define PB_7_m_PB			parameter[133]
#define PB_7_i_PB			parameter[134]
#define PB_8_strain_name	parameter[135]
#define PB_8_g_max_PB		parameter[136]
#define PB_8_k_PB_SR		parameter[137]
#define PB_8_k_PB_P			parameter[138]
#define PB_8_h_O_PB			parameter[139]
#define PB_8_y_SO_SB		parameter[140]
#define PB_8_y_P_PB			parameter[141]
#define PB_8_m_PB			parameter[142]
#define PB_8_i_PB			parameter[143]
#define PB_9_strain_name	parameter[144]
#define PB_9_g_max_PB		parameter[145]
#define PB_9_k_PB_SR		parameter[146]
#define PB_9_k_PB_P			parameter[147]
#define PB_9_h_O_PB			parameter[148]
#define PB_9_y_SO_SB		parameter[149]
#define PB_9_y_P_PB			parameter[150]
#define PB_9_m_PB			parameter[151]
#define PB_9_i_PB			parameter[152]

const double PB_y_SO_SB[9] = {PB_1_y_SO_SB, PB_2_y_SO_SB, PB_3_y_SO_SB, PB_4_y_SO_SB, PB_5_y_SO_SB,
													PB_6_y_SO_SB, PB_7_y_SO_SB, PB_8_y_SO_SB, PB_9_y_SO_SB};
const double y_P_PB[9]  = {PB_1_y_P_PB, PB_2_y_P_PB, PB_3_y_P_PB, PB_4_y_P_PB, PB_5_y_P_PB,
													PB_6_y_P_PB, PB_7_y_P_PB, PB_8_y_P_PB, PB_9_y_P_PB};
													
// Define SB strain parameter
// cat(paste0(paste0("#define SB_", rep(1:9, each = 9)), "_", names(x$strain_parameter$SB),  "			parameter[", (1:81) + 152, "]", collapse = "\n"))
#define SB_1_strain_name	parameter[153]
#define SB_1_g_max_SB		parameter[154]
#define SB_1_k_SB_SO		parameter[155]
#define SB_1_k_SB_P			parameter[156]
#define SB_1_h_O_SB			parameter[157]
#define SB_1_y_SO_SB		parameter[158]
#define SB_1_y_P_SB			parameter[159]
#define SB_1_m_SB			parameter[160]
#define SB_1_i_SB			parameter[161]
#define SB_2_strain_name	parameter[162]
#define SB_2_g_max_SB		parameter[163]
#define SB_2_k_SB_SO		parameter[164]
#define SB_2_k_SB_P			parameter[165]
#define SB_2_h_O_SB			parameter[166]
#define SB_2_y_SO_SB		parameter[167]
#define SB_2_y_P_SB			parameter[168]
#define SB_2_m_SB			parameter[169]
#define SB_2_i_SB			parameter[170]
#define SB_3_strain_name	parameter[171]
#define SB_3_g_max_SB		parameter[172]
#define SB_3_k_SB_SO		parameter[173]
#define SB_3_k_SB_P			parameter[174]
#define SB_3_h_O_SB			parameter[175]
#define SB_3_y_SO_SB		parameter[176]
#define SB_3_y_P_SB			parameter[177]
#define SB_3_m_SB			parameter[178]
#define SB_3_i_SB			parameter[179]
#define SB_4_strain_name	parameter[180]
#define SB_4_g_max_SB		parameter[181]
#define SB_4_k_SB_SO		parameter[182]
#define SB_4_k_SB_P			parameter[183]
#define SB_4_h_O_SB			parameter[184]
#define SB_4_y_SO_SB		parameter[185]
#define SB_4_y_P_SB			parameter[186]
#define SB_4_m_SB			parameter[187]
#define SB_4_i_SB			parameter[188]
#define SB_5_strain_name	parameter[189]
#define SB_5_g_max_SB		parameter[190]
#define SB_5_k_SB_SO		parameter[191]
#define SB_5_k_SB_P			parameter[192]
#define SB_5_h_O_SB			parameter[193]
#define SB_5_y_SO_SB		parameter[194]
#define SB_5_y_P_SB			parameter[195]
#define SB_5_m_SB			parameter[196]
#define SB_5_i_SB			parameter[197]
#define SB_6_strain_name	parameter[198]
#define SB_6_g_max_SB		parameter[199]
#define SB_6_k_SB_SO		parameter[200]
#define SB_6_k_SB_P			parameter[201]
#define SB_6_h_O_SB			parameter[202]
#define SB_6_y_SO_SB		parameter[203]
#define SB_6_y_P_SB			parameter[204]
#define SB_6_m_SB			parameter[205]
#define SB_6_i_SB			parameter[206]
#define SB_7_strain_name	parameter[207]
#define SB_7_g_max_SB		parameter[208]
#define SB_7_k_SB_SO		parameter[209]
#define SB_7_k_SB_P			parameter[210]
#define SB_7_h_O_SB			parameter[211]
#define SB_7_y_SO_SB		parameter[212]
#define SB_7_y_P_SB			parameter[213]
#define SB_7_m_SB			parameter[214]
#define SB_7_i_SB			parameter[215]
#define SB_8_strain_name	parameter[216]
#define SB_8_g_max_SB		parameter[217]
#define SB_8_k_SB_SO		parameter[218]
#define SB_8_k_SB_P			parameter[219]
#define SB_8_h_O_SB			parameter[220]
#define SB_8_y_SO_SB		parameter[221]
#define SB_8_y_P_SB			parameter[222]
#define SB_8_m_SB			parameter[223]
#define SB_8_i_SB			parameter[224]
#define SB_9_strain_name	parameter[225]
#define SB_9_g_max_SB		parameter[226]
#define SB_9_k_SB_SO		parameter[227]
#define SB_9_k_SB_P			parameter[228]
#define SB_9_h_O_SB			parameter[229]
#define SB_9_y_SO_SB		parameter[230]
#define SB_9_y_P_SB			parameter[231]
#define SB_9_m_SB			parameter[232]
#define SB_9_i_SB			parameter[233]

const double SB_y_SO_SB[9] = {SB_1_y_SO_SB, SB_2_y_SO_SB, SB_3_y_SO_SB, SB_4_y_SO_SB, SB_5_y_SO_SB,
													SB_6_y_SO_SB, SB_7_y_SO_SB, SB_8_y_SO_SB, SB_9_y_SO_SB};
const double y_P_SB[9]  = {SB_1_y_P_SB, SB_2_y_P_SB, SB_3_y_P_SB, SB_4_y_P_SB, SB_5_y_P_SB,
													SB_6_y_P_SB, SB_7_y_P_SB, SB_8_y_P_SB, SB_9_y_P_SB};
// general strain parameter
#define a_S            			parameter[234]
#define a_O            			parameter[235]
#define a_P            			parameter[236]
#define back_SR        			parameter[237]
#define back_SO        			parameter[238]
#define back_O         			parameter[239]
#define back_P         			parameter[240]
#define c              			parameter[241]


// additional parameter
// #define noise_sigma    			parameter[242]
// #define minimum_abundances_CB	parameter[243]
// #define minimum_abundances_PB   parameter[244]
// #define minimum_abundances_SB   parameter[245]



/*
 *=====================================================================================================
 *  DEFINITION OF THE SYSTEM OF EQUATIONS TO SOLVE
 *=====================================================================================================
 */


/*====================================================================================================*/

// growth1()
// Growth rate function on one resource X 
//
// x Concentration of resource X
// g_max Maximum growth rate
// k_x Half saturation constant for resource X
//
// return Growth rate

double Growth1(double x, double g_max, double k_x)
{
	double growth_rate;
	growth_rate = g_max * ( x / (k_x + x) );
	return growth_rate;
}


/*====================================================================================================*/

// growth2()
// Growth rate function on two resources X and Y
//
// x Concentration of resource X
// y Concentration of resource Y
// g_max Maximum growth rate
// k_x Half saturation constant for resource X
// k_y Half saturation constant for resource Y
//
// return Growth rate

double Growth2(double x, double y, double g_max, double k_x, double k_y)
{
	double growth_rate;
	growth_rate = g_max * ( x / (k_x + x) ) * ( x / (k_x + x));
	return growth_rate;
}


/*====================================================================================================*/
// inhibition()
// Growth inhibition function
//
// x Concentration of substance X
// h_x Concentration of substance X at which the inhibition factor is 0.5 (i.e. the concerned rate is halved)
//
// return Inhibition factor

double Inhibition(double x, double h_x)
{
	double inhibition_factor;
  	inhibition_factor = 1 / (1 + (x / h_x));
  	return inhibition_factor;
}



/*====================================================================================================*/
// bushplus_dynamic_model()
//
// The rate equations, as published in the Bush et al 2017 paper, but with
// forcing of oxygen diffusivity `a_0` potential added, and the
// possibility to simulate multiple strains per functional group
//
// t The current time in the simulation state A vector containing the current (named) values of 
//		each state variable
//  parameters An object of class `runsim_parameter` as returned by `new_runsim_parameter()``
//   
// return An objec of type `runsim_result` containing the parameter and
//   the results of the simulation, namely the rate of change of each state
//   variable, and also the current values of oxygen diffusivity.

void Bushplus_dynamic_model(double t, double *state, double *parameters) {

  double CB_growth_rate[9];
  double CB_mortality_rate[9];

  double PB_growth_rate[9];
  double PB_mortality_rate[9];

  double SB_growth_rate[9];
  double SB_mortality_rate[9];

  double sum1;
  int i;

  //  CB <- state[grep("CB", names(state))]
  //  names_CB <- names(CB)[order(names(CB))]
  //  CB <- as.numeric(CB[order(names(CB))])
  //
  //  PB <- state[grep("PB", names(state))]
  //  names_PB <- names(PB)[order(names(PB))]
  //  PB <- as.numeric(PB[order(names(PB))])
  //
  //  SB <- state[grep("SB", names(state))]
  //  names_SB <- names(SB)[order(names(SB))]
  //  SB <- as.numeric(SB[order(names(SB))])
  //
  //  # print(c(CB, PB, SB))
  //
  //

  //  rates of change=
  // CB_growth_rate <- Growth1(state["P"], parameters$CB$g_max_CB,
  // parameters$CB$k_CB_P) * inhibition(state["SR"], parameters$CB$h_SR_CB) * CB
  CB_growth_rate[0] = Growth1(P, CB_1_g_max_CB, CB_1_k_CB_P) *
                      Inhibition(SR, CB_1_h_SR_CB) * CB_1;
  CB_growth_rate[1] = Growth1(P, CB_2_g_max_CB, CB_2_k_CB_P) *
                      Inhibition(SR, CB_2_h_SR_CB) * CB_2;
  CB_growth_rate[2] = Growth1(P, CB_3_g_max_CB, CB_3_k_CB_P) *
                      Inhibition(SR, CB_3_h_SR_CB) * CB_3;
  CB_growth_rate[3] = Growth1(P, CB_4_g_max_CB, CB_4_k_CB_P) *
                      Inhibition(SR, CB_4_h_SR_CB) * CB_4;
  CB_growth_rate[4] = Growth1(P, CB_5_g_max_CB, CB_5_k_CB_P) *
                      Inhibition(SR, CB_5_h_SR_CB) * CB_5;
  CB_growth_rate[5] = Growth1(P, CB_6_g_max_CB, CB_6_k_CB_P) *
                      Inhibition(SR, CB_6_h_SR_CB) * CB_6;
  CB_growth_rate[6] = Growth1(P, CB_7_g_max_CB, CB_7_k_CB_P) *
                      Inhibition(SR, CB_7_h_SR_CB) * CB_7;
  CB_growth_rate[7] = Growth1(P, CB_8_g_max_CB, CB_9_k_CB_P) *
                      Inhibition(SR, CB_8_h_SR_CB) * CB_8;
  CB_growth_rate[8] = Growth1(P, CB_9_g_max_CB, CB_1_k_CB_P) *
                      Inhibition(SR, CB_9_h_SR_CB) * CB_9;

  // 	CB_mortality_rate <- parameters$CB$m_CB * CB
  CB_mortality_rate[0] = CB_1_m_CB * CB_1;
  CB_mortality_rate[1] = CB_2_m_CB * CB_2;
  CB_mortality_rate[2] = CB_3_m_CB * CB_3;
  CB_mortality_rate[3] = CB_4_m_CB * CB_4;
  CB_mortality_rate[4] = CB_5_m_CB * CB_5;
  CB_mortality_rate[5] = CB_6_m_CB * CB_6;
  CB_mortality_rate[6] = CB_7_m_CB * CB_7;
  CB_mortality_rate[7] = CB_8_m_CB * CB_8;
  CB_mortality_rate[8] = CB_9_m_CB * CB_9;

  //	CB_rate <- CB_growth_rate - CB_mortality_rate + parameters$CB$i_CB
  CB_1_rate = CB_growth_rate[0] - CB_mortality_rate[0] + CB_1_i_CB;
  CB_2_rate = CB_growth_rate[1] - CB_mortality_rate[1] + CB_2_i_CB;
  CB_3_rate = CB_growth_rate[2] - CB_mortality_rate[2] + CB_3_i_CB;
  CB_4_rate = CB_growth_rate[3] - CB_mortality_rate[3] + CB_4_i_CB;
  CB_5_rate = CB_growth_rate[4] - CB_mortality_rate[4] + CB_5_i_CB;
  CB_6_rate = CB_growth_rate[5] - CB_mortality_rate[5] + CB_6_i_CB;
  CB_7_rate = CB_growth_rate[6] - CB_mortality_rate[6] + CB_7_i_CB;
  CB_8_rate = CB_growth_rate[7] - CB_mortality_rate[7] + CB_8_i_CB;
  CB_9_rate = CB_growth_rate[8] - CB_mortality_rate[8] + CB_9_i_CB;

  //	PB_growth_rate <- growth2(state["P"], state["SR"],
  //parameters$PB$g_max_PB, parameters$PB$k_PB_P, parameters$PB$k_PB_SR) *
  //inhibition(state["O"], parameters$PB$h_O_PB) * PB
  PB_growth_rate[0] = Growth2(P, SR, PB_1_g_max_PB, PB_1_k_PB_P, PB_1_k_PB_SR) *
                      Inhibition(O, PB_1_h_O_PB) * PB_1;
  PB_growth_rate[1] = Growth2(P, SR, PB_2_g_max_PB, PB_2_k_PB_P, PB_2_k_PB_SR) *
                      Inhibition(O, PB_2_h_O_PB) * PB_2;
  PB_growth_rate[2] = Growth2(P, SR, PB_3_g_max_PB, PB_3_k_PB_P, PB_3_k_PB_SR) *
                      Inhibition(O, PB_3_h_O_PB) * PB_3;
  PB_growth_rate[3] = Growth2(P, SR, PB_4_g_max_PB, PB_4_k_PB_P, PB_4_k_PB_SR) *
                      Inhibition(O, PB_4_h_O_PB) * PB_4;
  PB_growth_rate[4] = Growth2(P, SR, PB_5_g_max_PB, PB_5_k_PB_P, PB_5_k_PB_SR) *
                      Inhibition(O, PB_5_h_O_PB) * PB_5;
  PB_growth_rate[5] = Growth2(P, SR, PB_6_g_max_PB, PB_6_k_PB_P, PB_6_k_PB_SR) *
                      Inhibition(O, PB_6_h_O_PB) * PB_6;
  PB_growth_rate[6] = Growth2(P, SR, PB_7_g_max_PB, PB_7_k_PB_P, PB_7_k_PB_SR) *
                      Inhibition(O, PB_7_h_O_PB) * PB_7;
  PB_growth_rate[7] = Growth2(P, SR, PB_8_g_max_PB, PB_8_k_PB_P, PB_8_k_PB_SR) *
                      Inhibition(O, PB_8_h_O_PB) * PB_8;
  PB_growth_rate[8] = Growth2(P, SR, PB_9_g_max_PB, PB_9_k_PB_P, PB_9_k_PB_SR) *
                      Inhibition(O, PB_9_h_O_PB) * PB_9;

  // PB_mortality_rate <- parameters$PB$m_PB * PB
  PB_mortality_rate[0] = PB_1_m_PB * PB_1;
  PB_mortality_rate[1] = PB_2_m_PB * PB_2;
  PB_mortality_rate[2] = PB_3_m_PB * PB_3;
  PB_mortality_rate[3] = PB_4_m_PB * PB_4;
  PB_mortality_rate[4] = PB_5_m_PB * PB_5;
  PB_mortality_rate[5] = PB_6_m_PB * PB_6;
  PB_mortality_rate[6] = PB_7_m_PB * PB_7;
  PB_mortality_rate[7] = PB_8_m_PB * PB_8;
  PB_mortality_rate[8] = PB_9_m_PB * PB_9;

  // PB_rate <- PB_growth_rate - PB_mortality_rate + parameters$PB$i_PB
  PB_1_rate = PB_growth_rate[0] - PB_mortality_rate[0] + PB_1_i_PB;
  PB_2_rate = PB_growth_rate[1] - PB_mortality_rate[1] + PB_2_i_PB;
  PB_3_rate = PB_growth_rate[2] - PB_mortality_rate[2] + PB_3_i_PB;
  PB_4_rate = PB_growth_rate[3] - PB_mortality_rate[3] + PB_4_i_PB;
  PB_5_rate = PB_growth_rate[4] - PB_mortality_rate[4] + PB_5_i_PB;
  PB_6_rate = PB_growth_rate[5] - PB_mortality_rate[5] + PB_6_i_PB;
  PB_7_rate = PB_growth_rate[6] - PB_mortality_rate[6] + PB_7_i_PB;
  PB_8_rate = PB_growth_rate[7] - PB_mortality_rate[7] + PB_8_i_PB;
  PB_9_rate = PB_growth_rate[8] - PB_mortality_rate[8] + PB_9_i_PB;

  // SB_growth_rate <- growth2(state["P"], state["SO"], parameters$SB$g_max_SB,
  // parameters$SB$k_SB_P, parameters$SB$k_SB_SO) * inhibition(state["O"],
  // parameters$SB$h_O_SB) * SB
  SB_growth_rate[0] = Growth2(P, SO, SB_1_g_max_SB, SB_1_k_SB_P, SB_1_k_SB_SO) *
                      Inhibition(O, SB_1_h_O_SB) * SB_1;
  SB_growth_rate[1] = Growth2(P, SO, SB_2_g_max_SB, SB_2_k_SB_P, SB_2_k_SB_SO) *
                      Inhibition(O, SB_2_h_O_SB) * SB_2;
  SB_growth_rate[2] = Growth2(P, SO, SB_3_g_max_SB, SB_3_k_SB_P, SB_3_k_SB_SO) *
                      Inhibition(O, SB_3_h_O_SB) * SB_3;
  SB_growth_rate[3] = Growth2(P, SO, SB_4_g_max_SB, SB_4_k_SB_P, SB_4_k_SB_SO) *
                      Inhibition(O, SB_4_h_O_SB) * SB_4;
  SB_growth_rate[4] = Growth2(P, SO, SB_5_g_max_SB, SB_5_k_SB_P, SB_5_k_SB_SO) *
                      Inhibition(O, SB_5_h_O_SB) * SB_5;
  SB_growth_rate[5] = Growth2(P, SO, SB_6_g_max_SB, SB_6_k_SB_P, SB_6_k_SB_SO) *
                      Inhibition(O, SB_6_h_O_SB) * SB_6;
  SB_growth_rate[6] = Growth2(P, SO, SB_7_g_max_SB, SB_7_k_SB_P, SB_7_k_SB_SO) *
                      Inhibition(O, SB_7_h_O_SB) * SB_7;
  SB_growth_rate[7] = Growth2(P, SO, SB_8_g_max_SB, SB_8_k_SB_P, SB_8_k_SB_SO) *
                      Inhibition(O, SB_8_h_O_SB) * SB_8;
  SB_growth_rate[8] = Growth2(P, SO, SB_9_g_max_SB, SB_9_k_SB_P, SB_9_k_SB_SO) *
                      Inhibition(O, SB_9_h_O_SB) * SB_9;

  // SB_mortality_rate <- parameters$SB$m_SB * SB
  SB_mortality_rate[0] = SB_1_m_SB * SB_1;
  SB_mortality_rate[1] = SB_2_m_SB * SB_2;
  SB_mortality_rate[2] = SB_3_m_SB * SB_3;
  SB_mortality_rate[3] = SB_4_m_SB * SB_4;
  SB_mortality_rate[4] = SB_5_m_SB * SB_5;
  SB_mortality_rate[5] = SB_6_m_SB * SB_6;
  SB_mortality_rate[6] = SB_7_m_SB * SB_7;
  SB_mortality_rate[7] = SB_8_m_SB * SB_8;
  SB_mortality_rate[8] = SB_9_m_SB * SB_9;

  // SB_rate <- SB_growth_rate - SB_mortality_rate + parameters$SB$i_SB
  SB_1_rate = SB_growth_rate[0] - SB_mortality_rate[0] + SB_1_i_SB;
  SB_2_rate = SB_growth_rate[1] - SB_mortality_rate[1] + SB_2_i_SB;
  SB_3_rate = SB_growth_rate[2] - SB_mortality_rate[2] + SB_3_i_SB;
  SB_4_rate = SB_growth_rate[3] - SB_mortality_rate[3] + SB_4_i_SB;
  SB_5_rate = SB_growth_rate[4] - SB_mortality_rate[4] + SB_5_i_SB;
  SB_6_rate = SB_growth_rate[5] - SB_mortality_rate[5] + SB_6_i_SB;
  SB_7_rate = SB_growth_rate[6] - SB_mortality_rate[6] + SB_7_i_SB;
  SB_8_rate = SB_growth_rate[7] - SB_mortality_rate[7] + SB_8_i_SB;
  SB_9_rate = SB_growth_rate[8] - SB_mortality_rate[8] + SB_9_i_SB;

  // SO_rate <- sum(1 / parameters$PB$y_SO_SB * PB_growth_rate) -
  //            sum(1 / parameters$SB$y_SO_SB * SB_growth_rate) +
  // 					 parameters$c * state["O"] * state["SR"]
  // + 					 parameters$a_S * (parameters$back_SO -state[["SO"]])
  sum1 = 0;
  for (i = 8; i >= 0; i--) {
    sum1 = sum1 + (1 / PB_y_SO_SB[i] * PB_growth_rate[i]) -
           (1 / SB_y_SO_SB[i] * SB_growth_rate[i]);
  }

  SO_rate = sum1 + c * O * SR + a_S * (back_SO - SO);

  // SR_rate <- - sum(1 / parameters$PB$y_SO_SB * PB_growth_rate) +
  //            sum(1 / parameters$SB$y_SO_SB * SB_growth_rate) -
  // 					 parameters$c * state["O"] * state["SR"]
  // + 					 parameters$a_S * (parameters$back_SR - state["SR"])
  sum1 = 0;
  for (i = 8; i >= 0; i--) {
    sum1 = sum1 + (1 / PB_y_SO_SB[i] * PB_growth_rate[i]) +
           (1 / SB_y_SO_SB[i] * SB_growth_rate[i]);
  }

  SR_rate = sum1 + c * O * SR + a_S * (back_SR - SR);

  // O_rate <- sum(parameters$CB$Pr_CB * CB_growth_rate) -
  // 					parameters$c * state["O"] * state["SR"]
  // +
  //           10^log10a_forcing_func(t) * (parameters$back_O - state["O"])
  sum1 = 0;
  for (i = 8; i >= 0; i--) {
    sum1 = sum1 + (Pr_CB[i] * CB_growth_rate[i]);
  }
  O_rate = sum1 + back_O * O;

  // P_rate <- - sum(1 / parameters$CB$y_P_CB * CB_growth_rate) -
  //           sum(1 / parameters$PB$y_P_PB * PB_growth_rate) -
  //           sum(1 / parameters$SB$y_P_SB * PB_growth_rate) +
  // 					parameters$a_P * (parameters$back_P -
  // state["P"])
  sum1 = 0;
  for (i = 8; i >= 0; i--) {
    sum1 = sum1 + (1 / y_P_CB[i] * CB_growth_rate[i]) -
           (1 / y_P_PB[i] * PB_growth_rate[i]) -
           (1 / y_P_SB[i] * PB_growth_rate[i]);
  }
  P_rate = sum1 + a_P * (back_P - P);

  //  # print(CB_growth_rate)
  //  # print(CB_mortality_rate)
  //  # print(parameters$CB$m_CB)
  //  # print(CB)
  //  # print(CB_rate)

  // # return the rate of change
  // result <- list(c(CB_rate,
  // 								PB_rate,
  // 								SB_rate,
  // 								SO_rate =
  // SO_rate, 								SR_rate = SR_rate,
  // O_rate = O_rate, 								P_rate
  // =
  // P_rate), 							a=log10a_forcing_func(t)) names(result[[1]])
  // <- c(parameters$CB$strain_name,
  // parameters$PB$strain_name, 									parameters$SB$strain_name, 											 "SO_rate", 											 "SR_rate",
  // 											 "O_rate",
  // 											 "P_rate")
  // result
  return;
}

/*====================================================================================================*/
/*====================================================================================================*/
/*====================================================================================================*/
/*========= TO BE ADAPTED ============================================================================*/
/*====================================================================================================*/
/*====================================================================================================*/
/*====================================================================================================*/



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
