({
	removeSlot : function(cmp) {
    $A.get('e.c:LightningEvent', evt => {
      evt.setParams({
        type: 'REMOVE_SLOT',
        payload: {
          slotId : cmp.get('v.SlotId')
        }
      }).fire()
    })
	},
  updateSlot: function(cmp){
    $A.get('e.c:LightningEvent', evt => {
      evt.setParams({
        type: 'UDPATE_SLOT',
        payload: {
          slot: {
            DayOfWeek: cmp.find('dayOfWeek').get('v.value'),
            StartTime: cmp.find('startTime').get('v.value'),
            EndTime: cmp.find('endTime').get('v.value'),
            Id: cmp.get('v.SlotId')
          }
        }
      }).fire()
    })
  }
})