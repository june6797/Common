public with sharing class QuoteToPDFSender {

    public class PDFRequest {
        @InvocableVariable(required=true)
        public Id quoteId;
    }

    public class PDFResult {
        @InvocableVariable
        public String status;
    }

    @InvocableMethod(label='Generate PDF and Send Email')
    public static List<PDFResult> sendPDF(List<PDFRequest> requests) {
        List<PDFResult> results = new List<PDFResult>();

        for (PDFRequest req : requests) {
            PDFResult res = new PDFResult();

            try {
                Quote q = [
                    SELECT Id, Name, Email, AccountName__c, ChildName__c
                    FROM Quote WHERE Id = :req.quoteId LIMIT 1
                ];

                PageReference pdfPage = Page.QuotePDFPage;
                pdfPage.getParameters().put('id', q.Id);
                Blob pdfBody = pdfPage.getContent();

                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName('견적서_' + q.Name + '.pdf');
                attachment.setBody(pdfBody);
                attachment.setContentType('application/pdf');

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { q.Email });
                mail.setSubject('커몬학습 견적서 - ' + q.Name);
                mail.setPlainTextBody('안녕하세요, 커몬학습입니다.\n첨부된 견적서를 확인해주세요.');
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                res.status = '성공: ' + q.Email + ' 로 전송됨';
            } catch (Exception e) {
                res.status = '실패: ' + e.getMessage();
            }

            results.add(res);
        }

        return results;
    }
}