//
//  MPDatabaseBootstrapper.m
//  iPUT
//
//  Created by Paciej on 06/04/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPDatabaseBootstrapper.h"
#import "MPSynchronizationFacade.h"

@implementation MPDatabaseBootstrapper
//shared instance
+ (instancetype)sharedInstance {
    static MPDatabaseBootstrapper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MPDatabaseBootstrapper new];
    });
    return instance;
}
//bootstrap method
- (void)bootstrapDatabase {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isDatabaseBootstrapped = [[defaults objectForKey:kDatabaseBootstrapped]boolValue];
    if (NO == isDatabaseBootstrapped) {
        [self bootstrapUUIDs];
        [self bootstrapWEiT];
        [self bootstrapLibrary];
        [self saveContext];
    }
    
}

- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@YES forKey:kDatabaseBootstrapped];
            [defaults synchronize];
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

- (void) bootstrapUUIDs {
    BeaconUUID *estimote = [BeaconUUID createEntity];
    estimote.uuidString = kEstimoteBeaconUUID;
    BeaconUUID *person = [BeaconUUID createEntity];
    person.uuidString = kiPUTPersonBeaconUUID;
    BeaconUUID *building = [BeaconUUID createEntity];
    building.uuidString = kiPUTBuildingBeaconUUID;
}

- (void) bootstrapWEiT {
    
    University *put = [University createEntity];
    put.name = @"Poznan University of Technology";
    
    Faculty *wEiT = [Faculty createEntity];
    wEiT.name = @"Electronics and Telecommunications";
    [put addFacultiesObject:wEiT];
    
    //Chair of Wireless Communications
    Chair *kRK = [Chair createEntity];
    kRK.name = @"Chair of Wireless Communications";
    
    Specialty *skRK = [Specialty createEntity];
    skRK.name = @"Wireless Communications";
    [kRK addSpecialtiesObject:skRK];
    
    Lecturer * headkRK = [Lecturer createEntity];
    headkRK.firstName = @"Paweł";
    headkRK.lastName = @"Szulakiewicz";
    headkRK.degree = @"dr hab. inż., prof. PP.";
    headkRK.lecturerID = @1;
    BeaconProfile *beaconHeadRK = [MPUtils createBeaconProfileForLecturer: headkRK];
    headkRK.beacon = beaconHeadRK;
    kRK.head = headkRK;
    [kRK addLecturersObject:headkRK];
    [wEiT addChairsObject:kRK];

    User *headRKUser = [MPUtils createUser];
    headkRK.user = headRKUser;
    headRKUser.username = @"szulakiewicz.pawel";
    headRKUser.password = @"welcome123";

    //Chair of Communication and Computer Networks
    Chair *kSTiK = [Chair createEntity];
    kSTiK.name = @"Chair of Communication and Computer Networks";
  
    Specialty *skSTiK = [Specialty createEntity];
    skSTiK.name = @"Computer Networks and Internet Technologies";
    [kSTiK addSpecialtiesObject:skSTiK];

    Lecturer * headkSTiK = [Lecturer createEntity];
    headkSTiK.firstName = @"Maciej";
    headkSTiK.lastName = @"Stasiak";
    headkSTiK.degree = @"prof. dr hab. inż.";
    headkSTiK.lecturerID = @2;
    BeaconProfile *beaconHeadkSTiK = [MPUtils createBeaconProfileForLecturer: headkSTiK];
    headkSTiK.beacon = beaconHeadkSTiK;
    kSTiK.head = headkSTiK;
    [kSTiK addLecturersObject:headkSTiK];
    [wEiT addChairsObject:kSTiK];

    User *headkSTiKUser = [MPUtils createUser];
    headkSTiK.user = headkSTiKUser;
    headkSTiKUser.username = @"stasiak.maciej";
    headkSTiKUser.password = @"welcome123";

    
    //Chair of Telecommunication Systems and Optoelectronics
    Chair *kSTiO = [Chair createEntity];
    kSTiO.name = @"Chair of Telecommunication Systems and Optoelectronics";
    
    Specialty *skSTiO = [Specialty createEntity];
    skSTiO.name = @"Telecommunication Systems";
    [kSTiO addSpecialtiesObject:skSTiO];

    Lecturer * headkSTiO = [Lecturer createEntity];
    headkSTiO.firstName = @"Ryszard";
    headkSTiO.lastName = @"Stasiński";
    headkSTiO.degree = @"prof. dr hab. inż.";
    headkSTiO.lecturerID = @3;
    BeaconProfile *beaconHeadkSTiO = [MPUtils createBeaconProfileForLecturer: headkSTiO];
    headkSTiO.beacon = beaconHeadkSTiO;
    kSTiO.head = headkSTiO;
    [kSTiO addLecturersObject:headkSTiO];
    [wEiT addChairsObject:kSTiO];

    User *headkSTiOUser = [MPUtils createUser];
    headkSTiO.user = headkSTiOUser;
    headkSTiOUser.username = @"stasinski.ryszard";
    headkSTiOUser.password = @"welcome123";

    
    //Chair of Multimedia Telecommunications and Microelectronics
    Chair *kTMiM = [Chair createEntity];
    kTMiM.name = @"Chair of Multimedia Telecommunications and Microelectronics";
    
    Specialty *skTMiM = [Specialty createEntity];
    skTMiM.name = @"Multimedia and Consumer Electronics";
    [kTMiM addSpecialtiesObject:skTMiM];

    Lecturer * headkTMiM = [Lecturer createEntity];
    headkTMiM.firstName = @"Marek";
    headkTMiM.lastName = @"Domański";
    headkTMiM.degree = @"prof. dr hab. inż.";
    headkTMiM.lecturerID = @4;
    BeaconProfile *beaconHeadkTMiM = [MPUtils createBeaconProfileForLecturer: headkTMiM];
    headkTMiM.beacon = beaconHeadkTMiM;
    kTMiM.head = headkTMiM;
    [kTMiM addLecturersObject:headkTMiM];
    [wEiT addChairsObject:kTMiM];
    
    User *headkTMiMUSer = [MPUtils createUser];
    headkTMiM.user = headkTMiMUSer;
    headkTMiMUSer.username = @"domanski.marek";
    headkTMiMUSer.password = @"welcome123";

    
    //Fields
    Field *eitS = [Field createEntity];
    eitS.name = @"Electronics and Telecommunications (stationary)";
    [wEiT addFieldsObject:eitS];

    Field *eitNS = [Field createEntity];
    eitNS.name = @"Electronics and Telecommunications (non-stationary)";
    [wEiT addFieldsObject:eitNS];

    YearOfStudies *myYear = [YearOfStudies createEntity];
    myYear.levelOfStudies = @"Master of Engineering";
    myYear.semester = @4;
    
    // Convert string to date object
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    myYear.yearStart = [dateFormatter dateFromString:@"1/10/2012"];
    myYear.yearEnd = [dateFormatter dateFromString:@"30/09/2014"];
    
    [eitNS addYearsOfStudiesObject:myYear];
    
    Group *myGroup = [Group createEntity];
    myGroup.name = @"T1";
    [myYear addGroupsObject: myGroup];
    
    Student *paciej = [Student createEntity];
    paciej.firstName = @"Maciej";
    paciej.lastName = @"Piotrowski";
    paciej.studentID = @88570;
    paciej.degree = @"inż.";
    paciej.beacon = [MPUtils createBeaconProfileForStudent:paciej];
    Blob *paciejBlob = [Blob createEntity];
    paciejBlob.db_description = [paciej description];
    paciejBlob.filePath = [[NSBundle mainBundle] pathForResource:@"MaciejPiotrowski" ofType:@"jpg"];
    paciej.photo = paciejBlob;

    User *userPaciej = [MPUtils createUser];
    userPaciej.username = @"paciej";
    userPaciej.password = @"me2you";
    paciej.user = userPaciej;
    [myGroup addStudentsObject:paciej];
    
    Student *sofiko = [Student createEntity];
    sofiko.firstName = @"Sofiya";
    sofiko.lastName = @"Kachmar";
    sofiko.studentID = @88599;
    sofiko.degree = @"mgr inż.";
    sofiko.beacon = [MPUtils createBeaconProfileForStudent:sofiko];
    User *userSofiko = [MPUtils createUser];
    userSofiko.username = @"kachmar.sofiya";
    userSofiko.password = @"welcome123";
    sofiko.user = userSofiko;
    [myGroup addStudentsObject:sofiko];
    
    Student *michalox = [Student createEntity];
    michalox.firstName = @"Michał";
    michalox.lastName = @"Wojtysiak";
    michalox.studentID = @88579;
    michalox.degree = @"mgr inż.";
    michalox.beacon = [MPUtils createBeaconProfileForStudent:michalox];
    User *userMichalox = [MPUtils createUser];
    userMichalox.username = @"wojtysiak.michal";
    userMichalox.password = @"welcome123";
    michalox.user = userMichalox;
    [myGroup addStudentsObject:michalox];
    
    Subject *druty = [Subject createEntity];
    druty.name = @"Teoria obwodów";
    druty.lecturer = headkSTiK;
    druty.group = myGroup;
    [self createDatesForSubject:druty];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    Date *date1 = [Date createEntity];
    date1.dateStart = [dateFormatter dateFromString:@"2014-04-21 09:00"];
    date1.dateEnd = [dateFormatter dateFromString:@"2014-04-21 17:30"];
    date1.subject = druty;
    date1.list = [ListOfPresence createEntity];
    [date1.list addPresentStudentsObject:paciej];

    Date *date2 = [Date createEntity];
    date2.dateStart = [dateFormatter dateFromString:@"2014-04-24 08:50"];
    date2.dateEnd = [dateFormatter dateFromString:@"2014-10-22 17:30"];
    date2.subject = druty;
    date2.list = [ListOfPresence createEntity];
    [date2.list addPresentStudentsObject:paciej];
    
    Subject *infa = [Subject createEntity];
    infa.name = @"Informatyka";
    infa.lecturer = headkRK;
    infa.group = myGroup;
    [self createDatesForSubject:infa];

    Subject *multi = [Subject createEntity];
    multi.name = @"Multimedia";
    multi.lecturer = headkTMiM;
    multi.group = myGroup;
    [self createDatesForSubject:multi];
    
    Lecturer * kliksadi = [Lecturer createEntity];
    kliksadi.firstName = @"Adrian";
    kliksadi.lastName = @"Kliks";
    kliksadi.degree = @"dr inż.";
    kliksadi.lecturerID = @5;
    BeaconProfile *beaconKliksadi = [MPUtils createBeaconProfileForLecturer: kliksadi];
    kliksadi.beacon = beaconKliksadi;
    [kRK addLecturersObject:kliksadi];
    
    User *kliksadiUSer = [MPUtils createUser];
    kliksadi.user = kliksadiUSer;
    kliksadiUSer.username = @"kliks.adrian";
    kliksadiUSer.password = @"welcome123";
    
    Subject *appki = [Subject createEntity];
    appki.name = @"Aplikacje mobilne";
    appki.lecturer = kliksadi;
    appki.group = myGroup;
    [self createDatesForSubject:appki];

}

- (void)bootstrapLibrary {
    
    Blob *sf = [Blob createEntity];
    sf.filePath = [[NSBundle mainBundle] pathForResource:@"MyJourneyToSF" ofType:@"pdf"];
    sf.db_description = @"MyJourneyToSF";
    LibraryResource *sfResource = [LibraryResource createEntity];
    sfResource.blob = sf;
    sfResource.author = @"Peter Bishop";
    sfResource.title = @"My journey to San Francisco";
    
    Blob *eit1 = [Blob createEntity];
    eit1.filePath = [[NSBundle mainBundle] pathForResource:@"EiT1" ofType:@"pdf"];
    eit1.db_description = @"EiT1";
    LibraryResource *eit1Resource = [LibraryResource createEntity];
    eit1Resource.blob = eit1;
    eit1Resource.author = @"Maciej Piotrowski";
    eit1Resource.title = @"Elektronika i telekomunikacja Tom I";
    
    Blob *eit2 = [Blob createEntity];
    eit2.filePath = [[NSBundle mainBundle] pathForResource:@"EiT2" ofType:@"pdf"];
    eit2.db_description = @"EiT2";
    LibraryResource *eit2Resource = [LibraryResource createEntity];
    eit2Resource.blob = eit2;
    eit2Resource.author = @"Maciej Piotrowski";
    eit2Resource.title = @"Elektronika i telekomunikacja Tom II";
    
    Blob *bsc = [Blob createEntity];
    bsc.filePath = [[NSBundle mainBundle] pathForResource:@"BSc" ofType:@"pdf"];
    bsc.db_description = @"BSc";
    LibraryResource *bscResource = [LibraryResource createEntity];
    bscResource.blob = bsc;
    bscResource.author = @"Maciej Piotrowski";
    bscResource.title = @"Application for Android-based smartphone offering selected eCall services";
    
    Building *building = [Building createEntity];
    building.address = @"\nPiotrowo 3A,\n60-965 Poznań";
    building.name = @"Wydział Elektroniki i Telekomunikacji";
    building.beaconUUID = [MPUtils beaconUUIDForRoom];
    building.major = @1;
    Floor *floor3 = [Floor createEntity];
    floor3.number = @3;
    floor3.building = building;
    Library *library = [Library createEntity];
    library.number = @305;
    library.floor = floor3;
    library.name = @"WEiT Library 1";
    library.beacon = [MPUtils createBeaconProfileForRoom:library];
    [bscResource addLibrariesObject:library];
    Library *library2 = [Library createEntity];
    library2.number = @315;
    library2.floor = floor3;
    library2.name = @"WEiT Library 2";
    library2.beacon = [MPUtils createBeaconProfileForRoom:library2];
    [eit2Resource addLibrariesObject:library2];
    [eit1Resource addLibrariesObject:library2];
    
    Building *buildingCW = [Building createEntity];
    buildingCW.address = @"\nKampus Piotrowo";
    buildingCW.name = @"Centrum Wykładowe";
    buildingCW.beaconUUID = [MPUtils beaconUUIDForRoom];
    buildingCW.major = @2;
    Floor *floor1 = [Floor createEntity];
    floor1.number = @1;
    floor1.building = buildingCW;
    Library *libraryCW = [Library createEntity];
    libraryCW.number = @40;
    libraryCW.floor = floor1;
    libraryCW.name = @"Biblioteka Główna Politechniki Poznańskiej";
    libraryCW.beacon = [MPUtils createBeaconProfileForRoom:libraryCW];
    [bscResource addLibrariesObject:libraryCW];

    Room *empty = [Room createEntity];
    empty.number = @10;
    empty.floor = floor1;
    empty.name = @"Sala Wykładowa CW 10";
    empty.beacon = [MPUtils createBeaconProfileForRoom:empty];
}


- (void)createDatesForSubject:(Subject *)subject {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    Date *date1 = [Date createEntity];
    date1.dateStart = [dateFormatter dateFromString:@"2014-04-22 15:00"];
    date1.dateEnd = [dateFormatter dateFromString:@"2014-04-22 17:30"];
    date1.subject = subject;
    date1.list = [ListOfPresence createEntity];

    Date *date2 = [Date createEntity];
    date2.dateStart = [dateFormatter dateFromString:@"2014-04-23 12:00"];
    date2.dateEnd = [dateFormatter dateFromString:@"2014-08-23 17:30"];
    date2.subject = subject;
    date2.list = [ListOfPresence createEntity];

    Date *date3 = [Date createEntity];
    date3.dateStart = [dateFormatter dateFromString:@"2014-09-23 15:00"];
    date3.dateEnd = [dateFormatter dateFromString:@"2014-09-23 17:30"];
    date3.subject = subject;
    date3.list = [ListOfPresence createEntity];
    
    Date *date4 = [Date createEntity];
    date4.dateStart = [dateFormatter dateFromString:@"2014-04-21 8:00"];
    date4.dateEnd = [dateFormatter dateFromString:@"2014-04-21 12:30"];
    date4.subject = subject;
    date4.list = [ListOfPresence createEntity];
    
    Date *date5 = [Date createEntity];
    date5.dateStart = [dateFormatter dateFromString:@"2014-04-23 9:30"];
    date5.dateEnd = [dateFormatter dateFromString:@"2014-08-22 17:30"];
    date5.subject = subject;
    date5.list = [ListOfPresence createEntity];
    
    Date *date6 = [Date createEntity];
    date6.dateStart = [dateFormatter dateFromString:@"2014-09-25 11:00"];
    date6.dateEnd = [dateFormatter dateFromString:@"2014-09-25 13:30"];
    date6.subject = subject;
    date6.list = [ListOfPresence createEntity];

}
@end
