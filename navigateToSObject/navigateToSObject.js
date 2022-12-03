import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavigateToSObject extends NavigationMixin(LightningElement){
    // Navigate to New Account Page
    @api
    navigateToNewSObjectPage(ObjectName) {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: ObjectName,
                actionName: 'new'
            },
        });
    }

    // Navigate to View Account Page
    @api
    navigateToViewAccountPage(ObjectName, Id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: Id,
                objectApiName: ObjectName,
                actionName: 'view'
            },
        });
    }

    // Navigate to Edit Account Page
    @api
    navigateToEditAccountPage(ObjectName, Id) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: Id,
                objectApiName: ObjectName,
                actionName: 'edit'
            },
        });
    }
    // Navigation to Account List view(recent)
    @api
    navigateToAccountListView(ObjectName) {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: ObjectName,
                actionName: 'list'
            },
            state: {
                filterName: 'Recent'
            },
        });
    }

    @api
    navigateToViewSObjPageInNewTab(recId,objectName){
        console.log(recId, objectName);

        this[NavigationMixin.GenerateUrl]({
            type: "standard__recordPage",
            attributes: {
                recordId: recId,
                objectApiName: objectName,
                actionName: 'view'
            }
        }).then(url => {
            window.open(url, "_blank");
        });
    }
}