({
	selectThisWeek : function() {
    $A.get('e.c:LightningEvent', evt => {
      evt.setParams({
        type: 'SELECT_THIS_WEEK'
      }).fire()
    })
	},
  changeWeek : function(cmp) {
    $A.get('e.c:LightningEvent', evt => {
      evt.setParams({
        type: 'CHANGE_WEEK',
        payload: {
          weekNumber: cmp.find('weekNumber').get('v.value')
        }
      }).fire()
    })
  }
})