$(function () {
    // Reference the auto-generated proxy for the hub.
    var chat = $.connection.chatHub;

    // Create a function that the hub can call back to display messages.
    chat.client.broadcastMessage = function (senderId, message, time) {
        // Add the message to the page.
        // hide placeholder when first real message arrives
        $('#messagesPlaceholder').hide();
        $('#discussion').append('<li><strong>' + htmlEncode(senderId)
            + '</strong>: ' + htmlEncode(message) + ' <small>' + htmlEncode(time) + '</small></li>');
    };

    // Set initial focus to message input box.
    $('#message').focus();

    // Start the connection.
    $.connection.hub.start().done(function () {
        $('#sendmessage').click(function () {
            var msg = $('#message').val();
            var sid = parseInt($('#senderid').val());
            if (msg.trim() !== "" && !isNaN(sid)) {
                // Call the Send method on the hub.
                chat.server.sendMessage(sid, null, msg);
                // Clear text box and reset focus for next message.
                $('#message').val('').focus();
            }
        });
    });
});

// This optional function html-encodes messages for display in the page.
function htmlEncode(value) {
    var encodedValue = $('<div />').text(value).html();
    return encodedValue;
}
