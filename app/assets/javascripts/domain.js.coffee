$ ->
  oTable=$('#domains').DataTable
    pagingType : "full_numbers"
    processing: true
    serverSide: true
    Filter:true
    ajax: $('#domains').data('source')
   
    $('#haswebsite').change ->
     
      
      oTable.columns([8]).search($(this).val()).draw()
      return
    
   
     
  