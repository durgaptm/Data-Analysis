# Loading the libraries

pacman :: p_load(pacman, dplyr, GGally, ggplot2, ggthemes, ggvis, httr, lubridate,
                 plotly, rio, rmarkdown, shiny, stringr, tidyr)

# Read in the data in the csv files
filepath1 = "C:/Users/Durga P T M/Documents/R_Projects/2017-new-coder-survey-part-1.csv"
filepath2 = "C:/Users/Durga P T M/Documents/R_Projects/2017-new-coder-survey-part-2.csv"


d1 <- read.csv(filepath1)
d2 <- read.csv(filepath2)
head(d1)

d1 <- d1 %>% 
  select(-Before.you.got.this.job..how.many.months.did.you.spend.looking.for.a.job.) # Remove unnecessary columns

## Rename the columns for both datasets (Part 1 and Part2 of the survey) from questions to easier words

renamed_d1 <- d1 %>% rename(ID = X.) %>%
  rename(IsSoftwareDev = Are.you.already.working.as.a.software.developer.) %>%
  rename(FirstDevJob = Is.this.your.first.software.development.job.) %>%
  rename(JobPref = Would.you.prefer.to...) %>%
  rename(JobInterestFullStack = Full.Stack.Web.Developer) %>%
  rename(JobInterestBackEnd = Back.End.Web.Developer) %>% 
  rename(JobInterestFrontEnd = X..Front.End.Web.Developer ) %>% 
  rename(JobInterestMobileDev = X..Mobile.Developer) %>% 
  rename(JobInterestDevOps = X..DevOps...SysAdmin) %>%
  rename(JobInterestDataSci = X..Data.Scientist) %>%
  rename(JobInterestQAEngg = X..Quality.Assurance.Engineer) %>%
  rename(JobInterestUX = X..User.Experience.Designer) %>%
  rename(JobInterestProdMngr = X..Product.Manager) %>%
  rename(JobInterestGameDev = Game.Developer) %>%
  rename(JobInterestInfoSec = Information.Security) %>%
  rename(JobInterestDataEngg = Data.Engineer) %>%
  rename(JobInterestOther = Other) %>%
  rename(WhenStartApply = When.do.you.plan.to.start.applying.for.developer.jobs.) %>%
  rename(ExpectedEarning = About.how.much.money.do.you.expect.to.earn.per.year.at.your.first.developer.job..in.US.Dollars..) %>%
  rename(WorkPref = Would.you.prefer.to.work...) %>%
  rename(JobRelocation = Are.you.willing.to.relocate.for.a.job.) %>%
  rename(ResourceFCC = freeCodeCamp) %>%
  rename(ResourceEdX = EdX) %>%
  rename(ResourceCoursera = Coursera) %>%
  rename(ResourceKA = Khan.Academy) %>%
  rename(ResourcePlural = Pluralsight...Code.School) %>%
  rename(ResourcCodecademy = Codecademy) %>%
  rename(ResourceUdacity = Udacity) %>%
  rename(ResourceUdemy = Udemy) %>%
  rename(ResourceCodewars = Code.Wars) %>%
  rename(ResourceOdinProj = The.Odin.Project) %>%
  rename(ResourceTreehou = Treehouse) %>%
  rename(ResourceLynda = Lynda.com) %>%
  rename(ResourceStackOver = Stack.Overflow) %>%
  rename(ResourceW3S = W3Schools) %>%
  rename(ResourceSkillCrush = Skillcrush) %>%
  rename(ResourceHackerRank = HackerRank) %>%
  rename(ResourceMozilla = Mozilla.Developer.Network..MDN.) %>%
  rename(ResourceEgghead = Egghead.io) %>%
  rename(ResourceCSST = CSS.Tricks) %>%
  rename(ResourceOther = Other.1) %>%
  rename(CodeEventFCC = freeCodeCamp.study.groups) %>%
  rename(CodeEventHackathon = hackathons) %>%
  rename(CodeEventConf = conferences) %>%
  rename(CodeEventWorkshop = workshops) %>%
  rename(CodeEventStartupWeekend = Startup.Weekend) %>%
  rename(CodeEventNodeSchool = NodeSchool) %>%
  rename(CodeEventWomenWhoCode = Women.Who.Code) %>%
  rename(CodeEventGirlDevelopIt = Girl.Develop.It) %>%
  rename(CodeEventMeetup = Meetup.com.events) %>%	
  rename(CodeEventRailsBridge = RailsBridge) %>%	
  rename(CodeEventGameJam = Game.Jam) %>%	
  rename(CodeEventRailsGirls = Rails.Girls) %>%	
  rename(CodeEventDjangoGirls = Django.Girls) %>%	
  rename(CodeEventWeekendBootcamps = weekend.bootcamps) %>%	
  rename(CodeEventOther = Other.2) %>%	
  rename(PodCastCodeNewbie = Code.Newbie) %>%	
  rename(PodCastChangelog = The.Changelog) %>%	
  rename(PodCastSEDaily = Software.Engineering.Daily) %>%	
  rename(PodCastJSJabber = JavaScript.Jabber) %>%	
  rename(PodCastRubyRogues = Ruby.Rogues) %>%	
  rename(PodCastShopTalkShow = Shop.Talk.Show) %>%	
  rename(PodCastDeveloperTea = Developer.Tea) %>%	
  rename(PodCastProgrammingThrowdown = Programming.Throwdown) %>%	
  rename(PodCastDotNETRocks = .NET.Rocks) %>%	
  rename(PodCastTalkPythonToMe = Talk.Python.To.Me) %>%	
  rename(PodCastJavaScriptAir = JavaScript.Air) %>%	
  rename(PodCastWebAhead = The.Web.Ahead) %>%	
  rename(PodCastCodePenRadio = CodePen.Radio) %>%	
  rename(PodCastGiantRobots = Giant.Robots.Smashing.into.Other.Giant.Robots) %>%	
  rename(PodCastSERadio = Software.Engineering.Radio) %>%	
  rename(PodCastOther = Other.3) %>%	
  rename(YouTubeMITOpenCourseware = MIT.Open.Courseware) %>%	
  rename(YouTubeNewBoston = The.New.Boston) %>%	
  rename(YouTubeFCC = freeCodeCamp.1) %>%	
  rename(YouTubeComputerphile = Computerphile) %>%	
  rename(YouTubeDevTips = DevTips) %>%	
  rename(YouTubeEngineeredTruth = Engineered.Truth) %>%	
  rename(YouTubeLearnCodeAcademy = LearnCode.Academy) %>%	
  rename(YouTubeCodeCourse = CodeCourse) %>%	
  rename(YouTubeLevelUpTuts = LevelUpTuts) %>%	
  rename(YouTubefunfunfunction = funfunfunction) %>%
  rename(YouTubeCodingTut360 = Coding.Tutorials.360) %>%
  rename(YouTubeCodingTrain = Coding.Train..Coding.Rainbow.) %>%
  rename(YouTubeDerekBanas = Derek.Banas) %>%
  rename(YouTubeSimplilearn = Simplilearn) %>%
  rename(YouTubeMozillaHacks = Mozilla.Hacks) %>%
  rename(YouTubeGoogleDevelopers = Google.Developers) %>%
  rename(YouTubeOther = Other.4) %>%
  rename(HoursSpendLearning = About.how.many.hours.do.you.spend.learning.each.week.) %>%
  rename(MonthsProgramming = About.how.many.months.have.you.been.programming.for.) %>%
  rename(AttendedBootcamp = Have.you.attended.a.full.time.coding.bootcamp.) %>%
  rename(BootcampName = Which.one.) %>%
  rename(BootcampFinish = Have.you.finished.yet.) %>%
  rename(BootcampLoan = Did.you.take.out.a.loan.to.pay.for.the.bootcamp.) %>%
  rename(BootcampRecommend = Based.on.your.experience..would.you.recommend.this.bootcamp.to.your.friends.) %>%
  rename(MoneySpendLearning = Aside.from.university.tuition..about.how.much.money.have.you.spent.on.learning.to.code.so.far..in.US.dollars..) %>%
  rename(StartDatePart1 = Start.Date..UTC.) %>%
  rename(EndDatePart1 = Submit.Date..UTC.) %>%
  rename(NetworkID = Network.ID) 
  

renamed_d2 <- d2 %>% rename(ID = X.) %>%
  rename(Age = How.old.are.you.) %>%
  rename(Gender = What.s.your.gender.) %>%
  rename(GenderOther = Other) %>%
  rename(CountryCitizen = Which.country.are.you.a.citizen.of.) %>%
  rename(CountryLive = Which.country.do.you.currently.live.in.) %>% 
  rename(CountryPopulation = About.how.many.people.live.in.your.city. ) %>% 
  rename(EthnicMinority = Are.you.an.ethnic.minority.in.your.country.) %>% 
  rename(LanguageAtHome = Which.language.do.you.you.speak.at.home.with.your.family.) %>%
  rename(SchoolDegree = What.s.the.highest.degree.or.level.of.school.you.have.completed.) %>%
  rename(SchoolMajor = What.was.the.main.subject.you.studied.in.university.) %>%
  rename(MaritalStatus = What.s.your.marital.status.) %>%
  rename(HasFinancialDependents = Do.you.financially.support.any.dependents.) %>%
  rename(HasChildren = Do.you.have.children.) %>%
  rename(ChildrenNo = How.many.children.do.you.have.) %>%
  rename(SupportFinancially = Do.you.financially.support.any.elderly.relatives.or.relatives.with.disabilities.) %>%
  rename(HasDebt = Do.you.have.any.debt.) %>%
  rename(HasHomeMortgage = Do.you.have.a.home.mortgage.) %>%
  rename(HomeMortgageOwe = About.how.much.do.you.owe.on.your.home.mortgage..in.US.Dollars..) %>%
  rename(HasStudentLoanDebt = Do.you.have.student.loan.debt.) %>%
  rename(StudentLoanOwe = About.how.much.do.you.owe.in.student.loans..in.US.Dollars..) %>%
  rename(EmploymentStatus = Regarding.employment.status..are.you.currently...) %>%
  rename(EmploymentStatusOther = Other.1) %>%
  rename(FieldofWork = Which.field.do.you.work.in.) %>%
  rename(FieldofWorkOther = Other.2) %>%
  rename(Income = About.how.much.money.did.you.make.last.year..in.US.dollars..) %>%
  rename(TimeforCommute = About.how.many.minutes.does.it.take.you.to.get.to.work.each.day.) %>%
  rename(IsUnderEmployed = Do.you.consider.yourself.under.employed.) %>%
  rename(HasServedMilitary = Have.you.served.in.your.country.s.military.before.) %>%
  rename(HasDisabilityBenefits = Do.you.receive.disability.benefits.from.your.government.) %>%
  rename(HasHighSpeedInternet = Do.you.have.high.speed.internet.at.your.home.) %>%
  rename(IsSoftwareDev = already_working) %>%
  rename(JobInterested = jobs_interested_in) %>%
  rename(JobPref = want_employment_type) %>%
  rename(ExpectedEarning = expected_earnings) %>%
  rename(WorkPref = home_or_remote) %>%
  rename(JobRelocation = will_relocate) %>%
  rename(CodeEvent = attended_event_types) %>%
  rename(Resources = learning_resources) %>%
  rename(HoursSpendLearning = hours_learning_week) %>%
  rename(MonthsProgramming = months_learning) %>%
  rename(AttendedBootcamp = attend_bootcamp) %>%
  rename(BootcampName = which_bootcamp) %>%
  rename(BootcampFinish = finished_bootcamp) %>%
  rename(BootcampLoan = loan_for_bootcamp) %>%
  rename(BootcampRecommend = recommend_bootcamp) %>%
  rename(MoneySpendLearning = total_spent_learning) %>%
  rename(PodCast = podcast) %>%
  rename(WhenStartApply = how_soon_jobhunt) %>%
  rename(YouTube = youtube) %>%	
  rename(StartDatePart2 = Start.Date..UTC.) %>%
  rename(EndDatePart2 = Submit.Date..UTC.) %>%
  rename(NetworkID = Network.ID) 


# Removing xxxxx in ExpectedEarning column
EarningXs = renamed_d2 %>% filter(ExpectedEarning == "xxxxx")
renamed_d2 = renamed_d2 %>% setdiff(EarningXs) 

# Modifying the datasets to ensure consistency before joining

# Standardizing the values in columns common for both datasets, i.e., changing yes/no to 0/1 for columns in renamed_d2
changeCols = c("IsSoftwareDev","AttendedBootcamp","BootcampFinish","BootcampLoan",
               "BootcampRecommend","JobRelocation")

renamed_d2 <- renamed_d2 %>%
  mutate(across(.cols = all_of(changeCols),
                ~ifelse(. == "Yes","1",ifelse(. == "No","0",NA))))

glimpse(renamed_d2)


# Removing truncated values from WhenStartApply column
unique(renamed_d2$WhenStartApply)

applyTime <- renamed_d2$WhenStartApply

truncateApply = c()

for (i in 1:length(applyTime)){
  
  tempApply <- applyTime[i] %>%
    unlist %>%
    ifelse(. == "I","I'm already applying",.) %>%
    ifelse(. == "I haven","I haven't decided",.)
        
  truncateApply <- c(truncateApply,tempApply)
}

renamed_d2 <- renamed_d2 %>%
  mutate(WhenStartApply = truncateApply) %>% glimpse()
  
unique(renamed_d2$WhenStartApply)


# Change the type of common columns in renamed_d1 to char
changeColChar = c("AttendedBootcamp","BootcampFinish","BootcampLoan","BootcampRecommend","JobRelocation","IsSoftwareDev")

renamed_d1 <- renamed_d1 %>%
  mutate(across(.cols = all_of(changeColChar), as.character))


# Remove non-numeric values from the columns in renamed_d2, changing ranges to average or one of the two values in the range
renamed_d2$HoursSpendLearning <- renamed_d2$HoursSpendLearning %>%
  sub("30-40","35",.) %>%
  sub("5-10","8",.) %>%
  sub("4-5",4,.) %>%
  sub("3-4",4,.) %>%
  gsub("[^0-9.]","",.)
unique(renamed_d2$HoursSpendLearning)

renamed_d2$MonthsProgramming <- renamed_d2$MonthsProgramming %>%
  gsub("[^0-9.]","",.)

renamed_d2$MoneySpendLearning <- renamed_d2$MoneySpendLearning %>%
  sub("free courses","0",.) %>%
  gsub("[^0-9.]","",.)

renamed_d2$ExpectedEarning <- renamed_d2$ExpectedEarning %>%
  sub("80k-100k","80000",.) %>%
  sub("free courses","0",.) %>%
  gsub("[^0-9.]","",.)


# Change the type of the above columns to numeric
AltCharCols  = c("HoursSpendLearning","MonthsProgramming","MoneySpendLearning","ExpectedEarning")

renamed_d2 <- renamed_d2 %>%
  mutate(across(.cols = all_of(AltCharCols), as.numeric))


# Remove duplicate network id's from renamed_d2
renamed_d2 <- distinct(renamed_d2, NetworkID, .keep_all = TRUE)


# Join both datasets together
key = c("MoneySpendLearning","ExpectedEarning","HoursSpendLearning","MonthsProgramming","AttendedBootcamp",
        "BootcampFinish","BootcampLoan","BootcampRecommend","JobRelocation","IsSoftwareDev",
        "WhenStartApply","WorkPref","JobPref","BootcampName","NetworkID")

join_data <- left_join(renamed_d1, renamed_d2, by = key)


# Checking inconsistencies within the date values

# Change datatypes to date for the columns for easy data manipulation
cleandate <- join_data %>%
  mutate(EndDatePart1 = as.POSIXct(EndDatePart1)) %>%
  mutate(StartDatePart2 = as.POSIXct(StartDatePart2)) %>%
  mutate(DateDiff = StartDatePart2 - EndDatePart1)


cleandate <- cleandate %>%
  select(sort(colnames(cleandate)))

glimpse(cleandate)

# Separating date values with NA 
datediffna = cleandate %>% filter(is.na(DateDiff))
datediff = cleandate %>% filter(!is.na(DateDiff))


# Remove values with negative DateDiff i.e., part 2 of survey started before part 1
cleandate <- cleandate %>% filter(DateDiff > 0)

# Remove multiple first ID's put to second part ID's
idxUnique = cleandate %>% group_by(ID.x) %>% 
  filter(n() == 1)

idx = cleandate %>% group_by(ID.x) %>% 
  filter(n() > 1) %>%
  mutate(minDiff = min(DateDiff)) %>%
  filter(DateDiff == minDiff)

cleandate = bind_rows(idxUnique,idx) %>% select(-one_of("minDiff"))

# Remove multiple second ID's put to first part ID's
idyUnique = cleandate %>% group_by(ID.y) %>% 
  filter(n() == 1)

idy = cleandate %>% group_by(ID.y) %>% 
  filter(n() > 1) %>%
  mutate(minDiff = min(DateDiff)) %>%
  filter(DateDiff == minDiff)

cleandate = bind_rows(idyUnique,idy) %>% select(-one_of("minDiff"))  


# Ungroup data from the groupby()
cleandate <- cleandate %>% ungroup()


#### CLEANING ALL THE COLUMNS ####

# Cleaning columns related to JobInterest
JobCols = cleandate %>% 
  select(starts_with("JobInterest"),-JobInterestOther,-JobInterested) %>%
  names()

# Assign 1 in place of non-empty values
cleanJobInterest <- cleandate %>%
  mutate(across(.cols = all_of(JobCols),
                  ~ifelse(.!="","1", .)))  %>%
  mutate(across(.cols = all_of(JobCols), as.integer))

# Normalizing the uncertain job roles to Undecided in JobInterestOther
undecided_words = c("Other","Not sure","I dont yet know","Not sure!","*","undeceided","I don't know yet!",
                    "i don't know what the difference is between most of these soz lol","idk","Unsure","Don't know yet",
                    "Not sure yet","Any of them.","undecided","Not sure","Unsure....","Don't know yet.",
                    "I don't know yet","i dunno!!!!","Not entirely sure just find coding fun and interesting",
                    "I don't know yet","i dunno!!!!","Not entirely sure just find coding fun and interesting")

cleanJobInterest <- cleanJobInterest %>%
  mutate(JobInterestOther = replace(JobInterestOther,tolower(JobInterestOther) %in% tolower(undecided_words),"Undecided"))


# Title casing the JobInterestOther column
cleanJobInterest <- cleanJobInterest %>%
  mutate(across(JobInterestOther,
                ~ifelse(!is.na(.), str_to_title(.),.)))


# Cleaning columns related to CodeEvents - similar to cleaning of JobInterest columns above
CodeEventCols = cleanJobInterest %>% 
  select(starts_with("CodeEvent"),-CodeEventOther,-CodeEvent) %>%
  names()

cleanCodeEvent <- cleanJobInterest %>%
  mutate(across(.cols = all_of(CodeEventCols),
                ~ifelse(.!="","1", .))) %>%
  mutate(across(.cols = all_of(CodeEventCols), as.integer))

# Normalizing Nones to NA
nones <- c("not","none","never","no attended","havent","haven't","didn't","nothing","don't",
  "didnt","n a","have yet","nono","nobody","no event","any one","nope","dont","haven;t",
  "non","noone","null","limited","n/a","\bna\b","nil")


cleanCodeEvent <- cleanCodeEvent %>%
  mutate(CodeEventOther = ifelse(grepl(paste(nones, collapse = "|"), CodeEventOther, ignore.case = TRUE), NA, CodeEventOther))
unique(cleanCodeEvent$CodeEventOther)


cleanCodeEvent <- cleanCodeEvent %>%
  mutate(across(CodeEventOther,
                ~ifelse(!is.na(.), str_to_title(.),.)))


# Cleaning columns related to Podcast - similar to cleaning of JobInterest columns  
PodcastCols = cleanCodeEvent %>% 
  select(starts_with("Podcast"),-PodCastOther,-PodCast) %>%
  names()

cleanPodcast <- cleanCodeEvent %>%
  mutate(across(.cols = all_of(PodcastCols),
                ~ifelse(.!="","1", .))) %>%
  mutate(across(.cols = all_of(PodcastCols), as.integer))


# Normalizing Nones to NA in PodCastOther column
nonePods <- c("not","none","never","no attended","havent","haven't","didn't","nothing","don't","no ","false","nil","nop",
           "didnt","n a","have yet","nono","nobody","no event","any one","nope","dont","haven;t","have't",
           "non","noone","null","limited","n/a","\bna\b","\bnil\b","\bno\b","iduntlitsentopodcasts","na")

cleanPodcast <- cleanPodcast %>%
  mutate(PodCastOther = ifelse(grepl(paste(nonePods, collapse = "|"), PodCastOther, ignore.case = TRUE), NA, PodCastOther))


cleanPodcast <- cleanPodcast %>%
  mutate(across(PodCastOther,
                ~ifelse(!is.na(.), str_to_title(.),.)))

# Cleaning columns related to Resources - similar to cleaning of JobInterest columns 
ResourceCols = cleanPodcast %>% 
  select(starts_with("Resource"),-ResourceOther,-Resources) %>%
  names()

cleanResource <- cleanPodcast %>%
  mutate(across(.cols = all_of(ResourceCols),
                ~ifelse(.!="","1", .))) %>%
  mutate(across(.cols = all_of(ResourceCols), as.integer))


noneRes <- c("not","none","never","no attended","havent","haven't","didn't","nothing","don't","no ","false","nil","nop",
             "didnt","n a","have yet","nono","nobody","no event","any one","nope","dont","haven;t","have't",
             "non","noone","null","limited","n/a","\bna\b","\bnil\b","\bno\b","na")


cleanResource <- cleanResource %>%
  mutate(ResourceOther = ifelse(grepl(paste(noneRes, collapse = "|"), ResourceOther, ignore.case = TRUE), NA, ResourceOther))


cleanResource <- cleanResource %>%
  mutate(across(ResourceOther,
                ~ifelse(!is.na(.), str_to_title(.),.)))

# Cleaning columns related to Youtube  - similar to cleaning of JobInterest columns
YoutubeCols = cleanResource %>% 
  select(starts_with("YouTube"),-YouTubeOther,-YouTube) %>%
  names()

cleanYoutube <- cleanResource %>%
  mutate(across(.cols = all_of(YoutubeCols),
                ~ifelse(.!="","1", .))) %>%
  mutate(across(.cols = all_of(YoutubeCols), as.integer))


noneYT <- c("not","none","never","no attended","havent","haven't","didn't","nothing","don't","no ","false","nil","nop",
            "didnt","n a","have yet","nono","nobody","no event","any one","nope","dont","haven;t","have't",
            "non","noone","null","limited","n/a","\bna\b","\bnil\b","\bno\b","iduntlitsentopodcasts","na")


cleanYoutube <- cleanYoutube %>%
  mutate(YouTubeOther = ifelse(grepl(paste(noneYT, collapse = "|"), YouTubeOther, ignore.case = TRUE), NA, YouTubeOther))


cleanYoutube <- cleanYoutube %>%
  mutate(across(YouTubeOther,
                ~ifelse(!is.na(.), str_to_title(.),.)))


# Cleaning HoursSpendLearning column by removing time more than 100 hours
cleanHoursSpend <- cleanYoutube %>%
  mutate(HoursSpendLearning = ifelse(HoursSpendLearning > 100, NA, HoursSpendLearning)) %>%
  mutate(HoursSpendLearning = as.integer(HoursSpendLearning))


# Cleaning MoneySpendLearning column by removing outliers greater than 250000
cleanMoneySpend <- cleanHoursSpend %>%
  mutate(MoneySpendLearning = ifelse(MoneySpendLearning > 250000, NA, MoneySpendLearning)) %>%
  mutate(MoneySpendLearning = as.integer(MoneySpendLearning))


# Cleaning Age column by removing values more than 100
cleanAge <- cleanMoneySpend %>%
  mutate(Age = ifelse(Age > 100, NA, Age)) %>%
  mutate(Age = as.integer(Age))


# Cleaning HomeMortgageOwe column by removing values less than 1000 & greater than 1000000
cleanHomeMorgage <- cleanAge %>%
  mutate(HomeMortgageOwe = ifelse(HomeMortgageOwe < 1000 | HomeMortgageOwe > 1000000, NA, HomeMortgageOwe))


# Cleaning ExpectedEarnings & Income columns

# In both, values < 19 (too weird to be monthly income and too small for yearly) & 
# values b/w 201 - 499 (too high for annual, too small for monthly) are set to NA, 
# values b/w 20 - 200 are multiplied by 1000 (too small for monthly, large enough to be annual if 1000x)
# Values b/w 500 - 5999 are multiplied by 12 (looks like monthly salary for poor and middle-rich countries)
# For Income values, the limit is set to 1000000

cleanExpectedEarn <- cleanHomeMorgage %>%
  mutate(ExpectedEarning = 
           (ifelse(ExpectedEarning < 19, NA,
                   ifelse(ExpectedEarning >= 20 & ExpectedEarning <= 200, ExpectedEarning*1000,
                          ifelse(ExpectedEarning >= 201 & ExpectedEarning <= 499, NA, 
                                 ifelse(ExpectedEarning >= 500 & ExpectedEarning <= 5999, ExpectedEarning*12, NA)))))) %>%
  mutate(ExpectedEarning = as.integer(ExpectedEarning))


# Cleaning Income column
cleanIncome <- cleanExpectedEarn %>%
  mutate(Income = 
           (ifelse(Income < 19, NA,
                   ifelse(Income >= 20 & Income <= 200, Income*1000,
                          ifelse(Income >= 201 & Income <= 499, NA, 
                                 ifelse(Income >= 500 & Income <= 5999, Income*12,
                                        ifelse(Income <= 1000000 , Income, NA))))))) %>%
  mutate(Income = as.integer(Income))




# Cleaning StudentLoanOwe column by removing values less than 100 & greater than 500000
cleanStudentLoan <- cleanIncome %>%
  mutate(StudentLoanOwe = ifelse(StudentLoanOwe < 100 | StudentLoanOwe > 500000, NA, StudentLoanOwe))


# Cleaning ChildrenNo & HasChildren columns by removing values greater than 10
cleanChildren <- cleanStudentLoan %>%
  mutate(HasChildren = ifelse(ChildrenNo == 0, 0, HasChildren)) %>%
  mutate(ChildrenNo = ifelse(ChildrenNo == 0 | ChildrenNo > 10, NA, ChildrenNo))

glimpse(cleanChildren)

# Cleaning of data by removing unnecessary columns
cleanedData <- cleanChildren %>%
  select(-DateDiff, -Resources, -PodCast, -CodeEvent, -YouTube) 

# Final cleaning the data by changing the data type of columns
cleanedData <- cleanedData %>%
  mutate(AttendedBootcamp = as.integer(AttendedBootcamp)) %>%
  mutate(BootcampFinish = as.integer(BootcampFinish)) %>%
  mutate(BootcampLoan = as.integer(BootcampLoan)) %>%
  mutate(BootcampRecommend = as.integer(BootcampRecommend)) %>%
  mutate(IsSoftwareDev = as.integer(IsSoftwareDev)) %>%
  mutate(JobRelocation = as.integer(JobRelocation)) %>%
  mutate(MonthsProgramming = as.integer(MonthsProgramming))

glimpse(cleanedData)

write.csv(x = cleanedData,
          file = "C:/Users/Durga P T M/Documents/R_Projects/2017-fCC-New-Coders-Survey-CleanedData.csv",
          na = "NA",
          row.names = FALSE)



