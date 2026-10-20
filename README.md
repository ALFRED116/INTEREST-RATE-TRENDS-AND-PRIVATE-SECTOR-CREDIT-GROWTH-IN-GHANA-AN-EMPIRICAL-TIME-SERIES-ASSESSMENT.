# INTEREST RATE TRENDS AND PRIVATE SECTOR CREDIT GROWTH IN GHANA (2003–2022).

## Project Overview
This project examines the relationship between commercial bank lending rates and private sector credit growth in Ghana over the period January 2003 to December 2022. Using monthly time-series data, the study investigates whether changes in lending rates are associated with changes in private sector credit and whether the two variables have a long-run relationship or short-run predictive links.

The study applies econometric techniques to provide empirical evidence on the relationship between borrowing costs and private sector credit in Ghana.

## Research Objectives

The study seeks to:

1. Assess the stationarity of private sector credit and commercial bank lending rates.
2. Test for a long-run relationship between the variables.
3. Estimate the long-run association and the speed of adjustment towards equilibrium.
4. Examine whether changes in lending rates and private sector credit growth predict one another in the short run.

## Data Description

- **Country:** Ghana
- **Period:** January 2003 – December 2022
- **Frequency:** Monthly
- **Observations:** 240 in the original dataset
- **Data source:** Bank of Ghana monetary and financial statistics
- **Main variables:**
  - **Private Sector Credit (PSC):** Nominal private sector credit, measured in millions of Ghana cedis.
  - **Commercial Bank Lending Rate:** Average lending rate, measured in percentage points.
  - **Log Private Sector Credit:** Natural logarithm of nominal private sector credit.
  - **Changes in the variables:** First differences used for short-run time-series analysis.

## Methodology

The analysis uses the following econometric techniques:

1. **Augmented Dickey–Fuller (ADF) and Phillips–Perron (PP) tests** to examine stationarity.
2. **Autoregressive Distributed Lag (ARDL) bounds testing** to assess the existence of a long-run relationship.
3. **Error-correction representation** to estimate long-run associations and the speed of adjustment.
4. **Vector Autoregression (VAR) and Granger causality tests** to examine short-run predictive relationships.
5. **Diagnostic and stability tests**, including serial-correlation, heteroskedasticity and Ramsey RESET tests, to assess model adequacy.

The analysis was conducted using Stata.

## Key Findings

The results reported indicate that:

- Logged private sector credit and the commercial bank lending rate are integrated of order one, I(1).
- The ARDL bounds test reports an F-statistic of **10.882**, supporting a long-run relationship between the variables.
- The estimated long-run coefficient for the lending rate is **−0.1894**. This suggests that a one-percentage-point increase in the lending rate is associated with approximately **17.25% lower nominal private sector credit** in the long run, within the estimated model.
- The estimated error-correction coefficient is approximately **−0.0072**, indicating slow adjustment towards the long-run relationship.
- Granger causality tests do not find statistically significant short-run predictive relationships in either direction under the specified model.
- Diagnostic tests identify heteroskedasticity and possible functional-form misspecification, so the findings should be interpreted cautiously.

These results describe statistical associations and do not establish that lending-rate changes cause changes in private sector credit.

## Policy Implications

The study highlights the importance of considering borrowing costs when assessing private sector access to finance. It discusses the need to balance inflation control and macroeconomic stability with credit conditions, improve transparency in loan pricing, and strengthen credit information systems and responsible lending practices.

The findings also suggest the need for further research using additional macroeconomic controls and measures of real credit.

## Limitations

The study uses a bivariate model and does not control for other potentially important factors such as inflation, exchange rates, fiscal conditions, monetary policy rates or bank soundness. Private sector credit is measured in nominal terms and does not directly measure private investment.

The reported diagnostic results also indicate that further model checking and more robust inference are needed. The unusually sharp decline in the final monthly credit observation should be verified against the original Bank of Ghana series.

## Repository Contents

The repository is intended to contain the following project materials:

- `README.md` — Project overview, methods and findings.
- `Interest Rate Trends and Private Sector Credit Growth in Ghana.pdf` — EMPIRICAL PAPER.
- `data/` — Dataset, if permitted for redistribution.
- `scripts/` — Stata scripts used for data preparation and econometric analysis.
- `outputs/` — Tables, figures and diagnostic results.

## References

The study draws on literature concerning monetary policy transmission, bank lending, investment behaviour, credit rationing and time-series econometrics. Key references include:

- Amidu (2006), on monetary policy and bank lending behaviour in Ghana.
- Bernanke and Blinder (1988), on credit, money and aggregate demand.
- Bernanke and Gertler (1995), on the credit channel of monetary policy transmission.
- Pesaran, Shin and Smith (2001), on ARDL bounds testing.
- Stiglitz and Weiss (1981), on credit rationing under imperfect information.

Full references are provided in the empirical paper.

## Author

**Alfred Asumah Tetteh**  
Data Management and Analysis / Statistician


**Time Series Analysis** 

## Disclaimer

This project was prepared for academic purposes. The findings reflect the specified dataset, model and study period and should not be interpreted as definitive causal estimates or official policy recommendations.
