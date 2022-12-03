import { LightningElement, track, api, wire } from 'lwc';



export default class CreateOpportunity extends LightningElement {

    @api recordId;
    @api fieldset;

    @track fields;
    @track error;
    @track value = 'Account';
    @track objectName;
    @api popupOpen  = false;
    @track fieldSetName;
    @track showTable = false;

    get options() {
        return [
                    { label: 'Account', value: 'Account' },
                    { label: 'Contact', value: 'Contact' },
                    { label: 'Opportunity', value: 'Opportunity' },
                ];
    }


    handleChange(event){
        this.value = event.detail.value;
        console.log('this value ' + this.value);
        this.objectName = this.value;
        this.showTable = true;

        if(this.objectName == 'Account'){
            this.fieldSetName = 'AccountFields';
        }else if(this.objectName == 'Contact'){ 
            this.fieldSetName = 'ContactFields';
        }else if(this.objectName == 'Opportunity'){
            this.fieldSetName = 'opportunityFields';
        }


        console.log('------------> '+this.fieldSetName);

       this.template.querySelector('c-show-data-table').changeDataTable(this.objectName,this.fieldSetName);
    }

    openModal(){
        this.popupOpen = true;
    }

    closeModal(){
        this.popupOpen = false;
    }





}