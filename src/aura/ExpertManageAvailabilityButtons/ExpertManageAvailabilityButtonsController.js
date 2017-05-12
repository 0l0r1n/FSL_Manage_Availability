({
	addSlot : function() {
    $A.get('e.c:LightningEvent', evt => {
			evt.setParams({
	      type: 'ADD_SLOT'
	    }).fire()
		})
  },
	addDefaultSlots: function() {
		$A.get('e.c:LightningEvent', evt => {
			evt.setParams({
	      type: 'ADD_DEFAULT_SLOTS'
	    }).fire()
		})
  },
	saveSlots : function() {
		$A.get('e.c:LightningEvent', evt => {
			evt.setParams({
	      type: 'SAVE_SLOTS'
	    }).fire()
		})
	}
})