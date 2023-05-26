public class OnLoadController {

    public String Page {get; set;}
    public String OpenPageURL {get; set;}
    
    public void OnLoadController()
    {
        Page = '' ;
        OpenPageURL = '' ;
    }
    
    public PageReference redirect()
    {
        if(Page == 'google')
        {
            OpenPageURL = 'https://forms.office.com/Pages/ResponsePage.aspx?id=qJYe29qjKkSTCyNcrCTNXJT8NoQHwMtDvm6Dmy2qTpNUODZNT0ozMk8yRElFVkNJR0xKTDhNSFE5Ny4u';

        }
        return null;
    }

}