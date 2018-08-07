
package com.app.netdetect.ws;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Logger;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import javax.xml.ws.WebEndpoint;
import javax.xml.ws.WebServiceClient;
import javax.xml.ws.WebServiceFeature;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.1.6 in JDK 6
 * Generated source version: 2.1
 * 
 */
@WebServiceClient(name = "WebInterfaceService", targetNamespace = "http://ws.netdetect.app.com/", wsdlLocation = "http://127.0.0.1:8989/WS_Server?wsdl")
public class WebInterfaceService
    extends Service
{

    private final static URL WEBINTERFACESERVICE_WSDL_LOCATION;
    private final static Logger logger = Logger.getLogger(com.app.netdetect.ws.WebInterfaceService.class.getName());

    static {
        URL url = null;
        try {
            URL baseUrl;
            baseUrl = com.app.netdetect.ws.WebInterfaceService.class.getResource(".");
            url = new URL(baseUrl, "http://127.0.0.1:8989/WS_Server?wsdl");
        } catch (MalformedURLException e) {
            logger.warning("Failed to create URL for the wsdl Location: 'http://127.0.0.1:8989/WS_Server?wsdl', retrying as a local file");
            logger.warning(e.getMessage());
        }
        WEBINTERFACESERVICE_WSDL_LOCATION = url;
    }

    public WebInterfaceService(URL wsdlLocation, QName serviceName) {
        super(wsdlLocation, serviceName);
    }
    
    public WebInterfaceService(URL wsdlLocation) {
        super(wsdlLocation, new QName("http://ws.netdetect.app.com/", "WebInterfaceService"));
    }

    public WebInterfaceService() {
        super(WEBINTERFACESERVICE_WSDL_LOCATION, new QName("http://ws.netdetect.app.com/", "WebInterfaceService"));
    }

    /**
     * 
     * @return
     *     returns WebInterface
     */
    @WebEndpoint(name = "WebInterfacePort")
    public WebInterface getWebInterfacePort() {
        return super.getPort(new QName("http://ws.netdetect.app.com/", "WebInterfacePort"), WebInterface.class);
    }

    /**
     * 
     * @param features
     *     A list of {@link javax.xml.ws.WebServiceFeature} to configure on the proxy.  Supported features not in the <code>features</code> parameter will have their default values.
     * @return
     *     returns WebInterface
     */
    @WebEndpoint(name = "WebInterfacePort")
    public WebInterface getWebInterfacePort(WebServiceFeature... features) {
        return super.getPort(new QName("http://ws.netdetect.app.com/", "WebInterfacePort"), WebInterface.class, features);
    }

}
