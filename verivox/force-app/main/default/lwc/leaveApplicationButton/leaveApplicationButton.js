import { LightningElement, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import leave_Object from '@salesforce/schema/Leave__c';


export default class LeaveApplicationButton extends LightningElement {
    objectApiName = leave_Object;

    handleSuccess(event) {
        console.log('Inside onsuccess event record-edit-form', event.detail.id);
        const evt = new ShowToastEvent({
            title : 'Success',
            message: 'Leave Application Saved Successfully',
            variant: 'Success'
        });
        this.dispatchEvent(evt);
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        
    }
    handleError(event){
        console.log('Inside onerror event record-edit-form', event.detail.id);
        const evt = new ShowToastEvent({
            title : 'Error',
            message: 'Error',
            variant: 'Error'
        });
        this.dispatchEvent(evt);

    }


}