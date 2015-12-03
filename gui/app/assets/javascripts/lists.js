$(function() { $('#list_edit').on('show.bs.modal', function (event) {
  var button = $(event.relatedTarget) // Button that triggered the modal
  var name = button.data('name') // Extract info from data-* attributes
  var modal = $(this)
  modal.find('.modal-body input').val(name)
})});