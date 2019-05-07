$('.picture').bind('change', function(e){
  var size_in_megabytes = e.target.files[0].size/1024/1024;
  if (size_in_megabytes > 5){
    alert(I18n.t('message.micropost.max_size'));
  }
});
