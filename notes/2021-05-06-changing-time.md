---
title: changing time
---
<script src="/assets/javascript/jquery-1.10.2.min.js"></script> 
<script src="/assets/javascript/handlebars.js"></script>
<script src="/assets/javascript/copyToClicpboard.js"></script>
<script src="/assets/javascript/my-script.js"></script>


<div id="my-container" class="table-responsive"> 
<script id="template" type="text/x-handlebars-template"> 
{{#each elements}} 
<button onclick="CopyToClipboard('{{ this.Passcode }}','{{ this.Link }}')">{{ this.Date }} {{ this.Time }}</button> 
{{/each}} 
</script> 
</div>

# hello 