public class SleepStep_Provider_SPI
       extends SleepStep.Provider
       implements org.daisy.common.spi.ServiceWithProperties
{
	
	private static final org.slf4j.Logger spi_log = org.slf4j.LoggerFactory.getLogger(SleepStep_Provider_SPI.class);
	
	private final java.util.Map spi_props;
	
	public SleepStep_Provider_SPI() {
		super();
		spi_log.trace("Creating SleepStep_Provider");
		spi_props = new java.util.HashMap();
		spi_props.put("type", "{http://www.daisy.org/ns/pipeline/xproc}sleep");
	}
	
	public java.util.Map spi_getProperties() {
		return spi_props;
	}
}
