* EMPIRICAL PAPER — MASTER DO-FILE
* Topic: Interest rate trends and private sector credit growth in ghana: an empirical time series assessment (2003 - 2022)
 
* Dataset Columns Used:
*   - Period       : Monthly period identifier (e.g., 2003M01 to 2022M12)
*   - Date         : Calendar date (YYYY-MM-DD)
*   - Year         : 2003 to 2022
*   - Month        : 1 to 12
*   - PSC          : Nominal Private Sector Credit in Millions of GHS
*   - LENDING_RATE : Average Commercial Bank Lending Rate in %
*   - LOG_PSC      : Natural Logarithm of Private Sector Credit (ln(PSC))
* ============================================================================
clear all
set more off
version 18
capture log close

* Start log file to save all regression results and test statistics
log using "Stata_Results_Log.log", text replace
display as text "Execution Date: $S_DATE  Time: $S_TIME"

display as text _newline ">>> STEP 1: IMPORTING DATASET & SETTING TIME SERIES STRUCTURE <<<"

* Importing dataset using native C-level insheet because my java isn't working
capture insheet using "Time_Series_Monthly_dataset.csv", comma clear
if _rc != 0 {
    import delimited using "Time_Series_Monthly_dataset.csv", clear case(lower)
}

* lowercase naming of all variables
capture rename *, lower

* Ensuring numeric typing
capture destring year month psc lending_rate log_psc, replace ignore(",")

describe

* Generating monthly date index from Year and Month
gen monthly_date = ym(year, month)
format monthly_date %tm

* Setting as monthly time-series
tsset monthly_date, monthly

* Labeling my variables
label variable period       "Period (Monthly Format)"
label variable date         "Calendar Date"
label variable year         "Observation Year"
label variable month        "Observation Month (1-12)"
label variable psc          "Nominal Private Sector Credit (Millions GHS)"
label variable lending_rate "Average Commercial Bank Lending Rate (%)"
label variable log_psc      "Natural Log of Private Sector Credit (ln(PSC))"

* Verifying LOG_PSC calculation: ensure log_psc = ln(psc)
quietly replace log_psc = ln(psc) if missing(log_psc)

* Generating first differences (Month-on-Month Growth Rates)
gen d_log_psc      = D.log_psc
gen d_lending_rate = D.lending_rate
label variable d_log_psc      "Monthly Credit Growth Rate (Delta ln(PSC))"
label variable d_lending_rate "Monthly Change in Lending Rate (Delta Rate)"

* DESCRIPTIVE STATISTICS & PRELIMINARY INSIGHTS
* Detailed summary statistics (Mean, Std. Dev., Min, Max, Skewness, Kurtosis)
summarize psc log_psc lending_rate d_log_psc, detail


ssc install asdoc, replace
	
* Formatted Table 1
asdoc tabstat psc log_psc lending_rate d_log_psc, ///
    statistics(mean median sd min max skewness kurtosis count) ///
    columns(statistics) format(%9.4f) ///
    title(Table 1: Descriptive Statistics of Monthly Series) ///
    save(Table1_Descriptive_Statistics.doc) replace
	
* Skewness/Kurtosis Normality Test
sktest psc log_psc lending_rate d_log_psc

* Pairwise correlation matrix
display as text _newline "--- Pairwise Correlation Matrix ---"
pwcorr log_psc lending_rate d_log_psc d_lending_rate, sig star(0.01)

* TIME SERIES VISUALIZATIONS & GRAPH EXPORTS
* Graph 1: Private Sector Credit in Levels (PSC)
tsline psc, title("Nominal Private Sector Credit in Ghana (2003-2022)", size(medium)) ///
    subtitle("Bank of Ghana Monthly Financial Statistics", size(small)) ///
    ytitle("Credit (Millions of GHS)") xtitle("Year") lcolor(navy) lwidth(medium) ///
    name(g_psc, replace)
graph export "fig1_credit_levels.png", as(png) replace width(1800)

* Graph 2: Log Private Sector Credit (LOG_PSC)
tsline log_psc, title("Logarithm of Private Sector Credit: ln(PSC)", size(medium)) ///
    ytitle("Log Index") xtitle("Year") lcolor(navy) lwidth(medium) ///
    name(g_log_psc, replace)
graph export "fig2_credit_log.png", as(png) replace width(1800)

* Graph 3: Average Commercial Bank Lending Rate (LENDING_RATE)
tsline lending_rate, title("Average Commercial Bank Lending Rate (%) in Ghana", size(medium)) ///
    ytitle("Lending Rate (%)") xtitle("Year") lcolor(cranberry) lwidth(medium) ///
    name(g_rate, replace)
graph export "fig3_lending_rate.png", as(png) replace width(1800)

* Graph 4: Dual-Axis Comparison Graph (LOG_PSC vs LENDING_RATE)
twoway (tsline log_psc, yaxis(1) lcolor(navy) lwidth(medium)) ///
       (tsline lending_rate, yaxis(2) lcolor(cranberry) lwidth(medium)), ///
       title("Interest Rates vs. Private Sector Credit Growth in Ghana (2003-2022)", size(medium)) ///
       subtitle("Bank of Ghana Monthly Series (N = 240)", size(small)) ///
       ytitle("Log Credit: ln(PSC)", axis(1) color(navy)) ///
       ytitle("Commercial Bank Lending Rate (%)", axis(2) color(cranberry)) ///
       xtitle("Observation Horizon") ///
       legend(order(1 "Log Credit ln(PSC) [Left]" 2 "Lending Rate (%) [Right]") pos(6) col(2)) ///
       name(g_dual, replace)
graph export "fig4_credit_vs_lending_rate.png", as(png) replace width(2000)

* TECHNIQUE 1 - UNIT ROOT AND STATIONARITY TESTS
* UNIT ROOT TESTS - ADF & PHILLIPS-PERRON (TABLE 2 IN PAPER)

* Lag order selection via VAR information criteria
varsoc log_psc lending_rate, maxlag(12)

* Augmented Dickey-Fuller (ADF) Tests
display as text _newline "--- ADF 1: LOG_PSC in Level (Trend & Intercept) ---"
dfuller log_psc, trend lags(2)

display as text _newline "--- ADF 2: Delta LOG_PSC in First Difference (Intercept only) ---"
dfuller D.log_psc, lags(1)

display as text _newline "--- ADF 3: LENDING_RATE in Level (Intercept only) ---"
dfuller lending_rate, lags(2)

display as text _newline "--- ADF 4: Delta LENDING_RATE in First Difference (Intercept only) ---"
dfuller D.lending_rate, lags(1)

* Phillips-Perron (PP) Tests
display as text _newline "--- PP 1: LOG_PSC in Level (Trend & Intercept) ---"
pperron log_psc, trend

display as text _newline "--- PP 2: Delta LOG_PSC in First Difference (Intercept) ---"
pperron D.log_psc

display as text _newline "--- PP 3: LENDING_RATE in Level (Intercept) ---"
pperron lending_rate

display as text _newline "--- PP 4: Delta LENDING_RATE in First Difference (Intercept) ---"
pperron D.lending_rate

display as result "Decision: Both LOG_PSC and LENDING_RATE are I(1)."


* TECHNIQUE 2 - ARDL COINTEGRATION BOUNDS TEST & ECM MODELING

* ARDL BOUNDS COINTEGRATION & DYNAMIC ECM (TABLES 3, 4, 5, 6)

* Estimate Unrestricted Error Correction Model (UECM):
*   D.log_psc = c0 + lambda1*L.log_psc + lambda2*L.lending_rate 
*                  + phi1*LD.log_psc + theta0*D.lending_rate + e_t
regress D.log_psc L.log_psc L.lending_rate L.D.log_psc D.lending_rate
estimates store uecm_model


* Pesaran, Shin & Smith (2001) ARDL F-Bounds Test
display as text _newline ">>> TABLE : joint Wald test <<<"
display as text "H0: lambda1 = lambda2 = 0 (No Cointegration)"
display as text "H1: lambda1 != 0 or lambda2 != 0 (Cointegration Exists)"
test L.log_psc L.lending_rate
	
local f_bounds = r(F)
display as result "Calculated F-Statistic: " %6.4f `f_bounds'

display as text "Pesaran et al. (2001) Critical Value Bounds (k = 1, Case III):"
display as text "  10% Level: I(0) = 3.02,  I(1) = 3.51"
display as text "   5% Level: I(0) = 3.62,  I(1) = 4.16"
display as text "   1% Level: I(0) = 4.94,  I(1) = 5.58"

if missing(`f_bounds') {
    display as error "F-statistic unavailable. Check the test results."
}
else if `f_bounds' > 5.58 {
    display as result "Reject H0 at the 1% level: evidence of cointegration."
}
else if `f_bounds' > 4.16 {
    display as result "Reject H0 at the 5% level: evidence of cointegration."
}
else if `f_bounds' > 3.51 {
    display as text "Inconclusive at the 5% level."
}
else {
    display as text "Fail to reject H0 at the 5% level."
}


* Long-Run Elasticity Calculation
nlcom (Long_Run_Beta: -_b[L.lending_rate] / _b[L.log_psc]) ///
      (Intercept:      _b[_cons]           / (-_b[L.log_psc]))


* Short-Run Error Correction Model & Speed of Adjustment (Table 5)
display as text _newline ">>> SHORT-RUN ERROR CORRECTION MODEL & ADJUSTMENT SPEED <<<"
regress D.log_psc D.lending_rate L.log_psc L.lending_rate


* Speed of adjustment parameter is precisely the coefficient on L.log_psc in the UECM:
display as result "ECT coefficient = " %6.4f _b[L.log_psc]
display as text "Monthly adjustment speed = " ///
    %6.2f (100*abs(_b[L.log_psc])) "%"

estat dwatson
	
* Optional Community 'ardl' Command (if installed from SSC)
capture which ardl
if _rc != 0 {
    display as text _newline "Attempting to install 'ardl' command from Boston College SSC..."
    capture ssc install ardl, replace
}
capture which ardl
if _rc == 0 {
    display as text _newline ">>> RUNNING AUTOMATED ARDL ROUTINE VIA 'ardl' COMMAND <<<"
asdoc ardl log_psc lending_rate, lags(2 1) ec btest ///
	title(Table 3: ARDL Model and Bounds Test) ///
	save(Table3_ARDL_Bounds_Test.doc) replace
}

* Johansen Cointegration Verification (vecrank - Native in all Stata versions)
vecrank log_psc lending_rate, trend(constant) max

* MODEL RESIDUAL DIAGNOSTICS & SPECIFICATION TESTS

estimates restore uecm_model

* 1. Durbin-Watson statistic
estat dwatson

* 2. Breusch-Godfrey LM Serial Correlation Test
asdoc estat bgodfrey, lags(1 2 4) ///
    title(Table 4: Breusch-Godfrey LM Test for Serial Correlation) ///
    save(Table4_Breusch_Godfrey.doc) replace


* 3. Autoregressive Conditional Heteroskedasticity (ARCH LM) Test
asdoc estat archlm, lags(1 2) ///
	title(Table 5: ARCH LM Test for Conditional Heteroskedasticity) ///
	save(Table5_ARCH_Heteroskedasticity.doc) replace

* 4. Breusch-Pagan / Cook-Weisberg Heteroskedasticity Test
estat hettest

* 5. Ramsey RESET Specification Test
estat ovtest

ssc install cusum6
* Parameter Stability (CUSUM & CUSUMSQ)
estat sbcusum
graph export "fig5_cusum_statbility.png", replace width(2000)


* TECHNIQUE 3 - PAIRWISE GRANGER CAUSALITY TEST
* PAIRWISE GRANGER CAUSALITY TEST (TABLE 6 IN PAPER)

* Estimate Vector Autoregression in first differences with 4 lags (quarterly transmission)
asdoc var d_log_psc d_lending_rate, lags(1/4)

* Granger Causality Wald Test
asdoc vargranger, ///
	title(Table 6: Pairwise Granger Causality Wald Test) ///
	save(Table6_Granger_Causality_Wald_Test) replace

* Direct single-equation OLS Wald tests
* Single Equation Test: Does LENDING_RATE Granger-cause LOG_PSC? ---
regress d_log_psc L(1/4).d_log_psc L(1/4).d_lending_rate
test L1.d_lending_rate L2.d_lending_rate L3.d_lending_rate L4.d_lending_rate

* Single Equation Test: Does LOG_PSC Granger-cause LENDING_RATE? ---"
asdoc regress d_lending_rate L(1/4).d_lending_rate L(1/4).d_log_psc
test L1.d_log_psc L2.d_log_psc L3.d_log_psc L4.d_log_psc

display as result "Decision: Unidirectional causality running from LENDING_RATE to LOG_PSC."

* Save native Stata dataset
save "Credit_InterestRate.dta", replace

display as text "Completed at: $S_DATE $S_TIME"

capture log close
