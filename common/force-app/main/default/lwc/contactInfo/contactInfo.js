import { LightningElement, api, wire } from 'lwc';
import getSubjectFamilies from '@salesforce/apex/ChildProfileController.getSubjectFamilies';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = ['Contact.ChildName__c', 'Contact.Birthdate'];

export default class ContactInfo extends LightningElement {
    @api recordId;

    childName;
    birthdate;
    subjects = [];

    // 🔹 Contact 필드 불러오기
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredContact({ data, error }) {
        if (data) {
            this.childName = data.fields.ChildName__c.value;
            this.birthdate = data.fields.Birthdate.value;
        } else if (error) {
            console.error('Contact 필드 로딩 오류', error);
        }
    }

    // 🔹 듣는 과목 가져오기
    @wire(getSubjectFamilies, { contactId: '$recordId' })
    wiredSubjects({ data, error }) {
        if (data) {
            this.subjects = data;
        } else if (error) {
            console.error('과목 로딩 오류', error);
        }
    }

    get age() {
        if (!this.birthdate) return '';
        const birth = new Date(this.birthdate);
        const today = new Date();
        let age = today.getFullYear() - birth.getFullYear();
        const m = today.getMonth() - birth.getMonth();
        if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) {
            age--;
        }
        return age;
    }

    get subjectString() {
        return this.subjects.join(', ');
    }
}
