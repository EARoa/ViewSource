'use strict';

//
//  Action.js
//  ViewSourceExt
//
//  Created by Dominic Dagradi on 6/14/14.
//  Copyright (c) 2014 ddagradi. All rights reserved.
//

var Action = function() {};

Action.prototype = {
  
  run: function(args) {},
    
  finalize: function(args) {
    var script  = document.createElement( 'script' ),
        style   = document.createElement( 'style' ),
        source  = document.createTextNode( document.documentElement.outerHTML );
    
    script.type = "text/javascript";
    script.appendChild(document.createTextNode(args.script));
    script.appendChild(document.createTextNode("; Rainbow.color()"));

    style.type = 'text/css'
    style.innerHTML = args.style;
    
    // Clear document
    document.write("<pre><code id='pageSource' data-language='html'></code></pre>");
    
    // Append source in pre tag
    document.getElementById("pageSource").appendChild(source);

    // Add scripts and styles
    document.head.appendChild(style);
    document.head.appendChild(script);
  }
  
};

var ExtensionPreprocessingJS = new Action();