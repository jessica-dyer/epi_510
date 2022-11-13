/*
Author: Susan Glenn
Date created: 13 November 2022
Last modified:

Purpose: Epi 510 Stata Homework 1
*/

*** 1a. Set up session *** 
clear all
set more off
cd "/Users/susanglenn/Repositories/epi_510/Stata_Assignments/Stata_HW1"

*** 1b. Import data *** 
use data/vipcls.dta

*** Review data ***

// 2a. Describe dataset
describe

// 2b. Check size of dataset
memory

// 2c. Compress dataset
compress

// 2d. Check size of dataset after compressing 
memory

// 2e. Describe dataset after compressing
describe
