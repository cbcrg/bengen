/**
 * Simple decision tree parser and traversal.
 * @author njmcode
 * @param data - object {
 *     initial: [], (list of choice IDs for the root node)
 *     choices: {}  (keyed object of all possible choices)
 * }
 *
 * Adapted and modified by the BenGen Authors
**/





var index = -1;
var results = [];



/** TREE DEFINITION - only part to be modified **/

var data = {
  initial: ['method', 'scoring function'],
  choices: {

    // TOP LEVEL

    'method': {
      name: 'method',
      label: 'Type',
      children:['TBMsa', 'SBMsa', 'GeneralMsa']
    },


    'scoring function': {
      name: 'scoring function',
      label: 'Type',
      children: ['sequence alignment (protein)', 'sequence alignment (nucleic acid)']
    },

//SF

      //INPUT
    'sequence alignment (protein)': {
      name: 'sequence alignment (protein)',
      label: 'Input',
      children: ['fasta-alnP', 'xmlP']
    },
    'sequence alignment (nucleic acid)': {
      name: 'sequence alignment (nucleic acid)',
      label: 'Input',
      children: ['fasta-alnNA', 'xmlNA']
    },

    //INPUT FORMAT


    'fasta-alnP': {
      name: 'fasta-aln',
      label: 'Format',

   },

    'xmlP': {
      name: 'xml',
      label: 'Format',

    },

    'fasta-alnNA': {
      name: 'fasta-aln',
      label: 'Format',

   },

    'xmlNA': {
      name: 'xml',
      label: 'Format'
    },


    'TBMsa': {
      name: 'Tree-Based Multiple Sequence Aligner',
      label: 'Multiple Sequence Aligner',
      children:['proteinTBMSA-small','NATBMSA-small','bothTBMSA-small','proteinTBMSA-big','NATBMSA-big','bothTBMSA-big']
    },


    'SBMsa': {
      name: 'Structure-Based Multiple Sequence Aligner',
      label: 'Multiple Sequence Aligner',
      children:['proteinSMSA-small','NASMSA-small','bothSMSA-small','proteinSMSA-big','NASMSA-big','bothSMSA-big']

    },
    'GeneralMsa': {
      name: 'None of the previous ones',
      label: 'Multiple Sequence Aligner',
      children:['proteinGMSA-small','NAGMSA-small','bothGMSA-small','proteinGMSA-big','NAGMSA-big','bothGMSA-big']
    },


//Input

  'proteinTBMSA-small': {
    name: 'Small Set of protein Sequences',
    label: 'Input',
//    children:['MaxCountTBP']
  },
  'proteinTBMSA-big': {
    name: 'Big Set of protein Sequences',
    label: 'Input',
//    children:['MaxCountTBP']
  },
  'NATBMSA-small': {
    name: 'Small Set of Nucleic Acid Sequences',
    label: 'Input',
  //  children:['MaxCountTBN']
  },
  'NATBMSA-big': {
    name: 'Big Set of Nucleic Acid Sequences',
    label: 'Input',
  //  children:['MaxCountTBN']
  },
  'bothTBMSA-small': {
    name: 'Both of the previous ones (small set)',
    label: 'Input',
  //  children:['MaxCountTBB']
  },
  'bothTBMSA-big': {
    name: 'Both of the previous ones (big set)',
    label: 'Input',
  //  children:['MaxCountTBB']
  },

  'proteinGMSA-small': {
  name: 'Small Set of protein Sequences',
  label: 'Input',
  // children:['MaxCountGP']
  },
  'proteinGMSA-big': {
  name: 'Big Set of protein Sequences',
  label: 'Input',
  // children:['MaxCountGP']
  },
  'NAGMSA-small': {
  name: 'Small Set of Nucleic Acid Sequences',
  label: 'Input',
  // children:['MaxCountGN']
  },
  'NAGMSA-big': {
  name: 'Big Set of Nucleic Acid Sequences',
  label: 'Input',
  // children:['MaxCountGN']
  },
  'bothGMSA-small': {
  name: 'Both of the previous ones (small set)',
  label: 'Input',
  // children:['MaxCountGB']
  },
  'bothGMSA-big': {
  name: 'Both of the previous ones (big set)',
  label: 'Input',
  // children:['MaxCountGB']
  },
  'proteinSMSA-small': {
name: 'Small Set of protein Sequences',
label: 'Input',
// children:['MaxCountSP']
},
'proteinSMSA-big': {
name: 'Big Set of protein Sequences',
label: 'Input',
// children:['MaxCountSP']
},
'NASMSA-small': {
name: 'Small Set of Nucleic Acid Sequences',
label: 'Input',
// children:['MaxCountSN']
},
'NASMSA-big': {
name: 'Big Set of Nucleic Acid Sequences',
label: 'Input',
// children:['MaxCountSN']
},
'bothSMSA-small': {
name: 'Both of the previous ones (small set)',
label: 'Input',
// children:['MaxCountSB']
},
'bothSMSA-big': {
name: 'Both of the previous ones (big set)',
label: 'Input',
// children:['MaxCountSB']
},
  }
};

/** TREE DEFINITION - only part to be modified **/







var DecisionTree = function(data) {

  this.initial = data.initial;
  this.choices = data.choices;

  /* Return an array of choice objects for the root of the tree */
  this.getInitial = function() {

    if (!this.initial) throw 'DecisionTree: no initial choice(s) specified';
    return this.getChoices(this.initial);

  };

  /* Get full choice data by specific id */
  this.getChoice = function(id) {

    if (!(id in this.choices)) return false;
    if (!('id' in this.choices[id])) this.choices[id].id = id;
    return this.choices[id];

  };

  /* As above, but passing an array of choice IDs */
  this.getChoices = function(idList) {
    if(!idList) return [];
    var list = [];
    for(var i = 0, ln = idList.length; i < ln; i++) {
      var childChoice = this.getChoice(idList[i]);
      list.push(childChoice);
    }
    return list;

  };

  /* Get an array of choice data for a parent id */
  this.getChildren = function(parentId) {

    if (!(parentId in this.choices)) return false;
    if (!('children' in this.choices[parentId])) return false;

    var childIds = this.choices[parentId].children;
    return this.getChoices(childIds);

  };

  /* Get an array of choice data for the parent(s) of an id */
  this.getParents = function(id) {

    var parents = [];
    var node = this.getChoice(id);

    while(node.parent) {
      node = this.getChoice(node.parent);
      parents.unshift(node);
    }

    return parents;

  };

  /* Get just an array of ids for the parents of a specific id */
  this.getParentIds = function(id) {
    var parents = this.getParents(id);
    var parentIds = [];
    for(var i = 0, ln = parents.length; i < ln; i++) {
      parentIds.push(parents[i].id);
    }
    return parentIds;
  };

  /* Get the 'name' prop for the parent of an id */
  this.getParentName = function(id) {
    var parent = this.getParents(id).pop();
    if(!parent) {
      return false;
    } else {
      return parent.name;
    }
  };

  /* Init - insert ids into choice objects, check dups, associate parents, etc */
  this.init = function() {

    var idList = [];
    for(var k in this.choices) {
      if(idList.indexOf(k) !== -1) throw 'DecisionTree: duplicate ID "' + k + '" in choice set';

      var choice = this.getChoice(k);
      choice.id = k;

      var children = this.getChildren(k);
      for(var i = 0; i < children.length; i++) {

        var child = children[i];
        if(child.parent) throw 'DecisionTree: tried to assign parent "' + k + '" to child "' + choice.children[i] + '" which already has parent "' + child.parent + '"';
        child.parent = k;

      }

    }

    console.log('init', this.initial, this.choices);

  };

  this.init();

};




$(function() {

  var tree = new DecisionTree(data);
  var $list = $('#choices');
  var $title = $('.tree');

  var current_id = null;

  var renderList = function(items) {

    var title = (items[0].label);
    if(title) {
      $title.text(title);
    } else {
      $title.text('Select the appropriate answer');
    }

    $list.empty();
    for(var i = 0; i < items.length; i++) {
      var item = items[i];
      $list.append('<a id="dectree" href="#" data-choice="' + item.id + '">' + item.name + '</a><br>');

    }



  };

  var _doInitial = function() {
      var initData = tree.getInitial();
      current_id = null;
      renderList(initData);
  };

  $(document).on('click', '#choices a', function(e) {
    e.preventDefault();
    index++;
    results=results+","+$(this).data('choice')
    var choiceId = $(this).data('choice');
    console.log('clicked', choiceId);

    var kids = tree.getChildren(choiceId);
    if(kids) {
      current_id = choiceId;
      renderList(kids);

    }else{

       $("#hideshow").show();
      kids=['ready']
      renderLists(kids);




    }
  });

  $('#back').on('click', function(e) {
    e.preventDefault();
    $("#hideshow").hide();
    if(!current_id) return false;
    console.log('back button clicked', current_id);
    index=index-1;

    var parents = tree.getParents(current_id);

    if(parents.length > 0) {
      var prev_node = parents.pop();
      current_id = prev_node.id;
      renderList(tree.getChildren(prev_node.id));
    } else {
      _doInitial();
    }

  });

  $("#btn-save").click( function() {

    var text ;
    for(var j = 0; j <results.length; j++) {

        text=""+text+","+results[j];

    }

  var filename = $("file").val();
  var blob = new Blob([text], {type: "text/plain;charset=utf-8"});
  saveAs(blob, filename+".txt");
  });



  jQuery(function () {

$("#first").css({"display":"none"}); $("#decisiontree").show();


      jQuery("[name='jftForm']").submit(function () {
          jQuery("[name='ret']").val(results);
      });
  });

  $('#go').on('click', function(e) {
    e.preventDefault();



    var cid = $('#show-id').val();
    if(!cid || !(cid in data,choices)) return false;
    console.log('show parents for', cid);

    var parentData = tree.getParents(cid);
    $('#results').val(JSON.stringify(parentData, null, 4));





  });



  _doInitial();


});
