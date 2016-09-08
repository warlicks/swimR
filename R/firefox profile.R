#Make this a function!

downloadPath <- "~/Documents/GitHub/swimming_app/data"

fprof <- RSelenium::makeFirefoxProfile(list(
browser.download.folderList = 2L,  
browser.download.manager.showWhenStarting = FALSE,
browser.download.dir = downloadPath,
browser.helperApps.neverAsk.openFile = "application/excel",
browser.helperApps.neverAsk.saveToDisk = "application/excel",
browser.helperApps.alwaysAsk.force = FALSE,
browser.download.manager.showAlertOnComplete = FALSE,
browser.download.manager.closeWhenDone = TRUE ))