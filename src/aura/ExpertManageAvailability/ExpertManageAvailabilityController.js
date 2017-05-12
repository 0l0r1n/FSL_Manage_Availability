({
	doInit : function(cmp, evt, helper) {
    helper.init(cmp)
	},
  handleEvent: function(cmp, evt, helper){
    const type = evt.getParam('type')
    const payload = evt.getParam('payload')
    const slots = cmp.get('v.slots')
    switch (type){
      case 'ADD_SLOT':
        const newSlot =  helper.generateDefaultDaySlot()
        cmp.set('v.slots', [...slots, newSlot])
        break
      case 'REMOVE_SLOT':
        cmp.set('v.slots', slots.filter(slot => slot.Id !== payload.slotId))
        break
      case 'UDPATE_SLOT':
        cmp.set('v.slots', slots.map(slot => {
          if (slot.Id === payload.slot.Id)
            return payload.slot
          return slot
        }))
        break
      case 'ADD_DEFAULT_SLOTS':
        cmp.set('v.slots', helper.generateDefaultWeekSlots())
        break
      case 'SAVE_SLOTS':
        helper.saveSlots(cmp)
        break
			case 'SELECT_THIS_WEEK':
        cmp.set('v.weekNumber', helper.getThisWeek())
        helper.getSlotsForWeek(cmp)
				break
      case 'CHANGE_WEEK':
        const weekNumber = payload.weekNumber
        cmp.set('v.weekNumber', weekNumber)
        helper.getSlotsForWeek(cmp)
        break
    }
    evt.stopPropagation()
  }
})