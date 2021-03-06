$ ->
  $('#encrypt-button').click ->
    return if !validateEncryptForm()
    $('#share-link').val(encryptMessage)
    switchPanes '#pane1', '#pane2'
    $('#share-link').select()
    $('#share-link').click ->
      $(@).select()

  $('#decrypt-button').click ->
    switchPanes '#pane1', '#pane2'
    if !validateDecryptForm()
      switchPanes '#pane2', '#pane1'
      return
    # timer for intentional suspense
    setTimeout(displayDecryptedMessage, 2000)

displayDecryptedMessage = ->
  message = decryptMessage()
  if message == ""
    switchPanes '#pane2', '#pane1'
    addErrorMessage '#secret-message', 'Incorrect key'
  else
    switchPanes '#pane2', '#pane3'
    $('#secret-message').append(message)

validateDecryptForm = ->
  removeErrors()
  errorMessages =
    '#secret-key-input': 'You must enter your secret key'
  return validateFields(errorMessages)

validateEncryptForm = ->
  removeErrors()
  errorMessages =
    '#message-area': 'You must enter a message'
    '#secret-key-input': 'You must enter a secret key'
  return validateFields(errorMessages)

validateFields = (errorMessages) ->
  for fieldName of errorMessages
    if $(fieldName).val() == ''
      addErrorMessage fieldName, errorMessages[fieldName]
      return false
  true

switchPanes = (pane1, pane2) ->
  $(pane1).hide()
  $(pane2).show()

removeErrors = ->
  $('.error p').remove()
  $('.error').children().unwrap()

addErrorMessage = (field, message) ->
  $(field).wrap( $('<div>').addClass('error') )
  $(field).parent().prepend( $('<p>').append(message) )

encryptMessage = ->
  message = $('#message-area').val()
  key = $('#secret-key-input').val()

  window.location.origin + '/decode.html?key=' + encryptor.encrypt(message, key)

decryptMessage = ->
  key = $('#secret-key-input').val()

  startOfCypher = window.location.href.indexOf('=') + 1
  cypher = window.location.href[startOfCypher..]

  encryptor.decrypt(cypher, key)
