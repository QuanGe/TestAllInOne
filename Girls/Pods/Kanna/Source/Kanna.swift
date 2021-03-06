/**@file Kanna.swift

Kanna

Copyright (c) 2015 Atsushi Kiwaki (@_tid_)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
import Foundation

/*
ParseOption
*/
public enum ParseOption {
    // libxml2
    case xmlParseUseLibxml(Libxml2XMLParserOptions)
    case htmlParseUseLibxml(Libxml2HTMLParserOptions)
}

private let kDefaultXmlParseOption   = ParseOption.xmlParseUseLibxml([.RECOVER, .NOERROR, .NOWARNING])
private let kDefaultHtmlParseOption  = ParseOption.htmlParseUseLibxml([.RECOVER, .NOERROR, .NOWARNING])

/**
Parse XML

@param xml      an XML string
@param url      the base URL to use for the document
@param encoding the document encoding
@param options  a ParserOption
*/
public func XML(xml: String, url: String?, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) -> XMLDocument? {
    switch option {
    case .xmlParseUseLibxml(let opt):
        return libxmlXMLDocument(xml: xml, url: url, encoding: encoding, option: opt.rawValue)
    default:
        return nil
    }
}

public func XML(xml: String, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) -> XMLDocument? {
    return XML(xml: xml, url: nil, encoding: encoding, option: option)
}

// NSData
public func XML(xml: Data, url: String?, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) -> XMLDocument? {
    if let xmlStr = NSString(data: xml, encoding: encoding) as? String {
        return XML(xml: xmlStr, url: url, encoding: encoding, option: option)
    }
    return nil
}

public func XML(xml: Data, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) -> XMLDocument? {
    return XML(xml: xml, url: nil, encoding: encoding, option: option)
}

// NSURL
public func XML(url: URL, encoding: UInt, option: ParseOption = kDefaultXmlParseOption) -> XMLDocument? {
    if let data = try? Data(contentsOf: url) {
        return XML(xml: data, url: url.absoluteString, encoding: encoding, option: option)
    }
    return nil
}

/**
Parse HTML

@param html     an HTML string
@param url      the base URL to use for the document
@param encoding the document encoding
@param options  a ParserOption
*/
public func HTML(html: String, url: String?, encoding: UInt, option: ParseOption = kDefaultHtmlParseOption) -> HTMLDocument? {
    switch option {
    case .htmlParseUseLibxml(let opt):
        return libxmlHTMLDocument(html: html, url: url, encoding: encoding, option: opt.rawValue)
    default:
        return nil
    }
}

public func HTML(html: String, encoding: UInt, option: ParseOption = kDefaultHtmlParseOption) -> HTMLDocument? {
    return HTML(html: html, url: nil, encoding: encoding, option: option)
}

// NSData
public func HTML(html: Data, url: String?, encoding: UInt, option: ParseOption = kDefaultHtmlParseOption) -> HTMLDocument? {
    if let htmlStr = NSString(data: html, encoding: encoding) as? String {
        return HTML(html: htmlStr, url: url, encoding: encoding, option: option)
    }
    return nil
}

public func HTML(html: Data, encoding: UInt, option: ParseOption = kDefaultHtmlParseOption) -> HTMLDocument? {
    return HTML(html: html, url: nil, encoding: encoding, option: option)
}

// NSURL
public func HTML(url: URL, encoding: UInt, option: ParseOption = kDefaultHtmlParseOption) -> HTMLDocument? {
    if let data = try? Data(contentsOf: url) {
        return HTML(html: data, url: url.absoluteString, encoding: encoding, option: option)
    }
    return nil
}

/**
Searchable
*/
public protocol Searchable {
    /**
    Search for node from current node by XPath.
    
    @param xpath
    */
    func xpath(_ xpath: String, namespaces: [String:String]?) -> XMLNodeSet
    func xpath(_ xpath: String) -> XMLNodeSet
    func at_xpath(_ xpath: String, namespaces: [String:String]?) -> XMLElement?
    func at_xpath(_ xpath: String) -> XMLElement?
    
    /**
    Search for node from current node by CSS selector.
    
    @param selector a CSS selector
    */
    func css(_ selector: String, namespaces: [String:String]?) -> XMLNodeSet
    func css(_ selector: String) -> XMLNodeSet
    func at_css(_ selector: String, namespaces: [String:String]?) -> XMLElement?
    func at_css(_ selector: String) -> XMLElement?
}

/**
SearchableNode
*/
public protocol SearchableNode: Searchable {
    var text: String? { get }
    var toHTML:      String? { get }
    var innerHTML: String? { get }
    var className: String? { get }
    var tagName:   String? { get }
}

/**
XMLElement
*/
public protocol XMLElement: SearchableNode {
    subscript(attr: String) -> String? { get }
}

/**
XMLDocument
*/
public protocol XMLDocument: SearchableNode {
}

/**
HTMLDocument
*/
public protocol HTMLDocument: XMLDocument {
    var title: String? { get }
    var head: XMLElement? { get }
    var body: XMLElement? { get }
}

/**
XMLNodeSet
*/
public final class XMLNodeSet {
    fileprivate var nodes: [XMLElement] = []
    
    public var toHTML: String? {
        let html = nodes.reduce("") {
            if let text = $1.toHTML {
                return $0 + text
            }
            return $0
        }
        return html.isEmpty == false ? html : nil
    }
    
    public var innerHTML: String? {
        let html = nodes.reduce("") {
            if let text = $1.innerHTML {
                return $0 + text
            }
            return $0
        }
        return html.isEmpty == false ? html : nil
    }
    
    public var text: String? {
        let html = nodes.reduce("") {
            if let text = $1.text {
                return $0 + text
            }
            return $0
        }
        return html
    }
    
    public subscript(index: Int) -> XMLElement {
        return nodes[index]
    }
    
    public var count: Int {
        return nodes.count
    }
    
    internal init() {
    }
    
    internal init(nodes: [XMLElement]) {
        self.nodes = nodes
    }
    
    public func at(_ index: Int) -> XMLElement? {
        return count > index ? nodes[index] : nil
    }
    
    public var first: XMLElement? {
        return at(0)
    }
    
    public var last: XMLElement? {
        return at(count-1)
    }
}

extension XMLNodeSet: Sequence {
    public typealias Iterator = AnyIterator<XMLElement>
    public func makeIterator() -> Iterator {
        var index = 0
        return AnyIterator {
            if index < self.nodes.count {
                return self.nodes[index++]
            }
            return nil
        }
    }
}
