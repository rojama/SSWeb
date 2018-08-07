
package com.app.netdetect.ws;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the com.app.netdetect.ws package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _ProcessCode_QNAME = new QName("http://ws.netdetect.app.com/", "processCode");
    private final static QName _ProcessCodeResponse_QNAME = new QName("http://ws.netdetect.app.com/", "processCodeResponse");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: com.app.netdetect.ws
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link ProcessCode }
     * 
     */
    public ProcessCode createProcessCode() {
        return new ProcessCode();
    }

    /**
     * Create an instance of {@link ProcessCodeResponse }
     * 
     */
    public ProcessCodeResponse createProcessCodeResponse() {
        return new ProcessCodeResponse();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ProcessCode }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ws.netdetect.app.com/", name = "processCode")
    public JAXBElement<ProcessCode> createProcessCode(ProcessCode value) {
        return new JAXBElement<ProcessCode>(_ProcessCode_QNAME, ProcessCode.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link ProcessCodeResponse }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ws.netdetect.app.com/", name = "processCodeResponse")
    public JAXBElement<ProcessCodeResponse> createProcessCodeResponse(ProcessCodeResponse value) {
        return new JAXBElement<ProcessCodeResponse>(_ProcessCodeResponse_QNAME, ProcessCodeResponse.class, null, value);
    }

}
