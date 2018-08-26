public class AnnouncementQueueable implements Queueable {
    
    public List<ConnectApi.AnnouncementInput> toPost;
    
    public void execute(QueueableContext queueableContext){
        PostAnnouncements(toPost);
    }
    
    public static void PostAnnouncements(List<ConnectApi.AnnouncementInput> announcements){
        while ( announcements.size() > 0 ){
            if ( Limits.getDMLStatements() < Limits.getLimitDMLStatements() && !test.isRunningTest() ){
                ConnectApi.AnnouncementInput a = announcements.remove(0);
                ConnectApi.Announcements.postAnnouncement('Internal', a);
            } else {
                break;
            }
        }
        if ( announcements.size() > 0 && !test.isRunningTest() ){
            AnnouncementQueueable q = new AnnouncementQueueable();
            q.toPost = announcements;
            
            System.enqueueJob(q);
        }
    }
    
}