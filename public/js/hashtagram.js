// Funciones para Hashtagram


// Function via Jon Winstanley
// in Stackoverflow -> http://stackoverflow.com/questions/687998/auto-size-dynamic-text-to-fill-fixed-size-container
;(function($) {
    $.fn.textfill = function(options) {
        var fontSize = options.maxFontPixels;
        var ourText = $('span:visible:first', this);
        var maxHeight = $(this).height();
        var maxWidth = $(this).width();
        var textHeight;
        var textWidth;
        do {
            ourText.css('font-size', fontSize);
            textHeight = ourText.height();
            textWidth = ourText.width();
            fontSize = fontSize - 1;
        } while ((textHeight > maxHeight || textWidth > maxWidth) && fontSize > 3);
        return this;
    }
})(jQuery);

//cambiamos el estado que mandan en instagram
// ej: ChangeInfo('Algun texto');
function ChangeInfo(info){
	$(".hash_texto span").fadeOut(function() {
	  $(this).text(info).fadeIn();
	})
	return false;
}
// cambiamos la imagen de instagram
// ej: ChangeImage('./images/image2.jpg');
function ChangeImage(image){
	$(".hash_image").fadeOut(function() {
	  $(this).attr('src',image).fadeIn();
	})
	return false;
}

//cambiamos el usuario de instagram
// ej: ChangeUser('usuario');
function ChangeUser(user){
	$(".hash_user").fadeOut(function() {
	  $(this).text(user).fadeIn();
	})
	return false;
}
	
window.setInterval(get_one, 10000);

function get_one(){
	$.ajaxSetup({async: false});
	$.getScript(my_server + "/change_post.js");
	$.ajaxSetup({async: true});
}
