//= require admin/jquery.tagsinput
//= require admin/jquery.markitup

bbcodeEditorButtons = {
  nameSpace: "bbcode", // Useful to prevent multi-instances CSS conflict
  markupSet: [
    {name:'Bold', key:'B', openWith:'[b]', closeWith:'[/b]'},
    {name:'Italic', key:'I', openWith:'[i]', closeWith:'[/i]'},
    {name:'Underline', key:'U', openWith:'[u]', closeWith:'[/u]'},
    {name:'Strike-Through', key:'S', openWith:'[s]', closeWith:'[/s]'},
    {separator:'|' },
    {name:'Bulleted list', openWith:'[ul]\n', closeWith:'\n[/ul]'},
    {name:'Numeric list', openWith:'[ol]\n', closeWith:'\n[/ol]'},
    {name:'List item', openWith:'[li]', closeWith:'[/li]'},
    {separator:'|' },
    {name:'Image', replaceWith:'[img][![Source]!][/img]'},
    {name:'Link', openWith:'[url=[![Link]!]]', closeWith:'[/url]', placeHolder:'Your text to link here...'},
    {separator:'|' },
    {name:'Quote', openWith:'[quote]', closeWith:'[/quote]'},
  ]
}

$(document).ready(function(){
  $('.bbcode-editor').markItUp(bbcodeEditorButtons);
});
