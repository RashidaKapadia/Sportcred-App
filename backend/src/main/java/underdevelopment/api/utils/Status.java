package underdevelopment.api.utils;

/**
 * Status codes
 * https://aloneonahill.com/blog/http-status-codes#:~:text=A%20403%20status%20code%20indicates,allow%20what%20was%20being%20asked.
 */
public class Status {

    // Client status
    public static final int OK = 200;
    public static final int BADREQUEST = 400;
    public static final int UNAUTHORIZED = 401;
    public static final int FORBIDDEN = 403;
    public static final int NOTFOUND = 404;
    public static final int NOT_ACCEPTABLE = 406;
    public static final int REQUEST_TIMEOUT = 408;
    public static final int CONFLICT = 409;

    // Server statuses
    public static final int SERVERERROR = 500;
    public static final int NOT_IMPLEMENTED = 501;
    public static final int HTTP_VERSION_NOT_SUPPORTED = 505;

}
