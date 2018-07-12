import javax.inject.Inject;

import org.daisy.pipeline.datatypes.DatatypeService;
import org.daisy.pipeline.script.XProcScriptService;

import org.daisy.pipeline.junit.AbstractXSpecAndXProcSpecTest;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class ServicesTest extends AbstractXSpecAndXProcSpecTest {
	
	@Inject
	public DatatypeService datatype;
	
	@Test
	public void testDatatype() {
		assertEquals("px:script-option-1", datatype.getId());
	}
	
	@Inject
	public XProcScriptService script;
	
	@Test
	public void testScript() {
		assertEquals("script", script.getId());
	}
	
	/* ------------- */
	/* For OSGi only */
	/* ------------- */
	
	@Override
	protected String[] testDependencies() {
		return new String[]{
			"org.daisy.pipeline:framework-core:?",
			"org.daisy.pipeline:modules-registry:?"
		};
	}
}
