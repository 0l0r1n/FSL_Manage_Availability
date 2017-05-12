({
	init: function(cmp) {
    this.toggleSpinner(cmp)
    const thisWeek = this.getThisWeek()
    cmp.set('v.weekNumber', thisWeek)
    cmp.set('v.slots', this.getSlotsForWeek(cmp))
	},
  getSlotsForWeek: function (cmp){
    this.toggleSpinner(cmp)
    let action = cmp.get('c.getTimeSlotsForWeek')
    action.setParams({
      startOfWeek: this.convertWeekToDateTimeString(cmp.get('v.weekNumber'))
    })
    action.setCallback(this, (response) => {
      switch (response.getState()){
        case 'SUCCESS':
          const responseValue = response.getReturnValue()
          if (responseValue.length > 0)
            cmp.set('v.slots', responseValue)
          else
            cmp.set('v.slots', [])
          break
        case 'ERROR':
          this.showToast('error', $A.get('{!$Label.c.Generic_save_error_title}'), $A.get('{!$Label.c.Expert_error_user_not_configured}'))
          break
      }
      this.toggleSpinner(cmp)
    })
    $A.enqueueAction(action)
  },
  saveSlots: function(cmp){
    this.toggleSpinner(cmp)
    let action = cmp.get('c.saveSlotsForWeek')
    action.setParams({
      timeSlotWrappersString: JSON.stringify(cmp.get('v.slots')),
      startOfWeek: this.convertWeekToDateTimeString(cmp.get('v.weekNumber'))
    })
    action.setCallback(this, (response) => {
      switch (response.getState()){
        case 'SUCCESS':
          this.showToast('success', $A.get('{!$Label.c.Generic_Success}'), $A.get('{!$Label.c.Expert_Save_Slots_Success}'))
          break
        case 'ERROR':
          const errors = response.getError()
          this.showToast('error', $A.get('{!$Label.c.Generic_save_error_title}'),
                          errors[0] && errors.message ? errors[0].meessage : $A.get('{!$Label.c.Generic_unknown_error}'))
          break
      }
      this.toggleSpinner(cmp)
    })
    $A.enqueueAction(action)
  },
  generateDefaultWeekSlots: function(){
  this.showToast('info', $A.get('{!$Label.c.Expert_Default_slots_added}'), $A.get('{!$Label.c.Expert_Default_slots_added_message}'))
    return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
            .map(day => this.generateDefaultDaySlot(day))
  },
  generateDefaultDaySlot: function(day){
    return {
      DayOfWeek: day ? day : 'Monday',
      StartTime: '08:00',
      EndTime: '20:00',
      Id: uuid.v4()
    }
  },
	getThisWeek : function() {
    const week = moment().startOf('isoWeek')
		return `${week.format('YYYY')}-W${week.format('WW')}`
	},
  convertWeekToDateTimeString: function(weekNumber){
    return moment(weekNumber).startOf('isoWeek').format('DD/MM/YYYY')
  },
  showToast: function(type, title, message) {
    $A.get('e.force:showToast', evt => {
      evt.setParams({ type, title, message }).fire()
    })
  },
  toggleSpinner: function(cmp) {
    let spinner = cmp.find('spinner')
    $A.util.toggleClass(spinner, 'slds-hide')
  }
})