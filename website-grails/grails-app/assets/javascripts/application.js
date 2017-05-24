// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better
// to create separate JavaScript files as needed.
//
//= require jquery-2.2.0.min
//= require bootstrap
//= require_tree .
//= require_self

if (typeof jQuery !== 'undefined') {
    (function($) {
        $(document).ajaxStart(function() {
            $('#spinner').fadeIn();
        }).ajaxStop(function() {
            $('#spinner').fadeOut();
        });
    })(jQuery);
}



$('#demo').jstree({ 'core' : {
    'data' : [
       { "id" : "ajson1", "parent" : "#", "text" : "benchmark_datasets" },
       { "id" : "ajson3", "parent" : "ajson1", "text" : "Oxfam-v1.0" },

       { "id" : "ajson5", "parent" : "ajson1", "text" : "Balibase-v4.0" },
       { "id" : "ajson4", "parent" : "ajson5", "text" : "BB11001.xml.ref" },
       { "id" : "ajson6", "parent" : "ajson5", "text" : "BB11001.fa.test" },
       { "id" : "ajson7", "parent" : "ajson3", "text" : "6.fa.ref" },
       { "id" : "ajson8", "parent" : "ajson3", "text" : "6.fa.test" },
    ]
} });
