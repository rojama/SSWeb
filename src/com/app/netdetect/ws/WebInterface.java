
package com.app.netdetect.ws;

import java.util.List;
import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.ws.RequestWrapper;
import javax.xml.ws.ResponseWrapper;


/**
 * This class was generated by the JAX-WS RI.
 * JAX-WS RI 2.1.6 in JDK 6
 * Generated source version: 2.1
 * 
 */
@WebService(name = "WebInterface", targetNamespace = "http://ws.netdetect.app.com/")
@XmlSeeAlso({
    ObjectFactory.class
})
public interface WebInterface {


    /**
     * 
     * @param arg1
     * @param arg0
     * @return
     *     returns java.lang.String
     */
    @WebMethod
    @WebResult(targetNamespace = "")
    @RequestWrapper(localName = "processCode", targetNamespace = "http://ws.netdetect.app.com/", className = "com.app.netdetect.ws.ProcessCode")
    @ResponseWrapper(localName = "processCodeResponse", targetNamespace = "http://ws.netdetect.app.com/", className = "com.app.netdetect.ws.ProcessCodeResponse")
    public String processCode(
        @WebParam(name = "arg0", targetNamespace = "")
        String arg0,
        @WebParam(name = "arg1", targetNamespace = "")
        List<String> arg1);

}
