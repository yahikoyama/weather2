# Menu Batch Script (`menu.bat`)

## Overview
This batch script provides a simple text-based menu for executing predefined data-processing tasks in the **weather2** project.  
Users can select an option to generate CSV files such as the city list or weekly heat‑stress metrics.

The script loops back to the menu after each operation, and terminates only when the user selects **99 (exit)**.

---

## Features
- Interactive menu with numeric input  
- Executes external batch files using `call`  
- Clears the screen after each operation  
- Prevents accidental termination by validating input  
- English exit message instead of the default Japanese `pause` output  

---

## Menu Options

| Number | Description                         | Output File                     |
|--------|-------------------------------------|---------------------------------|
| **0**  | Generate city list                  | `city-list.csv`                 |
| **1**  | Generate weekly heat‑stress metrics | `Weekly_HeatStress_Index.csv`   |
| **2**  | Generate comfortable region ranking | `Comfortable_Region_Finder.csv` |
| **99** | Exit the menu                       | —                               |

---

## Execution Flow

1. Display menu  
2. Wait for user input  
3. Validate input  
4. Execute the corresponding batch file  
5. Clear screen  
6. Return to menu  
7. Exit when user selects **99**

---

## Batch Logic (Simplified)

```text
Input number:
 ├─ 0 → run Select2CSV-citylist.bat
 ├─ 1 → run Weekly_HeatStress_Index.bat
 ├─ 99 → exit
 └─ other → show error and return to menu


Key Implementation Details
1. Safe Input Handling
User input is wrapped in quotes to avoid errors when the input is empty:
if "%USR_INPUT_STR%"=="0" (

This prevents the batch from terminating due to malformed IF statements.

2. Using call to Avoid Exiting the Menu
External batch files are executed with call:

call "C:\weather\db_sql2csv\Weekly_HeatStress_Index.bat"

Without call, the menu script would terminate after running the external batch.

3. English Exit Message
The default Japanese pause message is replaced with a custom English prompt:

echo Press any key to continue...
set /p dummy=

This ensures consistent English output regardless of OS language settings.

Notes
This script is intended for Windows environments.

Paths must match the directory structure of your local weather2 installation.

You can freely extend the menu by adding more numbered options and corresponding goto blocks.

Author
Maintainer: Yahikoyama  
Project: weather2 — Multi‑language meteorological data processing tools
