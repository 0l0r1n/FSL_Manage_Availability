# My Availability Lightning Component for Field Service

### Motivation behind it

Salesforce released an exiciting product in 2016 called ['Field Service Lightning'](https://www.salesforce.com/products/service-cloud/features/field-service-lightning/)
FSL is missing a feature - the ability for technician to log their availability within the next weeks. This is not an issue for permanent employees, but definitely one for contractors who manage their own calendars.

### Installation instructions

#### Before you install

* This app uses the latest ES6 features. Please make sure your browser is [compatible with them](https://kangax.github.io/compat-table/es6/)
* Make sure you activate field service lightning in the [setup menu](https://help.salesforce.com/articleView?id=fs_enable.htm)

#### Setting up users

* Users must be setup as active field resources and have FSL Standard permissions. Please refer to [installation guide](https://help.salesforce.com/articleView?id=fs_set_up.htm) for more instructions on how to setup the basic permissions to get FSL up and running.
* remove users from territory memberships
* instead, add users to applicable territories

### Design

- This app takes advantage of the new OperatingHours in Salesforce. OperatingHours indicate the operating hours for a specific territory or territory member. This component adds one operating hours per week per user.
- Lightning Components are implemented using a redux based architecture where:
    - There is a single event with a payload and a type
    - A higher level component (ExpertManageAvailability) is concerned with how things work
    - All other components are concerned with how things look
    - Data is passed down
    - Actions are fired up and cause state mutations
