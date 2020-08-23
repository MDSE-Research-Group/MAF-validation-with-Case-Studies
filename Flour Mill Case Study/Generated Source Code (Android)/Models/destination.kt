
package Models

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty

data class Destination (val location : String) {
@JacksonXmlElementWrapper(localName = "inputs") @JacksonXmlProperty(localName = "Input") 
 var inputs : List<Input> 

	init {
        inputs= listOf()
    }
    constructor(loc: String, inputs: List<Input>): this(loc){
        this.inputs = inputs
    }
}
