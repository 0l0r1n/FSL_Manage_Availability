({
	doInit : function(cmp) {
		let action = cmp.get('c.getTickets')
    action.setCallback(this, response => {
      cmp.set('v.tickets', response.getReturnValue())
    })
    $A.enqueueAction(action)
	}
})