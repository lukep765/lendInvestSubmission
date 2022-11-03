import { LightningElement,api,wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';

const fields = [PHONE_FIELD];

export default class SendSMS extends LightningElement {
    @api recordId;
    disabled = false;


    @wire(getRecord, { recordId: '$recordId', fields})
    account;
    
    get phone() {
        return getFieldValue(this.account.data,PHONE_FIELD);
    }

    //If phone field has not value. Disable send button and text area. 
    renderedCallback(){
        console.log(this.phone)
        if(this.phone == null || this.phone == 'undefined' ||this.phone == ''){
            this.disabled = true;
        }
        else{
            this.disabled = false;
        }
    }

    handleSend(event){
        //Invoke SMS apex method here..
    }
}