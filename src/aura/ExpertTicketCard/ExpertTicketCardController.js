({
	goToRecord : function (cmp) {
    let navEvt = $A.get("e.force:navigateToSObject")
    navEvt.setParams({
      "recordId": cmp.get('v.ticket').recordId
    })
    navEvt.fire()
  }
})