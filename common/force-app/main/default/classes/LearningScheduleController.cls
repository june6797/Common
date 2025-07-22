public with sharing class LearningScheduleController {
    
    @AuraEnabled
    public static void createEvents(
        Id contactId,
        Id productId,
        String weekday,
        Date startDate,
        Date repeatUntil,
        String startTime,
        String endTime,
        Boolean isRepeat
    ) {
        Contact child = [SELECT Id, TeacherId__c FROM Contact WHERE Id = :contactId LIMIT 1];
        Product2 course = [SELECT Name FROM Product2 WHERE Id = :productId LIMIT 1];

        List<Event> events = new List<Event>();
        Date currentDate = startDate;
        Date lastDate = isRepeat ? repeatUntil : startDate;

        // 🔧 시간 파싱
        List<String> startParts = startTime.split(':');
        Integer startHour = Integer.valueOf(startParts[0]);
        Integer startMin = Integer.valueOf(startParts[1]);

        List<String> endParts = endTime.split(':');
        Integer endHour = Integer.valueOf(endParts[0]);
        Integer endMin = Integer.valueOf(endParts[1]);

        while (currentDate <= lastDate) {
            DateTime tempDT = DateTime.newInstance(currentDate, Time.newInstance(0,0,0,0));
            String dayOfWeek = tempDT.format('EEEE');

            if (dayOfWeek == weekday) {
                DateTime startDT = DateTime.newInstance(currentDate, Time.newInstance(startHour, startMin, 0, 0));
                DateTime endDT = DateTime.newInstance(currentDate, Time.newInstance(endHour, endMin, 0, 0));

                events.add(new Event(
                    Subject = course.Name,
                    WhoId = child.Id,
                    OwnerId = child.TeacherId__c,
                    StartDateTime = startDT,
                    EndDateTime = endDT
                ));
            }
            currentDate = currentDate.addDays(1);
        }

        insert events;
    }

    // ✅ 과정명 콤보박스용 메서드
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getCourseOptions(Id contactId) {
        List<Subscription__c> subs = [
            SELECT ProductId__c, ProductId__r.Name
            FROM Subscription__c
            WHERE ContactId__c = :contactId
        ];

        List<Map<String, String>> options = new List<Map<String, String>>();
        for (Subscription__c s : subs) {
            if (s.ProductId__c != null && s.ProductId__r != null) {
                options.add(new Map<String, String>{
                    'label' => s.ProductId__r.Name,
                    'value' => s.ProductId__c
                });
            }
        }
        return options;
    }
}