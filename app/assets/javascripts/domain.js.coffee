$ ->
  oTable=$('#domains').DataTable
    pagingType : "full_numbers"
    processing: true
    serverSide: true
    Filter:true
    stateSave:true
    ajax: 
      url: $('#domains').data('source')
      type: 'POST'
   
    $('#haswebsite').change ->
     
      
      oTable.columns([8]).search($(this).val()).draw()
      return
      
    $('#source').change ->
     
      
      oTable.columns([9]).search($(this).val()).draw()
      return

    $('#domainending').change ->
     
      
      oTable.columns([1]).search($(this).val()).draw()
      return
      
    $('#endtime').change ->
     
      
      oTable.columns([7]).search($(this).val()).draw()
      return