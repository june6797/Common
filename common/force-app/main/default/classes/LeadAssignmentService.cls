public class LeadAssignmentService {
    public class UserScoreWrapper implements Comparable {
        public Id userId;
        public Decimal score;

        public UserScoreWrapper(Id userId, Decimal score) {
            this.userId = userId;
            this.score = score;
        }

        public Integer compareTo(Object o) {
            UserScoreWrapper other = (UserScoreWrapper)o;
            if (this.score == other.score) return 0;
            return (this.score > other.score) ? -1 : 1;
        }
    }

    public static void assignToQueueWithTopUsers(List<Lead> leads) {
        // Queue ID (정확한 Lead 전용 Queue ID 추출)
        Id queueId = [
            SELECT Queue.Id 
            FROM QueueSobject 
            WHERE SobjectType = 'Lead' AND Queue.Name = 'Lead_Queue' 
            LIMIT 1
        ].Queue.Id;

        // 방문교사 후보 추출
        List<User> candidates = [
            SELECT Id, Region_Zone__c, SubjectInCharge__c, HireDate__c
            FROM User
            WHERE UserRole.Name = '방문교사'
        ];

        Set<Id> candidateIds = new Set<Id>();
        for (User u : candidates) candidateIds.add(u.Id);

        // 현재 담당 리드 수
        Map<Id, Integer> userLeadCounts = new Map<Id, Integer>();
        AggregateResult[] results = [
            SELECT OwnerId, COUNT(Id) leadCount
            FROM Lead
            WHERE OwnerId IN :candidateIds AND Status != 'Closed'
            GROUP BY OwnerId
        ];
        for (AggregateResult ar : results) {
            userLeadCounts.put((Id)ar.get('OwnerId'), (Integer)ar.get('leadCount'));
        }

        // 리드별 추천 교사 계산
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead l : leads) {
            List<UserScoreWrapper> scoredUsers = new List<UserScoreWrapper>();

            for (User u : candidates) {
                Decimal score = 0;

                if (u.Region_Zone__c == l.State__c) score += 0.65;
                if (u.SubjectInCharge__c == l.InterestedSubject__c) score += 0.25;

                Integer leadCount = userLeadCounts.containsKey(u.Id) ? userLeadCounts.get(u.Id) : 0;
                Decimal leadScore = Math.max(0, 1 - (Decimal.valueOf(leadCount) / 10));
                score += leadScore * 0.06;

                if (u.HireDate__c != null) {
                    Long days = Date.today().daysBetween(u.HireDate__c);
                    Decimal hireScore = Math.max(0, 1 - (Decimal.valueOf(days) / 365));
                    score += hireScore * 0.05;
                }

                scoredUsers.add(new UserScoreWrapper(u.Id, score));
            }

            scoredUsers.sort();
            Integer topN = Math.max(1, Math.ceil(scoredUsers.size() * 0.1).intValue());
            List<Id> topUserIds = new List<Id>();
            for (Integer i = 0; i < topN; i++) {
                topUserIds.add(scoredUsers[i].userId);
            }

            // Lead 업데이트 준비
            leadsToUpdate.add(new Lead(
                Id = l.Id,
                //OwnerId = queueId,
                MultiRecommendedUsers__c = String.join(topUserIds, ';')
            ));
        }

        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
}