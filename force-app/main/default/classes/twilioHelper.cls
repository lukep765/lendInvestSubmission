import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

public with sharing class twilioHelper {
    public static final String ACCOUNT_SID = System.getenv('TWILIO_ACCOUNT_SID');
    public static final String AUTH_TOKEN = System.getenv('TWILIO_AUTH_TOKEN');

    public twilioHelper() {

    }
}
