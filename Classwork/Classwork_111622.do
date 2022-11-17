cd /Users/susanglenn/Repositories/epi_510/Stata_Assignments

// creating new variable with _ instead of spaces
generate region_Lower = subinstr(lower(region), " ", "_", .)

// Create a new variable that contains the total number of under-five deaths.  
egen u5deaths = total()

// Create a variable that contains the mean under 5 mortality rate
egen meanU5mr = mean 
