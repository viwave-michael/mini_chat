# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

source = new EventSource('/comments')

source.onmessage = (event) ->
  console.log event.data
  comment_template = _.template($('#comment_temp').html())
  comment = $.parseJSON(event.data)
  if comment
    $('#comments').find('.media-list').prepend(comment_template({
      body: comment['body']
      user_name: comment['user_name']
      user_avatar: comment['user_avatar']
      user_profile: comment['user_profile']
      timestamp: comment['timestamp']
    }))

jQuery ->
  $('#new_comment').submit ->
    $(this).find("input[type='submit']").val('Sending...').prop('disabled', true)