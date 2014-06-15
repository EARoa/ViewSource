//
//  Action.js
//  ViewSourceExt
//
//  Created by Dominic Dagradi on 6/14/14.
//  Copyright (c) 2014 ddagradi. All rights reserved.
//

var Action = function() {};

Action.prototype = {

    run: function(arguments) {},
    
    finalize: function(arguments) {
        var source  = document.documentElement.outerHTML;
        var text    = document.createTextNode( source );

        // Clear document
        document.write("<pre></pre>");

        // Append source in pre tag
        document.getElementsByTagName("pre")[0].appendChild(text);
    }
    
};
    
var ExtensionPreprocessingJS = new Action
