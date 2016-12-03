## swimR
swimR is a R package designed for working with swimming results.  Specifically it is designed to collect college swimming results from [USA Swimming's Top Times](http://www.usaswimming.org/DesktopDefault.aspx?TabId=1971&Alias=Rainbow&Lang=en) tool.  In addition swimR has basic tools to clean the returned data and store it in a SQLite database.  

The package provides a wraper around [`RSelenium`](http://ropensci.github.io/RSelenium/) to automatically collect the top times report.  Use of `RSelenium` requires a Selenium Standalone Server.  

## Installing swimR
swimR is currentl under active development and still has some issues getting the Selenium Server to run everytime.  If this dosn't scare you feel free to install.
`devtools::install_github('https://github.com/warlicks/swimming_app', ref = 'master')`
