import { LightningElement, api, track } from 'lwc';
import createEvents from '@salesforce/apex/LearningScheduleController.createEvents';
import getCourseOptions from '@salesforce/apex/LearningScheduleController.getCourseOptions';

export default class LearningScheduleForm extends LightningElement {
    @api recordId;

    @track selectedProduct = '';
    @track selectedWeekday = '';
    @track startDate = '';
    @track startTime = '';
    @track endTime = '';
    @track repeatUntil = '';
    @track isRepeat = false;

        @track productOptions = []; // 콤보박스에 바인딩될 옵션

    connectedCallback() {
        getCourseOptions({ contactId: this.recordId })
            .then(data => {
                this.productOptions = data;
            })
            .catch(error => {
                console.error('과정명 불러오기 오류:', error);
            });
    }

    weekdayOptions = [
        { label: '월요일', value: 'Monday' },
        { label: '화요일', value: 'Tuesday' },
        { label: '수요일', value: 'Wednesday' },
        { label: '목요일', value: 'Thursday' },
        { label: '금요일', value: 'Friday' }
    ];

    timeOptions = [
        '09:00', '09:30', '10:00', '10:30',
        '11:00', '11:30', '12:00', '12:30',
        '13:00', '13:30', '14:00', '14:30',
        '15:00', '15:30', '16:00', '16:30',
        '17:00', '17:30', '18:00', '18:30',
        '19:00', '19:30', '20:00', '20:30',
        '21:00', '21:30', '22:00', '22:30'
    ].map(t => ({ label: t, value: t }));

    handleProductChange(e) { this.selectedProduct = e.detail.value; }
    handleWeekdayChange(e) { this.selectedWeekday = e.detail.value; }
    handleStartDate(e) { this.startDate = e.detail.value; }
    handleStartTime(e) { this.startTime = e.detail.value; }
    handleEndTime(e) { this.endTime = e.detail.value; }
    handleRepeatUntil(e) { this.repeatUntil = e.detail.value; }
    toggleRepeat(e) { this.isRepeat = e.target.checked; }

    createSchedule() {
        createEvents({
            contactId: this.recordId,
            productId: this.selectedProduct,
            weekday: this.selectedWeekday,
            startDate: this.startDate,
            repeatUntil: this.repeatUntil,
            startTime: this.startTime,
            endTime: this.endTime,
            isRepeat: this.isRepeat
        }).then(() => {
            alert('일정 생성 완료');
        }).catch(error => {
            console.error(error);
        });
    }
}