require('cloud/app.js');

// Tests.
Parse.Cloud.define("hello", function(request, response) {
  response.success(200);
});


// Helpers.
function arrayContains(a, obj) {
    for (var i = 0; i < a.length; i++) {
        if (a[i] === obj) {
            return true;
        }
    }
    return false;
}
/* [PFCloud callFunctionInBackground:@"markAsRegistered" withParameters:@{@"username":username} block:^(id object, NSError *error) {
            //if new = true user not used mobile app yet
            if (![[object valueForKey:@"new"] boolValue])
            {
                [PFCloud callFunctionInBackground:@"sentPushToUser" withParameters:@{@"username":username} block:^(id object, NSError *error) {
                    NSLog(@"%@", object);
                }];
            }
        }];*/

// Push nottifications.
function pushNotification(request,count) {
    console.log("Total users:" + count);
    
	var pushQuery = new Parse.Query(Parse.Installation);
    pushQuery.equalTo('deviceType', 'ios');

    Parse.Push.send({
      channels: [ "NewUserNotification" ],
      data: {
        alert: request.object.id
      }
    }, 
	{
      success: function() {
		  console.log("Succesfully sent push notification");
      },
      error: function(error) {
        throw "Got an error " + error.code + " : " + error.message;
      }
    });
}

// Inform iPad application when property register changes.
Parse.Cloud.beforeSave("_User", function (request,response){
     if (!request.object.existed()) {
        response.success();
     } else {
        // Get reference for the current user object.
        var obj = request.object;
        
        // All attributes changed by the query.
        var attributes = request.object.attributes;
        
        // We gonna store every property that has been changed.
        var changedAttributes = new Array();
        
        // Find out what values has been changed.
        for (var attribute in attributes) {
                
            if (obj.dirty(attribute)) {
                changedAttributes.push(attribute);
            }
        }
        
        // We only care about changes that contains "registered" property.
        if (arrayContains(changedAttributes,"registered")) {
            
            // Find out what's the current value, and what was the previous one.
            var registeredDirty = obj.dirty("registered");
            var registeredCurrent = obj.get("registered");
                       
            if (registeredCurrent) {
                
                // Parse Instalation table contains all deviceTokens and poitner for a concrete user.
                var query = new Parse.Query('_Parse.Installation');
                query.equalTo("user", request.user);
               
                // We are sending push notification for an iPad application with id of user, that changed property "registered" for true.
                Parse.Push.send({
                        channels: [ "UserRegisteredNotification" ],
                        data: {
                            alert: request.object.id
                        }
                    },
                    {
                        success: function() {
                            console.log("Succesfully sent push notification");
                            response.success();
                    },
                        error: function(error) {
                            throw "Got an error " + error.code + " : " + error.message;
                            response.error();
                    }
                });
            } else {response.success();}
        } else {response.success();}
     }
 });

// Auto-increment personID field in _User.
Parse.Cloud.afterSave("_User", function (request) {
    if (!request.object.existed()) {
        console.log("Saved user, id:" + request.object.id);
        var q = new Parse.Query("_User");
        q.count({
			success: function (count) {
				console.log(count);
				try {
				    pushNotification(request,count);
				}
				catch(err) {
				    console.log('There was an error with push notifications. Error: ' + err);
				}
				// If somehow there is no object, who knows how they manage ACID.
				if (count==0) {
					request.object.set(1, object.personID);
					request.object.save();
				} else {
					// Check what's the max for _User.
				    var query = new Parse.Query("_User");
				    query.descending("personID");
				    query.limit(1);
	  			  	// Lock table
				    Parse.Cloud.useMasterKey();	
				    Parse.Promise.as().then(function() {
				  	  return query.first().then(null, function(error) {
				  	    return Parse.Promise.error('Sorry there is no such item.');
				  	  });
				    }).then(function(result) {
				  	  if(!result) {
				  	  	console.log("An error occured");
				  	  }
				  	  else {
						 // Figure out what's the previous highest value.
				  		 var maxPersonID = result.get('personID');
						 // If it's the first item in the table set it's value to 0.
						 if(!maxPersonID) {
						 	maxPersonID = 0;
						 }
						 // Add proper changes to a personID field.
				  	  	 request.object.set("personID",maxPersonID+1);
						 request.object.save();
						 console.log("Object changed succesfully.");
				  	  }
				  });
			}
      	},
			error: function (error) {
				console.log(error);
		}}
  	);
    } else {
    	console.log(request.user);
    }
});


Parse.Cloud.define("leader", function(request, response) {
	
  Parse.Cloud.useMasterKey();	
	
  Parse.Promise.as().then(function() {
  var query = new Parse.Query(request.params.className);
  query.descending(request.params.columnName);
  query.limit(1);
  
	  return query.first().then(null, function(error) {
	    return Parse.Promise.error('Sorry there is no such item.');
	  });
  }).then(function(result) {
	  
	  if(!result)
	  {
	  	return Parse.Promise.error('We could not find any item');
	  }
	  else
	  {
		 var owner = result.get('owner');
	  	 response.success([owner,result.get(request.params.columnName)]);
	  }
  });
});

Parse.Cloud.job("userMigration", function(request, status) {
  // Set up to modify user data
  Parse.Cloud.useMasterKey();
  var counter = 0;
  // Query for all users
  var query = new Parse.Query(Parse.User);
  query.each(function(user) {
      // Update to plan value passed in
      user.set("plan", request.params.plan);
      if (counter % 100 === 0) {
        // Set the  job's progress status
        status.message(counter + " users processed.");
      }
      counter += 1;
      return user.save();
  }).then(function() {
    // Set the job's success status
    status.success("Migration completed successfully.");
  }, function(error) {
    // Set the job's error status
    status.error("Uh oh, something went wrong.");
  });
});
