//
//  MPDisplayableEntityPropertiesFacade.m
//  iPUT
//
//  Created by Paciej on 17/05/14.
//  Copyright (c) 2014 Maciej Piotrowski. All rights reserved.
//

#import "MPDisplayableEntityPropertiesFacade.h"

@implementation MPDisplayableEntityPropertiesFacade

+ (MPDisplayableEntityProperties *)propertiesForClassName: (NSString *)className {
    MPDisplayableEntityProperties *properties = nil;
    NSArray *classNames =   @[
                              kBeaconProfileEntityName,
                              kUUIDEntityName,
                              kBlobEntityName,
                              kBuildingEntityName,
                              kChairEntityName,
                              kDateEntityName,
                              kFacultyEntityName,
                              kFieldEntityName,
                              kFloorEntityName,
                              kGroupEntityName,
                              kLecturerEntityName,
                              kLibraryEntityName,
                              kLibraryResourceEntityName,
                              kListOfPresenceEntityName,
                              kRoomEntityName,
                              kSpecialtyEntityName,
                              kStudentEntityName,
                              kSubjectEntityName,
                              kUniversityEntityName,
                              kUserEntityName,
                              kYearEntityName];
    if ([classNames containsObject:className]) {
         properties = [MPDisplayableEntityProperties new];
    switch ([classNames indexOfObject:className]) {
        case 0:{//kBeaconProfileEntityName,
            properties.properties = @[@"proximityUUID",
                                      @"major",
                                      @"minor"];
            properties.propertiesNames = @[@"Proximity UUID",
                                            @"Major",
                                            @"Minor"];
            properties.objects = @[@"student", @"lecturer", @"room"];

            }
            break;
        case 1:{//kUUIDEntityName,
            properties.properties = @[@"uuidString"];
            properties.propertiesNames = @[@"UUID"];
            properties.sets = @[@"building", @"user"];

        }
            break;
        case 2:{//kBlobEntityName,
//            properties.properties =  @[@"filePath"];
//            properties.propertiesNames = @[@"Filepath"];
            /*properties.objects = @[@"resource",
                                   @"lecturer",
                                   @"student"];
            properties.objectsNames = @[@"Book",
                                        @"Lecturer",
                                        @"Student"];*/
        }
            break;
        case 3:{//kBuildingEntityName,
            properties.properties = @[@"name",
                                      @"address",
                                      @"major"];//set major automaticaly
            properties.propertiesNames = @[@"Name",
                                           @"Address",
                                           @"Major"];
            properties.sets = @[@"floors"];
            properties.setsNames = @[@"Floors"];
            properties.setsAcceptableObjectTypes = @[@"Floor"];
        }
            break;
        case 4:{//kChairEntityName,
            properties.properties = @[@"name"];
            properties.propertiesNames = @[@"Name"];
            properties.sets = @[@"lecturers",
                                @"specialties"];
            properties.setsNames = @[@"Lecturers",
                                     @"Specialties"];
            properties.setsAcceptableObjectTypes = @[@"Lecturer", @"Specialty"];

            properties.objects = @[@"head"];
            properties.objectsNames = @[@"Head"];
        }
            break;
        case 5:{// kDateEntityName,
            properties.properties = @[@"dateStart",
                                      @"dateEnd"];
            properties.propertiesNames = @[@"Start",
                                           @"End"];
            properties.objects = @[@"list"];
            properties.objectsNames = @[@"Presence List"];
        }
            break;
        case 6:{//kFacultyEntityName,
            properties.properties = @[@"name"];
            properties.propertiesNames = @[@"Name"];
            properties.sets = @[@"chairs",
                                @"fields"];
            properties.setsNames = @[@"Chairs",
                                     @"Fields"];
            properties.setsAcceptableObjectTypes = @[@"Chair", @"Field"];

        }
            break;
        case 7:{// kFieldEntityName,
            properties.properties = @[@"name"];
            properties.propertiesNames = @[@"Name"];
            properties.sets = @[@"yearsOfStudies"];
            properties.setsNames = @[@"Years"];
            properties.setsAcceptableObjectTypes = @[@"YearOfStudies"];

        }
            break;
        case 8:{//kFloorEntityName,
            properties.properties = @[@"number"];
            properties.propertiesNames = @[@"Number"];
            properties.sets = @[@"rooms"];
            properties.setsNames = @[@"Rooms"];
            properties.setsAcceptableObjectTypes = @[@"Room"];

        }
            break;
        case 9:{//kGroupEntityName,
            properties.properties = @[@"name"];
            properties.propertiesNames = @[@"Name"];
            properties.sets = @[@"students",
                                @"subjects"];
            properties.setsNames = @[@"Students",
                                     @"Subjects"];
            properties.setsAcceptableObjectTypes = @[@"Student", @"Subject"];

        }
            break;
        case 10:{//kLecturerEntityName,
            properties.properties = @[@"degree",
                                      @"firstName",
                                      @"lastName",
                                      @"lecturerID"];
            properties.propertiesNames = @[@"Degree",
                                           @"First Name",
                                           @"Last Name",
                                           @"ID"];
            properties.objects = @[@"room"];
            properties.objectsNames = @[@"Room"];
            properties.sets = @[@"subscribedLibraries"];
            properties.setsNames = @[@"Library subscription"];
            
        }
            break;
        case 11:{//kLibraryEntityName,
            properties.properties = @[@"name",
                                      @"number"];
            properties.propertiesNames = @[@"Name",
                                           @"Number"];
            properties.sets = @[@"resources"];
            properties.setsNames = @[@"Books"];
            properties.setsAcceptableObjectTypes = @[@"Book"];

        }
            break;
        case 12:{//kLibraryResourceEntityName,
            properties.properties = @[@"author",
                                      @"title"];
            properties.propertiesNames = @[@"Author",
                                           @"Title"];
            properties.objects = @[@"blob"];
            properties.objectsNames = @[@"Blob"];

        }
            break;
        case 13:{//kListOfPresenceEntityName,
            properties.sets = @[@"presentStudents"];
            properties.setsNames = @[@"Present Students"];
        }
            break;
        case 14:{//kRoomEntityName,
            properties.properties = @[@"name",
                                      @"number"];
            properties.propertiesNames = @[@"Name",
                                           @"Number"];
        }
            break;
        case 15:{//kSpecialtyEntityName,
            properties.properties = @[@"name"];
            properties.propertiesNames = @[@"Name"];
        }
            break;
        case 16:{//kStudentEntityName,
            properties.properties = @[@"degree",
                                      @"firstName",
                                      @"lastName",
                                      @"studentID"];
            properties.propertiesNames = @[@"Degree",
                                           @"First Name",
                                           @"Last Name",
                                           @"ID"];
            properties.objects = @[@"specialtyOfStudies"];
            properties.objectsNames = @[@"Specialty"];
            properties.sets = @[@"subscribedLibraries"];
            properties.setsNames = @[@"Library subscription"];
        }
            break;
        case 17:{//kSubjectEntityName,
            properties.properties = @[@"name"];
            properties.propertiesNames = @[@"Name"];
            properties.sets = @[@"dates"];
            properties.setsNames = @[@"Class dates"];
            properties.setsAcceptableObjectTypes = @[@"Date"];
            properties.objects = @[@"lecturer"];
            properties.objectsNames = @[@"Lecturer"];
        }
            break;
        case 18:{//kUniversityEntityName,
            properties.properties = @[@"name"];
            properties.propertiesNames = @[@"Name"];
            properties.sets = @[@"faculties"];
            properties.setsNames = @[@"Faculties"];
            properties.setsAcceptableObjectTypes = @[@"Faculty"];
        }
            break;
        case 19:{//kUserEntityName,
            properties.properties = @[@"isAdmin",
                                      @"username"];
//                                      ,@"password"];
            properties.propertiesNames = @[@"Admin",
                                           @"Username"];
//                                           ,@"Password"];
            properties.objects = @[@"lecturer", @"student"];
            properties.objectsNames = @[@"Lecturer", @"Student"];
        }
            break;
        case 20:{//kYearEntityName,
            properties.properties = @[@"levelOfStudies",
                                      @"semester",
                                      @"yearStart",
                                      @"yearEnd"];
            properties.propertiesNames = @[@"Level",
                                           @"Semester",
                                           @"Start year",
                                           @"End year"];
            properties.sets = @[@"groups"];
            properties.setsNames = @[@"Groups"];
            properties.setsAcceptableObjectTypes = @[@"Group"];

        }
            break;
            
        default:
            break;
    }
        
    }
    return properties;
}

@end
