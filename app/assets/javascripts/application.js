$(document).on('ajax:success', '.like-link', function(e, data, status, xhr){
    if(data.status === 'success') {
        $(this).text(`Likes: ${data.new_like_count}`);
    } else {
        alert(data.message);
    }
});
